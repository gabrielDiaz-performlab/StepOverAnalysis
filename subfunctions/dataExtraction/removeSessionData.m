function [] = removeSessionData(sessionNumber)

loadParameters

sessionFileName = ['session' dataFileList{sessionNumber}];
sessionFilePath = [ sessionFileDir sessionFileName '.mat'];

if exist(sessionFilePath, 'file') == 2
    delete(sessionFilePath)
end
