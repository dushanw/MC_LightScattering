
function [x, y, z, ux, uy, uz, L, atSurf] = f_launch(pram)

  x     = zeros(pram.Nphotons,1);                             % [um]      cartesian coordinates  
  y     = zeros(pram.Nphotons,1);
  z     = zeros(pram.Nphotons,1) + pram.z0_um;

  L     = zeros(pram.Nphotons,1);                             % [um]      path-length for each photon

  theta = rand(pram.Nphotons,1)*pi;                           % [rad]     spherical coordinates, launch initialization
  psi   = rand(pram.Nphotons,1)*2*pi;

  ux    = sin(theta).*cos(psi);                               %           propagation direction vectors
  uy    = sin(theta).*sin(psi);
  uz    = cos(theta); 

  if pram.useGpu == 1
    x   = gpuArray(x );
    y   = gpuArray(y );
    z   = gpuArray(z );
    ux  = gpuArray(ux);
    uy  = gpuArray(uy);
    uz  = gpuArray(uz);
    L   = gpuArray(L );    
  end
  
  atSurf = [];  
end