function [x, y, z, ux, uy, uz] = f_catAllSims(x,y,z,ux,uy,uz,pram)

  if pram.useGpu == 1
    for i = 1:pram.Nsims
      x {i} = gather(x {i});
      y {i} = gather(y {i});
      z {i} = gather(z {i});
      ux{i} = gather(ux{i});
      uy{i} = gather(uy{i});
      uz{i} = gather(uz{i});
    end
  end


  x     = cat(1,x {:});
  y     = cat(1,y {:});
  z     = cat(1,z {:});
  ux    = cat(1,ux{:});
  uy    = cat(1,uy{:});
  uz    = cat(1,uz{:});
  
end