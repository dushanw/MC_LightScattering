
function [x_backProp, y_backProp, z_backProp, sPSF, sPSF_axis] = f_backProp(x,y,z,ux,uy,uz,atSurf,pram)

  if pram.useGpu == 1
    x       = gather(x     );
    y       = gather(y     );
    z       = gather(z     );
    ux      = gather(ux    );
    uy      = gather(uy    );
    uz      = gather(uz    );
    atSurf  = gather(atSurf);
  end

  s_backProp  = pram.z0_um./uz(atSurf);
  
  x_backProp  = x(atSurf) + s_backProp .* ux(atSurf);
  y_backProp  = y(atSurf) + s_backProp .* uy(atSurf);
  z_backProp  = z(atSurf) + s_backProp .* uz(atSurf);

  d_bin       = pram.dx;
  edge_val    = floor(pram.Nx/2) * d_bin;  
  [N c]       = hist3(cat(2,x_backProp,y_backProp),'edges',{-edge_val:d_bin:edge_val ...
                                                            -edge_val:d_bin:edge_val ...
                                                           });

  sPSF        = N/sum(N(:));
  sPSF_axis   = c{1};
  
end