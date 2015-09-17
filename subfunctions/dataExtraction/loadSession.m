function sessionData = loadSession(sessionNumber)

loadParameters

expTextFileName = ['exp' dataFileList{sessionNumber}];
mocapTextFileName = ['mocap' dataFileList{sessionNumber}];
sessionFileName = ['session' dataFileList{sessionNumber}];
textFilePath = ['data/raw/' expTextFileName '.txt'];
parsedTextPath  = [ parsedTextFileDir 'parsed' dataFileList{sessionNumber} '.mat'];
sessionFilePath = [ sessionFileDir sessionFileName '.mat'];

%ETG data
etgFilePath = [pwd '\data\ETG data\' ETG_dataFileList{sessionNumber}];

[ETG_T,audioData,Fs] = loadEyeTracker(etgFilePath);

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
        parseExpTextFile(textFileDir, expTextFileName)
        parseMocapTextFile(textFileDir, mocapTextFileName)
        
    end
    
    %% Generate session struct
    fprintf('Generating session struct.\n');
    
    sessionData = createSessionStruct(parsedTextPath);
    
    sessionData = findTemporalSpikes(sessionData, audioData, fAudio, Fs, 1);
    sessionData = processEyeTracker(sessionData, ETG_T);
    sessionData.expInfo.fileID = dataFileList{sessionNumber};
    sessionData.expInfo.numConditions = numConditions;
    sessionData.expInfo.numObsHeights = numObsHeights;
    
    %FIXME:  add leg length
    %sessionData.expInfo.legLength = sessionData.expInfo.obstacleHeights(1) ./ sessionData.expInfo.obsHeightRatios(1)
    
    save( sessionFilePath,'sessionData')
    fprintf ('Session struct created from .mat file and saved\n' )
    
end
    
    
