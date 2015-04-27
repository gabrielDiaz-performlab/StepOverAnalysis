function getFigureLayout

figHandles = findobj('Type','figure');

figString = [];

for idx = 1:numel(figHandles)
    
    figNum = figHandles(idx);
    set(figNum,'Units','Normalized')
    %%
    
    figString = [figString  sprintf('set(%s,\''Units\'',\''Normalized\'',\''Position\'',%s);\n',mat2str(get(figNum,'Number')),mat2str(get(figNum,'Position'),2))];
    
    %figString = [ figString sprintf('set(%1.0f,\''Units\'',\''Normalized\'',\''Position\'',%s);\n',figNum,mat2str(get(figNum,'Position'),2))];
    %figString = sprintf('set(%s,\''Units\'',\''Normalized\'',\''Position\'',%s);\n',mat2str(get(gcf,'Number')),mat2str(get(gcf,'Position')))

end
    
clipboard('copy', figString)

display('SetPos string copied to clipboard')


