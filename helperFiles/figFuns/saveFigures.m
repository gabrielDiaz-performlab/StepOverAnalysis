
figHandles = findobj('Type','figure');

figString = [];
myImage = [];

screenRes = get(0,'ScreenSize');

for idx = 1:numel(figHandles)
    
    clear myImage
    
    if( ~isempty(focusOnBlocks))
        figString = ['Figures/' sprintf('Bl%s',mat2str(focusOnBlocks))  '-' mat2str(figHandles(idx)) '-'  sprintf('%1.0f',subNum) '.png'];
    else
        figString = ['Figures/' mat2str(figHandles(idx)) '-'  sprintf('%1.0f',subNum) '.png'];
    end
    
    
    %myImage = frame2im(getframe(figHandles(idx)) );
    %saveas(figHandles(idx),figString)
    
    myImage = frame2im(getframe(figHandles(idx)) );
    imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');
    
end

display('Figures saved to /Figures/')