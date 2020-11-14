% 20201113 by Dushan N. Wadduwage
% References: https://omlc.org/classroom/ece532/class4/trmc/index.html
%             https://omlc.org/software/mc/Jacques2011_MonteCarlo_Welch&VanGemert.pdf

%% main simulation function 
function main(pram)
  
  mkdir(pram.savepath);

  [x, y, z, ux, uy, uz, L] = f_launch(pram);                  %           Launch photons at [x=0 y=0 z=pram.z0_um]
  tic
  for ii = 1:pram.NtimePts
    ii

    [x, y, z, L, atSurf] = f_hop(x,y,z,ux,uy,uz,L,pram);      %           Hop photons to next position  
    [ux, uy, uz]         = f_spin(ux,uy,uz,atSurf,pram);      %           Spin the photon trajectory due to scattering
  end
  toc

  [x_backProp, y_backProp, z_backProp, sPSF, sPSF_axis] = f_backProp(x,y,z,ux,uy,uz,atSurf,pram);

  close all
  save([pram.savepath pram.fNameStem '_sPSF.mat'],'sPSF','sPSF_axis','pram');
end