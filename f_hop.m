

function [x, y, z, L, atSurf] = f_hop(x,y,z,ux,uy,uz,L,pram)

  if pram.useGpu == 0
    rnd1    = rand(pram.Nphotons,1);
  else
    rnd1    = rand(pram.Nphotons,1,"gpuArray");
  end

  s         = 1e4 * (-log(rnd1)/pram.mus);  % [um]   Step size. log() is base e. In the theory s = -ln(1-rnd)/μ_s [cm]... 
                                            %        But for any 2 random numbers rnd2 = 1-rnd1.
    
  atSurf    = find(z + s .* uz >= 0);       %        propergate only to the boundary
  s(atSurf) = - z(atSurf)./uz(atSurf);      %        calculate the distance to the boundary and only propergate to the ... 
                                            %        boundary (i.e. a -z./uz distance)
  
  x         = x + s .* ux;
  y         = y + s .* uy;
  z         = z + s .* uz;

  L         = L + s;

end