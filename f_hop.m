

function [x, y, z, L, atSurf] = f_hop(x,y,z,ux,uy,uz,L,pram)

  if pram.useGpu == 0
    rnd1      = rand(pram.Nphotons,1);
  else
    rnd1      = rand(pram.Nphotons,1,"gpuArray");
  end

  s         = 1e4 * (-log(rnd1)/pram.mus); % [um]      Step size.  Note: log() is base e
  
  atSurf    = find(z + s .* uz >= 0);      %           propergate only to the boundary
  s(atSurf) = - z(atSurf)./uz(atSurf); 
  
  x         = x + s .* ux;
  y         = y + s .* uy;
  z         = z + s .* uz;

  L         = L + s;

end