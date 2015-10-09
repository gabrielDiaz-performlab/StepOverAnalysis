

figHandles = findobj('Type','figure');

figString = [];
myImage = [];

screenRes = get(0,'ScreenSize');

for idx = 1:numel(figHandles)
    
    clear myImage
    
    figString = ['Figures/AvgFigs/' mat2str(figHandles(idx)) '-AVG'  '.png'];
    figure(figHandles(idx));
    myImage = frame2im(getframe(figHandles(idx)) );
    imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');
    
    
    %myImage = frame2im(getframe(figHandles(idx)) );
    %saveas(figHandles(idx),figString)
    
    
    %export_fig(['Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.tif'],'-r600','-painters')

   %export_fig(['Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.pdf'],'-painters')
   %export_fig(['Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.tif'],'-r600','-painters')
    %saveStr = ['export_fig -painters -transparent ' 'Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.eps'];
    %export_fig(['Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.eps'],'-painters','-transparent')
    
    %print(gcf,'-depsc2','-painters',['Figures/AvgFigs/'  'AVG-'  mat2str(figHandles(idx)) '.eps']);
    
end

display('Figures saved to /Figures/')