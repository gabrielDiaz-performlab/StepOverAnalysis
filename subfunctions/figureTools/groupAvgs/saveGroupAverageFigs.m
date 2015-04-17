function [] = saveGroupAverageFigs(betweenGroupsFigStruct,sessionFileList)

loadParameters

% Write subject filenames to a .txt that is also stored in this dir.
sessionListFName = sprintf('group-%s',date);
sessionListFPath = ['figures/' sessionListFName '/'];

try
    rmdir(sessionListFPath)
end

saveFigStructToDir(sessionListFName,betweenGroupsFigStruct);

fid = fopen([sessionListFPath sessionListFName '.txt'],'w+');

for sIdx = 1:numel(sessionFileList)
    
    sessionNumber = sessionFileList(sIdx);
    fprintf(fid,'%s\n',dataFileList{sessionNumber});

end

fclose(fid);
