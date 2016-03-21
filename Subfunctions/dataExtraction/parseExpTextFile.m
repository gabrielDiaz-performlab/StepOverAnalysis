function parseExpTextFile(textFileDir, textFileName)

loadParameters

%fieldNames = fieldnames(structHandler{1,1});
%numberOfLines = numel(fieldNames);


%% First, count the number of lines in the text file

fid = fopen([textFileName '.txt']);
numberOfLines = 0;
chunksize = 1e6; % read chuncks of 1MB at a time

while ~feof(fid)
    ch = fread(fid, chunksize, '*uchar');
    if isempty(ch)
        break
    end
    numberOfLines = numberOfLines + sum(ch == sprintf('\n'));
end

fclose(fid);

%%  Initialize all of my variables

% Per experiment
legLengthCM = zeros(numberOfLines, 1);
trialType = zeros(numberOfLines, 1);

% Per trial
collision_XYZ = zeros(numberOfLines, 3);
trialType = zeros(numberOfLines, 1);
obstacle_XYZ = zeros(numberOfLines, 3);
walkingDirection = zeros(numberOfLines, 1);
blockNum = zeros(numberOfLines, 1);

% Per frame
frameTime_fr = zeros(numberOfLines, 1);
sysTime_fr = zeros(numberOfLines, 1);
eventFlag_fr = zeros(numberOfLines, 1);
isBlankTrial = zeros(numberOfLines, 1);

rFoot_fr_XYZ = nan(numberOfLines, 3);
lFoot_fr_XYZ = nan(numberOfLines, 3);
glasses_fr_XYZ = nan(numberOfLines, 3);
viewPos_fr_XYZ = nan(numberOfLines, 3);

rFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
lFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
glassesQuat_fr_WXYZ = nan(numberOfLines, 4);
viewQuat_fr_WXYZ= nan(numberOfLines, 4);

fid = fopen([textFileName '.txt']);

trialNum = 0;
i = 1;

while ~feof(fid)
%for i = 1:numberOfLines
    
    currentLine = fgetl(fid);

    %% ============= Experiment metadata ==================
    %% =======================================================
    if( i == 1 )
        
        legLengthCM = extractVarFromLine(currentLine, 'legLengthCM', 1  );
        maxTrialDuration = extractVarFromLine(currentLine, 'maxTrialDuration', 1  );
        numBlocks = extractVarFromLine(currentLine, 'numBlocks', 1  );
        
        mocapRefresh = extractVarFromLine(currentLine, 'mocapRefresh', 1  );
        mocapInterp = extractVarFromLine(currentLine, 'mocapInterp', 1  );
        mocapPostProcess = extractVarFromLine(currentLine, 'mocapPostProcess', 1  );
        
        i = i+1;
        continue
    end
    

    
    %% ============= Frame Time and Sys Time==================
    %% =======================================================
    
    %frameTime(i) = extractVarFromLine(currentLine, 'frameTime', 1  );
    sysTime_fr(i) = extractVarFromLine(currentLine, 'sysTime', 1  );
    
    %% ============= Event Flag ==================
    %% ===========================================
    
    eventFlag(i) = extractVarFromLine(currentLine, 'eventFlag', 1  );
    
    % ======================================================================================
    % ======================================================================================
    
    %% ============= Blank Trial Info ============
    
    isBlankTrial(i) = extractVarFromLine(currentLine, 'isBlankTrial', 1);
    
    %% ============= Upon experiment start (evantFlag = X) =================
    % ======================================================================================
    % ======================================================================================
    
    
    %% TODO:  Add experiment start variables
    
    % ======================================================================================
    % ======================================================================================
    %%  ============= Upon trial start (evantFlag = 1) =================
    % ======================================================================================
    % ======================================================================================
    if( eventFlag(i) == 1)
        
        trialNum  = trialNum +1;

        % Trial type is a list of cells
        trialType_tr(trialNum) = {extractVarFromLine(currentLine, 'trialType', 1  )};
        
        isWalkingDownAxis_tr(trialNum) = extractVarFromLine(currentLine, 'isWalkingDownAxis', 1  );
        obstacleHeight_tr(trialNum) = extractVarFromLine(currentLine, 'obstacleHeight', 1  );
        
        obsXYZ = extractVarFromLine(currentLine, 'obstacle_XYZ', 3  );
        obstacle_tr_XYZ(trialNum,:) = obsXYZ([1 3 2]);
        
        standingBoxOffset_negZ(trialNum,:) = extractVarFromLine(currentLine, 'standingBoxOffset_negZ', 1);
        standingBoxOffset_posZ(trialNum,:) = extractVarFromLine(currentLine, 'standingBoxOffset_posZ', 1);
        
        leftFoot_LWH(trialNum,:) = extractVarFromLine(currentLine, 'leftFoot_LWH', 3);
        rightFoot_LWH(trialNum,:) = extractVarFromLine(currentLine, 'rightFoot_LWH', 3);
        
    end
    
    %  ======================================================================================
    %  ======================================================================================
    %% ============= Upon foot/obs collision (eventFlag = 4 or 5) =================
    %  ======================================================================================
    %  ======================================================================================
    
    if( eventFlag(i) == 4 || eventFlag(i) == 5 )
        
        collisionLocOnObs_tr_XYZ(trialNum,:) = extractVarFromLine(currentLine, 'collisionLocOnObs_XYZ', 3  );

    end
    
    %  ======================================================================================
    %  ======================================================================================
    %% ============= Per-frame data =================
    %  ======================================================================================
    %  ======================================================================================
    
    %% ============= Right foot visNode pos + quat =============
    
    data_valIdx = extractVarFromLine(currentLine, 'rFoot_XYZ', 3);
    rFoot_fr_XYZ(i,:) = [ data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    data_valIdx = extractVarFromLine(currentLine, 'rFootQUAT_XYZW', 4);
    rFootQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    %% ============= Left foot visNode pos + quat =============
    
    data_valIdx = extractVarFromLine(currentLine, 'lFoot_XYZ', 3);
    lFoot_fr_XYZ(i,:) = [ data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    data_valIdx = extractVarFromLine(currentLine, 'lFootQUAT_XYZW', 4);
    lFootQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    %% ============= Glasses visNode pos + quat =============
    
    data_valIdx = extractVarFromLine(currentLine, 'glasses_XYZ', 3);
    glasses_fr_XYZ(i,:) = [ data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    data_valIdx = extractVarFromLine(currentLine, 'glassesQUAT_XYZW', 4);
    glassesQUAT_fr_WXYZ(i,:) = [ data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];

    %% ============= MainView visNode pos + quat
    
    data_valIdx = extractVarFromLine(currentLine, 'viewPos_XYZ', 3);
    mainView_fr_XYZ(i,:) = [ data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    data_valIdx = extractVarFromLine(currentLine, 'viewQUAT_XYZW', 4);
    mainViewQUAT_fr_WXYZ(i,:) = [ data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    i = i+1;
end

%%
 
fclose(fid);
 
%


outFileDir = [ 'parsed' textFileName(4:end)];

save ([ parsedTextFileDir outFileDir '.mat'],'sysTime_fr','isBlankTrial','trialType_tr','isWalkingDownAxis_tr',...
    'legLengthCM','eventFlag', 'obstacleHeight_tr','obstacle_tr_XYZ','collision_XYZ',...
    'rFoot_fr_XYZ','lFoot_fr_XYZ','glasses_fr_XYZ','mainView_fr_XYZ',...
    'rFootQUAT_fr_WXYZ','lFootQUAT_fr_WXYZ','glassesQUAT_fr_WXYZ','mainViewQUAT_fr_WXYZ','standingBoxOffset_negZ',...
    'standingBoxOffset_posZ','leftFoot_LWH','rightFoot_LWH');

fprintf ('Parsed exp data saved to text file %s.mat \n', parsedTextFileDir )




