
function f_plotResults(sPSF,sPSF_axis,x_backProp,y_backProp,pram)

  figure('units','normalized','outerposition',[0 0 3/4 3/4])
  subplot(1,2,1);imagesc(sPSF)      ;axis off;axis image; colorbar; title('sPSF');     set(gca,'fontsize',pram.fs)
  subplot(1,2,2);imagesc(log(sPSF)) ;axis off;axis image; colorbar; title('ln(sPSF)'); set(gca,'fontsize',pram.fs)
  saveas(gcf,[pram.savepath pram.fNameStem '_sPSF-img.jpeg']);
  
  figure;
  % semilogy(sPSF_axis,sPSF(round(size(sPSF,1)/2),:),'-k','linewidth',2); title('sPSF cross section');  
                                                                  % this plot is based on a single cross-section of sPSF  
  r             = sqrt(x_backProp.^2+y_backProp.^2);             
  r             = r(find(r<=sPSF_axis(end)));
  [hh rr]       = hist(r,sPSF_axis(round(length(sPSF_axis)/2):end));
  semilogy(rr,hh./(2*pi*rr),'-k','linewidth',2);title('sPSF cross section');    
                                                                  % this plot is based on all integrated cross sections 
  xlim([0 max(sPSF_axis)])
  yticks(10.^(-6:1:0))
  xlabel('x [um]');
  ylabel('Normalized Count [AU]');
  set(gca,'fontsize',pram.fs)
  saveas(gcf,[pram.savepath pram.fNameStem '_sPSF-cross-section.jpeg']);

end