
function pram = f_praminit()

  %% parameters

  % simulation parameters
  pram.Nphotons   = 1E5;                                      % [AU]      set number of photons in simulation 
  pram.NtimePts   = 1000;                                     % [AU]      time points during propergation  
  pram.Nsims      = 1;                                        % [AU]      #simulations
  
  pram.Nx         = 2001;                                     % [AU]      #pixels (in both x,y) in sPSF  
  pram.dx         = 0.05;                                     % [um]      pixel size of sPSF  
  pram.useGpu     = 0;
  
  % optical properties of the imaging system (optical PSF)
  pram.lambda_ex  = 0.8;                                      % [um]      excitation wavelength
  pram.lambda_em  = 0.606;                                    % [um]      emission wavelength
  pram.NA         = 1;                                        % [AU]      numerical aperture of the objective
  
  % optical properties of the tissue
  pram.mus        = 200;                                      % [cm^-1]   scattering coefficient of tissue
  pram.g          = 0.90;                                     % [AU]      anisotropy of scattering of tissue
  pram.nt         = 1.33;                                     % [AU]      refractive index of tissue  
  pram.nm         = 1.33;                                     % [AU]      refractive index of the medium (ex:water,air)  
  pram.sl         = (1/pram.mus)*10*1e3;                      % [um]      sacttering length
  
  % source properties
  pram.z0_um      = -50;                                      % [um]

  % visualization & save parameters
  pram.savepath   = sprintf('./_results/%s/',datetime);
  pram.fNameStem  = sprintf('sls-%d',-pram.z0_um/pram.sl);
  pram.fs         = 24;                                       %           figure font size 

  % application dataset parameters
  pram.datapath   = './_datasets/mnist/';
  
end


