function sessionData = loadSession(sessionNumber)

loadParameters

textFileName = dataFileList{sessionNumber};

textFilePath = ['data/raw/' textFileName '.txt'];
sessionFilePath = [ sessionFileDir textFileName '.mat'];
parsedTextPath  = [ parsedTextFileDir textFileName '-parsed.mat'];

%moreParsedTextPath  = [ moreParsedTextFileDir textFileName '-parsed.mat'];

%% Attempt to load sessionData file
if ( exist(sessionFilePath, 'file'))
    
    % Fixme:  this loads the intermediate struct.
    % I need to rename this file to be distinct from the session struct
    load( sessionFilePath  )
    fprintf('Loaded struct version of text data from %s\n',sessionFilePath  )
    return
    
else
    
    fprintf('Could not find %s. \n', sessionFilePath   );
    
    %% Attempt to load parsedText file
    if (exist(parsedTextPath, 'file'))
        load(parsedTextPath)
        fprintf('Loaded struct version of text data from %s\n',parsedTextFileDir  )
    else
        
        %% Load parsed text file
        
        %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
        fprintf('Could not find moreParsedText file %s. Parsing text file...\n', parsedTextFileDir  );
        
        %textFileStruct = parseTextFiletoStruct(textFilePath);
        parseTextFile(textFileDir, textFileName)
        
    end
    
    %% Generate session struct
    fprintf('Generating session struct.\n');
    
    sessionData = createSessionStruct(parsedTextPath);
    
    sessionData.expInfo.fileID = dataFileList{sessionNumber};
    sessionData.expInfo.numConditions = numConditions ;
    sessionData.expInfo.numObsHeights = numObsHeights ;
    
    sessionData.expInfo
    
    save( sessionFilePath,'sessionData')
    fprintf ('Session struct created from .mat file and saved\n' )
    
end
    
    %
    % %% Check for moreParsedText
    % if (~exist(moreParsedTextPath  , 'file'))
    %
    %     %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
    %     fprintf('generatesessionData: Could not find session file struct file %s. Creating session file...\n', sessionFilePath  );
    %
    %     % createMatFile also called in here
    %     % From *.txt to *-struct.mat
    %     % *-struct.mat to an unstructured sessionFile
    %     parseTextFileToMat(sessionNumber)
    %
    %     % sessionFile is now converted into a structure file
    %     sessionData = generateRawData(sessionFilePath);
    %
    %     sessionData.expInfo.fileID = dataFileList{sessionNumber};
    %
    %     sessionData.expInfo.numConditions = numConditions ;
    %     sessionData.expInfo.numObsHeights = numObsHeights ;
    %
    %     sessionData.expInfo
    %
    %     save( sessionFilePath,'sessionData')
    %     fprintf ('Session struct created from .mat file and saved\n' )
    %
    % else
    %
    %     % Fixme:  this loads the intermediate struct.
    %     % I need to rename this file to be distinct from the session struct
    %     load( moreParsedTextPath  )
    %     % Creates an intermediate mat file
    %     % Creates an intermediate mat in sessionFileDir
    %     % This file is written over in generateRawData
    %     % Must run createMatFile on results (structHandler, textFileDir, textFileName,sessionFileDir)
    %
    %     fprintf('Loaded struct version of text data from %s\n',structFilePath  )
    %     keyboard
    %
    % end
    %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
    
    
