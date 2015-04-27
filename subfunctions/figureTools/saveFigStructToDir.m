function saveFigStructToDir(label,figStruct)


figDir = sprintf('figures/%s/', label);
[junk junk] = mkdir(figDir );

%% Get figure handles

fields_fIdx = fieldnames(figStruct);

for fIdx = 1:numel(fields_fIdx )
    if( ~strcmp(fields_fIdx{fIdx},'expInfo') )
        figHandles(fIdx) = eval( sprintf('figStruct.%s', fields_fIdx{fIdx}'));
    end
end

figString = [];

%%

screenRes = get(0,'ScreenSize');

for idx = 1:numel(figHandles)
    
    
    figH = figHandles(idx);
    set(gca,'color','none')
    set(figH,'Units','Normalized','Position',[0.3 0.15 0.5 0.55]);
    
    %%
    figString = [figDir mat2str(figH.Number) '.pdf'];
    saveas(figH,figString)
    
    %myImage = frame2im(figH);
    %imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');
    
end

