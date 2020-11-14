
function [ux, uy, uz] = f_spin(ux,uy,uz,atSurf,pram)

  if pram.useGpu == 0
    rnd1      = rand(pram.Nphotons,1);
    rnd2      = rand(pram.Nphotons,1);
  else
    rnd1      = rand(pram.Nphotons,1,"gpuArray");
    rnd2      = rand(pram.Nphotons,1,"gpuArray");
  end

  temp      = (1 - pram.g*pram.g)./(1 - pram.g + 2*pram.g* rnd1);
  costheta  = (1 + pram.g*pram.g - temp.*temp)/(2 * pram.g);
  sintheta  = sqrt(1 - costheta.*costheta);
  psi       = rnd2 * 2*pi;
     
  temp      = sqrt(1.0 - uz .* uz);
  uxx       =  sintheta .* (ux .* uz .* cos(psi) - uy .* sin(psi)) ./ temp + ux .* costheta;
  uyy       =  sintheta .* (uy .* uz .* cos(psi) + ux .* sin(psi)) ./ temp + uy .* costheta;
  uzz       = -sintheta .* cos(psi) .* temp                                + uz .* costheta;

  uxx(atSurf) = ux(atSurf);
  uyy(atSurf) = uy(atSurf);
  uzz(atSurf) = uz(atSurf);
  
  ux          = uxx;
  uy          = uyy;
  uz          = uzz;    

end