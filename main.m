% 20201113 by Dushan N. Wadduwage
% References: https://omlc.org/classroom/ece532/class4/trmc/index.html
%             https://omlc.org/software/mc/Jacques2011_MonteCarlo_Welch&VanGemert.pdf

clc;clear all;close all

%% parameters

% simulation parameters
pram.Nphotons   = 1E5;                                      % [AU]      set number of photons in simulation 
pram.NtimePts   = 1000;                                     % [AU]      time points during propergation  

pram.Nx         = 200;                                      % [AU]      #pixels (in both x,y) in sPSF  
pram.dx         = 0.25;                                     % [um]      pixel size of sPSF  

% Optical properties:
pram.mus        = 50;                                       % [cm^-1]   scattering coefficient of tissue
pram.g          = 0.90;                                     % [AU]      anisotropy of scattering of tissue
pram.nt         = 1.33;                                     % [AU]      refractive index of tissue  

% Source properties
pram.z0_um      = -50;                                      % [um]

% visualization & save parameters
pram.savepath   = sprintf('./_results/%s/',datetime);
pram.fNameStem  = sprintf('sls-%d',-pram.z0_um/pram.mus);
pram.fs         = 24;                                       %           figure font size 
mkdir(pram.savepath);

%% simulation
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
