function [] = removeParsedData(sessionNumber)

loadParameters

parsedTextPath  = [ parsedTextFileDir 'parsed' dataFileList{sessionNumber} '.mat'];

if exist(parsedTextPath, 'file') == 2
    delete(parsedTextPath)
end
