% main_psf

Nx = 50;
Ny = 50;
Nz = 50;
dx = .2;        % [um] pixel size 
lambda = 520;   % [nm]
NA = 1;
Rindex = 1;

APSF_3D = Efficient_PSF(NA,Rindex,lambda,dx,Nx,Ny,Nz);
PSF_3D = abs(APSF_3D{1}).^2+abs(APSF_3D{2}).^2+abs(APSF_3D{3}).^2;

% save(sprintf('APSF_3D_%dNA_1RI_%dumdx.mat',NA,dx),'APSF_3D');
% save(sprintf('PSF_3D_%dNA_1RI_%dumdx.mat',NA,dx),'PSF_3D');

imagesc(PSF_3D(:,:,25))
imagesc([abs(APSF_3D{1}(:,:,25))+abs(APSF_3D{2}(:,:,25))+abs(APSF_3D{3}(:,:,25))])




