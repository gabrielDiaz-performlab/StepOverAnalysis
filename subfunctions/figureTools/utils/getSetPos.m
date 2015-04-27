function getSetPos


set(gcf,'Units','Normalized');


figString = sprintf('set(%s,\''Units\'',\''Normalized\'',\''Position\'',%s);\n',mat2str(get(gcf,'Number')),mat2str(get(gcf,'Position')))

clipboard('copy', figString)

display('SetPos string copied to clipboard')

