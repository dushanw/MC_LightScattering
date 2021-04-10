% 2020-xx-xx by Dushan N. Wadduwage (wadduwage@fas.harvard.edu)
% 2021-04-09 edited by dnw to include refraction effect and reejection of out of NA photons from sPSF

function [x_backProp, y_backProp, z_backProp, sPSF, sPSF_axis] = f_backProp(x,y,z,ux,uy,uz,pram)

  %% correct for refraction at the boundary [2021-04-09]
  sinAlpha2_sq  = (pram.nt/pram.nm)^2 .* uz.^2 .* (ux.^2+uy.^2+uz.^2);  
  uzz_sq        = (ux.^2 + uy.^2) .* sinAlpha2_sq ./ (1-sinAlpha2_sq);
  refracted     = find(uzz_sq>=0);                                           % to reject  total internal reflected rays
  
  ux            = ux(refracted);
  uy            = uy(refracted);
  uz            = sqrt(uzz_sq(refracted));                                  % +ve sqrt is take as all rays head up
  x             = x(refracted);
  y             = y(refracted);
  z             = z(refracted);
  
  %% filter out the photons out side the objective NA [2021-04-09]
  sinAlpha      = uz ./ sqrt(ux.^2+uy.^2+uz.^2);
  inNA          = find(sinAlpha <= pram.NA/pram.nm);                        % by the definition of NA => NA = nm * sinAlpha_NA    
  
  ux            = ux(inNA);
  uy            = uy(inNA);
  uz            = uz(inNA);
  x             = x (inNA);
  y             = y (inNA);
  z             = z (inNA);
  
  %% [2020-xx-xx]
  s_backProp  = pram.z0_um./uz;
  
  x_backProp  = x + s_backProp .* ux;
  y_backProp  = y + s_backProp .* uy;
  z_backProp  = z + s_backProp .* uz;

  d_bin       = pram.dx;
  [N c]       = hist3(cat(2,x_backProp,y_backProp),'Ctrs' ,{(-floor(pram.Nx/2):floor(pram.Nx/2))*d_bin ...
                                                            (-floor(pram.Nx/2):floor(pram.Nx/2))*d_bin ...
                                                           });                                                         
                                                         
%  sPSF       = N/sum(N(:));              % this is normalization to all escaped and in-range photons
  sPSF        = N/pram.Nphotons;          % this is normalizaiton to all simulated photons. So NA effect is in here.
  sPSF_axis   = c{1};  
end