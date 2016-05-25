function sessionData = loadSession(sessionNumber)

loadParameters

% Set ReadFromProcessed = 1 if you want to read data from the preprocessed
% structure file. This ensures the program does not re-read the raw text
% files.

ReadFromProcessed = 0;

expTextFileName = ['exp' dataFileList{sessionNumber}];
mocapTextFileName = ['mocap' dataFileList{sessionNumber}];
sessionFileName = ['session' dataFileList{sessionNumber}];
textFilePath = ['data/raw/' expTextFileName '.txt'];
parsedTextPath  = [ parsedTextFileDir 'parsed' dataFileList{sessionNumber} '.mat'];
sessionFilePath = [ sessionFileDir sessionFileName '.mat'];

%ETG data
etgFilePath = [pwd '\data\ETG data\' ETG_dataFileList{sessionNumber}];

[ETG_T,audioData,Fs] = loadEyeTracker(etgFilePath);

len_audioData_s = length(audioData)/Fs;

%moreParsedTextPath  = [ moreParsedTextFileDir textFileName '-parsed.mat'];

%% Attempt to load sessionData file
if exist(sessionFilePath, 'file') && ReadFromProcessed
    
    % Fixme:  this loads the intermediate struct.
    % I need to rename this file to be distinct from the session struct
    load( sessionFilePath  )
    fprintf('Loaded struct version of text data from %s\n',sessionFilePath  )
    return
    
else
    
    fprintf('Could not find %s. \n', sessionFilePath   );
    
    %% Attempt to load parsedText file
    if exist(parsedTextPath, 'file')
        load(parsedTextPath)
        fprintf('Loaded struct version of text data from %s\n',parsedTextFileDir  )
    else
        %% Load parsed text file
        
        %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
        fprintf('Could not find more ParsedText file %s. Parsing text file...\n', parsedTextFileDir  );
        
        %textFileStruct = parseTextFiletoStruct(textFilePath);
        parseExpTextFile(textFileDir, expTextFileName)
        parseMocapTextFile(textFileDir, mocapTextFileName)
        
    end
    
    %% Generate session struct
    fprintf('Generating session struct.\n');
      
    sessionData = createSessionStruct(parsedTextPath);       
    sessionData = findTemporalSpikes(sessionData, audioData, fAudio, Fs, 1);    
    keyboard
    sessionData = processEyeTracker(sessionData, ETG_T, len_audioData_s);
    sessionData.expInfo.fileID = dataFileList{sessionNumber};
    sessionData.expInfo.numConditions = numConditions;
    sessionData.expInfo.numObsHeights = numObsHeights;
    sessionData.expInfo.heights = numObsHeights;
    %FIXME:  add leg length
    %sessionData.expInfo.legLength = sessionData.expInfo.obstacleHeights(1) ./ sessionData.expInfo.obsHeightRatios(1)
    
    %% Remove a particular trial completely
        
    for i = 1:length(DeleteTrials{1})
        sessionData.rawData_tr(DeleteTrials{1}(i)) = [];
    end
    sessionData.expInfo.numTrials = sessionData.expInfo.numTrials - length(DeleteTrials{1});
    
    %%
    sessionData = decodeTimeStamps(sessionData);
    
    save( sessionFilePath,'sessionData')
    fprintf ('Session struct created from .mat file and saved\n' )
    
end
    
    
