
function pram = f_praminit()

  %% parameters

  % simulation parameters
  pram.Nphotons   = 1E5;                                      % [AU]      set number of photons in simulation 
  pram.NtimePts   = 1000;                                     % [AU]      time points during propergation  

  pram.Nx         = 200;                                      % [AU]      #pixels (in both x,y) in sPSF  
  pram.dx         = 0.25;                                     % [um]      pixel size of sPSF  
  pram.useGpu     = 0;
  
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

end