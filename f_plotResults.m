
function f_plotResults(sPSF,sPSF_axis,pram)

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