
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

  edge_val    = pram.Nx/2 * pram.dx;
  d_bin       = pram.dx;
  [N c]       = hist3(cat(2,x_backProp,y_backProp),'edges',{-edge_val+d_bin/2:d_bin:edge_val-d_bin/2 ...
                                                            -edge_val+d_bin/2:d_bin:edge_val-d_bin/2 ...
                                                           });
  
  sPSF        = N/sum(N(:));
  sPSF_axis   = c{1};
  
  figure('units','normalized','outerposition',[0 0 3/4 3/4])
  subplot(1,2,1);imagesc(sPSF)      ;axis off;axis image; colorbar; title('sPSF');     set(gca,'fontsize',pram.fs)
  subplot(1,2,2);imagesc(log(sPSF)) ;axis off;axis image; colorbar; title('ln(sPSF)'); set(gca,'fontsize',pram.fs)
  saveas(gcf,[pram.savepath pram.fNameStem '_sPSF-img.jpeg']);
  
  figure;
  semilogy(sPSF_axis,sPSF(round(size(sPSF,1)/2),:),'-k','linewidth',2);  title('sPSF cross section');  
  xlim([min(sPSF_axis) max(sPSF_axis)])
  yticks(10.^(-6:1:0))
  xlabel('x [um]');
  ylabel('Normalized Count [AU]');
  set(gca,'fontsize',pram.fs)
  saveas(gcf,[pram.savepath pram.fNameStem '_sPSF-cross-section.jpeg']);
end