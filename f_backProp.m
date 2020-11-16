
function [x_backProp, y_backProp, z_backProp, sPSF, sPSF_axis] = f_backProp(x,y,z,ux,uy,uz,pram)

  s_backProp  = pram.z0_um./uz;
  
  x_backProp  = x + s_backProp .* ux;
  y_backProp  = y + s_backProp .* uy;
  z_backProp  = z + s_backProp .* uz;

  d_bin       = pram.dx;
  edge_val    = floor(pram.Nx/2) * d_bin;  
  [N c]       = hist3(cat(2,x_backProp,y_backProp),'edges',{-edge_val:d_bin:edge_val ...
                                                            -edge_val:d_bin:edge_val ...
                                                           });

  sPSF        = N/sum(N(:));
  sPSF_axis   = c{1};
  
end