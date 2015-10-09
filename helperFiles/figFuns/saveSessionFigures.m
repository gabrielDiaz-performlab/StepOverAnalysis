
figHandles = findobj('Type','figure');

figString = [];
myImage = [];

screenRes = get(0,'ScreenSize');

saveDir = sprintf('Figures/%s/',mat2str(sessionDataString));
[junk junk] = mkdir(saveDir);

for idx = 1:numel(figHandles)
    
    clear myImage
    
    if( ~isempty(focusOnBlocks))
        figString = [saveDir sprintf('Bl%s',mat2str(focusOnBlocks))  '-' mat2str(figHandles(idx)) '-'  sprintf('%s',mat2str(sessionDataString)) '.png'];
    else
        figString = [saveDir mat2str(figHandles(idx)) '-'  sprintf('%sf',mat2str(sessionDataString)) '.png'];
    end
    
    myImage = frame2im(getframe(figHandles(idx)) );
    saveas(figHandles(idx),figString)
    myImage = frame2im(getframe(figHandles(idx)) );
    imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');
    
end

display('Figures saved to /Figures/')