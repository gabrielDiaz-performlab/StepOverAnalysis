function saveFigStructToDir(label,figStruct)


figDir = sprintf('figures/%s/', label);
[junk junk] = mkdir(figDir );

%% Get figure handles

fields_fIdx = fieldnames(figStruct);

for fIdx = 1:numel(fields_fIdx )
    figHandles(fIdx) = eval( sprintf('figStruct.%s', fields_fIdx{fIdx}'));
end

figString = [];

%%

screenRes = get(0,'ScreenSize');

for idx = 1:numel(figHandles)
    
    figH = figHandles(idx);
    set(figH,'Units','Normalized','Position',[0.3 0.15 0.5 0.7]);
    
    %%
    
    clear myImage
    figString = [figDir mat2str(figH.Number) '.png'];
    saveas(figH,figString)
    
    %myImage = frame2im(figH);
    %imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');

end
  
