function sessionData = generatesessionData(sessionNumber)

loadParameters

textFileName = dataFileList{sessionNumber};

sessionFilePath = [ sessionFileDir textFileName '.mat'];

structFilePath  = [ structFileDir textFileName '-struct.mat'];

%% See if the txt has been parsed into a struct saved in a *.mat file.
if (~exist(sessionFilePath  , 'file'))
    
    %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
    fprintf('generatesessionData: Could not find session file struct file %s. Creating session file...\n', sessionFilePath  );
    
    parseTextFileToMat(sessionNumber)
    
    sessionData = generateRawData(sessionFilePath );
    
    sessionData.expInfo.fileID = dataFileList{sessionNumber};
    
    sessionData.expInfo.numConditions = numConditions ;
    sessionData.expInfo.numObsHeights = numObsHeights ;
    
    sessionData.expInfo
    
    save( sessionFilePath,'sessionData')
    
    fprintf ('Session struct created from .mat file and saved\n', sessionFilePath  )
    
else
    load( sessionFilePath  )
    fprintf('Loaded struct version of text data from %s\n',structFilePath  )
    
end


