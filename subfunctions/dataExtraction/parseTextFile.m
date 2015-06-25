function parseTextFile(textFileDir, textFileName)

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

rFoot_fr_XYZ = nan(numberOfLines, 3);
lFoot_fr_XYZ = nan(numberOfLines, 3);
glasses_fr_XYZ = nan(numberOfLines, 3);
viewPos_fr_XYZ = nan(numberOfLines, 3);

rFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
lFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
glassesQuat_fr_WXYZ = nan(numberOfLines, 4);
viewQuat_fr_WXYZ= nan(numberOfLines, 4);


% If I knew the number of trials, I could initialize these and use a parfor
% loop
% glasseSysTime_tr_CmIdx_mFr_xyz 
% glassesMData_tr_CmIdx_mFr_xyz 
% rFootSysTime_tr_CmIdx_mFr 
% rFootMData_tr_CmIdx_mFr_xyz
% lFootSysTime_tr_CmIdx_mFr 
% lFootMData_tr_CmIdx_mFr_xyz
        
%% Read the text file into memory

% chunkSize = 100;
% numChunks = numberOfLines/100;
% chIdx = 1
%%

% for chIdx = 1:numChunks
%
%     startLine = 1 + (chIdx-1)*chunkSize;
%
%     endLine = 1 + chIdx*chunkSize;
%
%     if(endLine >= numberOfLines-1 )
%         endLine = numberOfLines;
%     end
%
%textData = textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', linenum-1);
%textData  = textread([textFileName '.txt'], '%s','delimiter', '\n');

fid = fopen([textFileName '.txt']);

trialNum = 0;
i = 1;

while ~feof(fid)
%for i = 1:numberOfLines
    
    currentLine = fgetl(fid);

    %% ============= Frame Time and Sys Time==================
    %% =======================================================
    
    %frameTime(i) = extractVarFromLine(currentLine, 'frameTime', 1  );
    sysTime(i) = extractVarFromLine(currentLine, 'sysTime', 1  );
    
    %% ============= Event Flag ==================
    %% ===========================================
    
    eventFlag(i) = extractVarFromLine(currentLine, 'eventFlag', 1  );
    
    
    % ======================================================================================
    % ======================================================================================
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
        %legLengthCM_tr(trialNum) = extractVarFromLine(currentLine, 'legLengthCM', 1  );
        %walkingDirection_tr(trialNum) = extractVarFromLine(currentLine, 'WalkingDirection', 1  );
        %blockNum_tr(trialNum) = extractVarFromLine(currentLine, 'blockNum', 1  );
        
        % Trial type is a list of cells
        trialType_tr(trialNum) = {extractVarFromLine(currentLine, 'trialType', 1  )};
        
        isWalkingDownAxis_tr(trialNum) = extractVarFromLine(currentLine, 'isWalkingDownAxis', 1  );
        obstacleHeight_tr(trialNum) = extractVarFromLine(currentLine, 'obstacleHeight', 1  );
        
        obsXYZ = extractVarFromLine(currentLine, 'Obstacle_XYZ', 3  );
        obstacle_tr_XYZ(trialNum,:) = obsXYZ([0 3 2]);
        
    end
    
    %  ======================================================================================
    %  ======================================================================================
    %% ============= Upon foot/obs collision (evantFlag = 4 or 5) =================
    %  ======================================================================================
    %  ======================================================================================
    
    if( eventFlag(i) == 4 || eventFlag(i) == 5 )
        collisionLocOnObs_tr_XYZ(trialNum,:) = extractVarFromLine(currentLine, 'collisionLocOnObs_XYZ', 3  );
    end
    
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
    glassesQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];

    %% ============= MainView visNode pos + quat
    
    data_valIdx = extractVarFromLine(currentLine, 'viewPos_XYZ', 3);
    mainView_fr_XYZ(i,:) = [ data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    data_valIdx = extractVarFromLine(currentLine, 'viewQUAT_XYZW', 4);
    mainViewQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
    
    
    %  ======================================================================================
    %  ======================================================================================
    %% ============= Upon trial end (evantFlag = 6 or 7) =================
    %  ======================================================================================
    %  ======================================================================================
    
    
    if( eventFlag(i) == 6 || eventFlag(i) == 7 )
        
        %  ============= BUFFERED DATA
        [glassesM0time_mFr glassesM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'glassesRb', 0);
        [glassesM1time_mFr glassesM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'glassesRb', 1);
        [glassesM2time_mFr glassesM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'glassesRb', 2);
        [glassesM3time_mFr glassesM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'glassesRb', 3);
        [glassesM4time_mFr glassesM4_mFr_xyz] = getBufferedMarkerData(currentLine, 'glassesRb', 4);
        
        %glasseSysTime_tr_CmIdx_mFr_xyz(trialNum) = {[glassesM0time_mFr glassesM1time_mFr glassesM2time_mFr glassesM3time_mFr glassesM4time_mFr]'};
        %glassesMData_tr_CmIdx_mFr_xyz(trialNum) = {[glassesM0_mFr_xyz glassesM1_mFr_xyz glassesM2_mFr_xyz glassesM3_mFr_xyz glassesM4_mFr_xyz]'};

        glassesSysTime_tr_mIdx_CmFr(trialNum,1) = {glassesM0time_mFr}; 
        glassesSysTime_tr_mIdx_CmFr(trialNum,2) = {glassesM1time_mFr};
        glassesSysTime_tr_mIdx_CmFr(trialNum,3) = {glassesM2time_mFr};
        glassesSysTime_tr_mIdx_CmFr(trialNum,4) = {glassesM3time_mFr};
        glassesSysTime_tr_mIdx_CmFr(trialNum,5) = {glassesM4time_mFr};
        
        glassesMData_tr_mIdx_CmFr_xyz(trialNum,1) = {glassesM0_mFr_xyz}; 
        glassesMData_tr_mIdx_CmFr_xyz(trialNum,2) = {glassesM1_mFr_xyz}; 
        glassesMData_tr_mIdx_CmFr_xyz(trialNum,3) = {glassesM2_mFr_xyz}; 
        glassesMData_tr_mIdx_CmFr_xyz(trialNum,5) = {glassesM4_mFr_xyz}; 
        
        %%

        [rFootM0time_mFr rFootM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'rFoorRb', 5); % Note the typo "rFoorRb".  I will fix this.
        [rFootM1time_mFr rFootM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'rFoorRb', 6); % If there is an error here, it may be becuase I fixed the text
        [rFootM2time_mFr rFootM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'rFoorRb', 7); 
        [rFootM3time_mFr rFootM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'rFoorRb', 8);

        rFootSysTime_tr_mIdx_CmFr(trialNum,1) = {rFootM0time_mFr}; 
        rFootSysTime_tr_mIdx_CmFr(trialNum,2) = {rFootM1time_mFr};
        rFootSysTime_tr_mIdx_CmFr(trialNum,3) = {rFootM2time_mFr};
        rFootSysTime_tr_mIdx_CmFr(trialNum,4) = {rFootM3time_mFr};
        
        rFootMData_tr_mIdx_CmFr_xyz(trialNum,1) = {rFootM0_mFr_xyz}; 
        rFootMData_tr_mIdx_CmFr_xyz(trialNum,2) = {rFootM1_mFr_xyz}; 
        rFootMData_tr_mIdx_CmFr_xyz(trialNum,3) = {rFootM2_mFr_xyz}; 
        rFootMData_tr_mIdx_CmFr_xyz(trialNum,4) = {rFootM3_mFr_xyz}; 
        
        
        %%
        [lFootM0time_mFr lFootM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'lFootRb', 9);
        [lFootM1time_mFr lFootM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'lFootRb', 10);
        [lFootM2time_mFr lFootM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'lFootRb', 11);
        [lFootM3time_mFr lFootM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'lFootRb', 12);
        
        lFootSysTime_tr_mIdx_CmFr(trialNum,1) = {lFootM0time_mFr}; 
        lFootSysTime_tr_mIdx_CmFr(trialNum,2) = {lFootM1time_mFr};
        lFootSysTime_tr_mIdx_CmFr(trialNum,3) = {lFootM2time_mFr};
        lFootSysTime_tr_mIdx_CmFr(trialNum,4) = {lFootM3time_mFr};
        
        lFootMData_tr_mIdx_CmFr_xyz(trialNum,1) = {lFootM0_mFr_xyz}; 
        lFootMData_tr_mIdx_CmFr_xyz(trialNum,2) = {lFootM1_mFr_xyz}; 
        lFootMData_tr_mIdx_CmFr_xyz(trialNum,3) = {lFootM2_mFr_xyz}; 
        lFootMData_tr_mIdx_CmFr_xyz(trialNum,4) = {lFootM3_mFr_xyz}; 
        
        %% Quats and positions
        
        [glassRbSysTime_mFr glassRbPos_mFr_xyz glassRbQuatSysTime_mFr glassRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'glassesRb');
        [lFootRbSysTime_mFr lFootRbPos_mFr_xyz lFootRbQuatSysTime_mFr lFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'lFootRB');
        [rFootRbSysTime_mFr rFootRbPos_mFr_xyz rFootRbQuatSysTime_mFr rFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'rFootRb');

        
    end
    
    i = i+1;
end



%%

fclose(fid);
 
%%

save ([ parsedTextFileDir textFileName '-parsed.mat'],'trialType_tr','isWalkingDownAxis_tr',...
    'eventFlag', 'obstacleHeight_tr','obstacle_tr_XYZ','collision_XYZ',...
    'glassesSysTime_tr_mIdx_CmFr','glassesMData_tr_mIdx_CmFr_xyz',...
    'rFootSysTime_tr_mIdx_CmFr','rFootMData_tr_mIdx_CmFr_xyz',...
    'lFootSysTime_tr_mIdx_CmFr','lFootMData_tr_mIdx_CmFr_xyz',...
    'rFoot_fr_XYZ','lFoot_fr_XYZ','glasses_fr_XYZ','mainView_fr_XYZ',...
    'rFootQUAT_fr_WXYZ','lFootQUAT_fr_WXYZ','glassesQUAT_fr_WXYZ','mainViewQUAT_fr_WXYZ',...
    'glassRbSysTime_mFr','glassRbPos_mFr_xyz','glassRbQuatSysTime_mFr','glassRbQuat_mFr_xyz',...
    'lFootRbSysTime_mFr','lFootRbPos_mFr_xyz','lFootRbQuatSysTime_mFr','lFootRbQuat_mFr_xyz',...
    'rFootRbSysTime_mFr','rFootRbPos_mFr_xyz','rFootRbQuatSysTime_mFr','rFootRbQuat_mFr_xyz');

fprintf ('Parsed text save to file %s.mat \n', parsedTextFileDir )




