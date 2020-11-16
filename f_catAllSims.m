function [x, y, z, ux, uy, uz] = f_catAllSims(x,y,z,ux,uy,uz,pram)

  x     = cat(1,x {:});
  y     = cat(1,y {:});
  z     = cat(1,z {:});
  ux    = cat(1,ux{:});
  uy    = cat(1,uy{:});
  uz    = cat(1,uz{:});
  
  if pram.useGpu == 1
    x   = gather(x );
    y   = gather(y );
    z   = gather(z );
    ux  = gather(ux);
    uy  = gather(uy);
    uz  = gather(uz);
  end

end