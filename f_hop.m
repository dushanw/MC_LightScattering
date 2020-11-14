

function [x, y, z, L, atSurf] = f_hop(x,y,z,ux,uy,uz,L,pram)

  s         = 1e4 * (-log(rand(pram.Nphotons,1))/pram.mus); % [um]      Step size.  Note: log() is base e
  
  atSurf    = find(z + s .* uz >= 0);                       %           propergate only to the
  s(atSurf) = - z(atSurf)./uz(atSurf); 
  
  x         = x + s .* ux;
  y         = y + s .* uy;
  z         = z + s .* uz;

  L         = L + s;

end