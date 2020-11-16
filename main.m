% 20201113 by Dushan N. Wadduwage
% References: https://omlc.org/classroom/ece532/class4/trmc/index.html
%             https://omlc.org/software/mc/Jacques2011_MonteCarlo_Welch&VanGemert.pdf

%% main simulation function 
function main(pram)

  % setup parallel pool for gpu case
  if pram.useGpu == 1 
    if isempty(gcp('nocreate'))
      parpool(gpuDeviceCount);
    else
      if gcp('nocreate').NumWorkers~=gpuDeviceCount
        delete(gcp('nocreate'))
        parpool(gpuDeviceCount);
      end
    end
  end
  
  mkdir(pram.savepath);
  
  tic
  parfor ii = 1:pram.Nsims    
    [x{ii} , y{ii} , z{ii} ,...
     ux{ii}, uy{ii}, uz{ii},...
     L{ii} , atSurf{ii}]                        = f_launch(pram);               % Launch photons @[x=0 y=0 z=pram.z0_um]
    
    for jj = 1:pram.NtimePts
      fprintf('sim = %d | iter = %d\n',ii,jj)
      
      [x{ii}, y{ii}, z{ii}, L{ii}, atSurf{ii}]  = f_hop(x{ii} ,y{ii} ,z{ii} ,...
                                                        ux{ii},uy{ii},uz{ii},...
                                                        L{ii} ,pram);           % Hop photons to next position  
      [ux{ii}, uy{ii}, uz{ii}]                  = f_spin(ux{ii},uy{ii},uz{ii},...
                                                           atSurf{ii},pram);    % Spin the photon trajectory due to
                                                                                % scattering
    end
    
    x {ii}  = x {ii}(atSurf{ii}); 
    y {ii}  = y {ii}(atSurf{ii});
    z {ii}  = z {ii}(atSurf{ii});
    ux{ii}  = ux{ii}(atSurf{ii});
    uy{ii}  = uy{ii}(atSurf{ii});
    uz{ii}  = uz{ii}(atSurf{ii});
    L {ii}  = L {ii}(atSurf{ii});
  end
  toc

  [x, y, z, ux, uy, uz]                                 = f_catAllSims(x,y,z,ux,uy,uz,pram);
  [x_backProp, y_backProp, z_backProp,sPSF, sPSF_axis]  = f_backProp  (x,y,z,ux,uy,uz,pram);

  f_plotResults(sPSF,sPSF_axis,pram);
  
  close all
  save([pram.savepath pram.fNameStem '_sPSF.mat'],'sPSF','sPSF_axis','pram');
end






