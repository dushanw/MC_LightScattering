% 20161013 by Dr. Dushan N. Wadduwage (dushanw@mit.edu)
% original sequential implementation by Dr. Vijay Raj Singh (singh.vr@gmail.com)
% Efficient 3D APSF simulation using vectorial model of Debye theory
% Ref: A. Martin, J. Micros, 225, 156-169, 2006.

function PSF_3D = Efficient_PSF(NA,Rindex,lambda,dx,Nx,Ny,Nz)

    tic
    % Initial parameters 
    alpha = asin(NA/Rindex); 
    lambda = lambda/1e3;% convert to um
    dy = dx; 
    dz= dx; % Object space resolution [um]
    
    x = dx*[-Nx/2:1:Nx/2-1]; 
    y = dy*[-Ny/2:1:Ny/2-1]; 
    z = dz*[-Nz/2:1:Nz/2-1]; % Physical dimension of grids

    Ntheta = 50; % number of grid in polar angle
    dtheta = alpha/Ntheta;
    theta = [0:Ntheta-1]*dtheta;
 
    % Electric fields related functions
    Phi = calculate_phi(Nx); % as per now (Nx==Ny) shold be true;
    A=pi/lambda; % constant

    [X Y THETA] = meshgrid(x, y, theta);
    V =(2*pi/lambda)*sqrt(X.^2+Y.^2);  
    % calculate intermediate functions that depends on x,y coordinates
    Func0 = sqrt(cos(THETA)).*sin(THETA).*(1+cos(THETA))...
        .*besselj(0,V.*sin(THETA));
    Func1 = sqrt(cos(THETA)).*sin(THETA).^2 ...
        .*besselj(1,V.*sin(THETA));
    Func2 = sqrt(cos(THETA)).*sin(THETA).*(1-cos(THETA)) ...
        .*besselj(2,V.*sin(THETA));

    U = gpuArray((2*pi/lambda)*z);

    % fpr gpu parallelization 
    % segment size shold match to the maximum available memory in the GPU
    % start from a small number increase until the GPU memory error 
    d_segment = 200;
    segment_start = [1:d_segment:Nx];
    segment_end = segment_start+d_segment-1;
    segment_end(end) = Nx;

    for sNo = 1:length(segment_start)
        sNo

        Func0_gpu = gpuArray(Func0(segment_start(sNo):segment_end(sNo),:,:));
        Func1_gpu = gpuArray(Func1(segment_start(sNo):segment_end(sNo),:,:));
        Func2_gpu = gpuArray(Func2(segment_start(sNo):segment_end(sNo),:,:));
        THETA_gpu = gpuArray(THETA(segment_start(sNo):segment_end(sNo),:,:));
        Phi_gpu = gpuArray(Phi(segment_start(sNo):segment_end(sNo),:,:));

        parfor k=1:length(U)% use 4 workers for parallel pool. Otherwise too many data copies are needed.   
            % calculate intermediate functions that depends on z coordinates
            Func3_atThisU = exp((-1)*sqrt(-1)*U(k)*cos(THETA_gpu));

            I0 = trapz(theta,Func0_gpu.*Func3_atThisU,3);
            I1 = trapz(theta,Func1_gpu.*Func3_atThisU,3);
            I2 = trapz(theta,Func2_gpu.*Func3_atThisU,3);

            % Electric fields, IPSF
            Ex = sqrt(-1) * A * (I0+I2.*cos(2*Phi_gpu));
            Ey = sqrt(-1) * A * I2.*sin(2*Phi_gpu);
            Ez =       -2 * A * I1.*cos(Phi_gpu);
            Es = sqrt(-1) * A * I0; % scalar approximation

            % PSF_3D_gpu(:,:,k) = abs(Ex).^2. + abs(Ey).^2.+ abs(Ez).^2;
            PSF_Ex_gpu(:,:,k) = Ex; 
            PSF_Ey_gpu(:,:,k) = Ey;
            PSF_Ez_gpu(:,:,k) = Ez;
        end
        PSF_Ex(segment_start(sNo):segment_end(sNo),:,:) = gather(PSF_Ex_gpu);
        PSF_Ey(segment_start(sNo):segment_end(sNo),:,:) = gather(PSF_Ey_gpu);
        PSF_Ez(segment_start(sNo):segment_end(sNo),:,:) = gather(PSF_Ez_gpu);
        
        clear PSF_Ex_gpu
        clear PSF_Ey_gpu
        clear PSF_Ez_gpu
    end
    PSF_3D = {PSF_Ex, PSF_Ey, PSF_Ez};
    %PSF_3D = PSF_3D./max(PSF_3D(:));
    toc

end
