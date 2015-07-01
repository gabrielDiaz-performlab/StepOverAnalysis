function sessionStruct =  createSessionStruct(parsedDataPath)
    
    
    %MatFileName = 'Exp_RawMat_exp_data-2014-11-26-16-38.mat';
    load(parsedDataPath)
    loadParameters
    
    sessionStruct = struct;
    
    expInfo = struct;
    expInfo.obstacleHeights = [];
    expInfo.trialTypes = [];
    
%     ################################################################
%     ##  Eventflag
% 
%     # 1 Trial Start
%     # 2 
%     # 3 
%     # 4 Right foot collides with obstacle
%     # 5 Left foot collides with obstacle
%     # 6 Trial end
%     # 7 Block end
		
    trialStartFr_tIdx = find(eventFlag == 1 );
    trialStopFr_tIdx = union(find(eventFlag == 6),find(eventFlag == 7));
    blockEndFr_blIdx = find(eventFlag == 7);
    
    %%
    
    clear blockIndex_tr
    
    % The 0 makes it easier to find trials between bIdx-1 and
    % bIdx
    bList = [0 blockEndFr_blIdx];
        
    for bIdx = 1:numel(bList)-1

        trialsInBIdx = intersect( find(trialStartFr_tIdx > bList(bIdx)), find(trialStartFr_tIdx < bList(bIdx+1)));
        blockIndex_tr(trialsInBIdx) = bIdx;
    end
    
    %%  FIXME: LEG LENGTH  
    %sessionStruct.expInfo.legLengthCM  = legLengthCM(1);

    rightFootCollisionFr_cIdx = find(eventFlag == 4 );
    leftFootCollisionFr_idx = find(eventFlag == 5 );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Assemble data into vector of trial structs
    
    % First, create an array of empty structs.
    
    trialStruct = struct;
    numTrials = length(trialStartFr_tIdx);
    trialStructs_tr = repmat(trialStruct, numTrials, 1 );
    
    %% Per trial loop
    for tIdx = 1:numTrials
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Info
        
        info = struct;
        
        
        
        info.excludeTrial = 0;
        info.excludeTrialExplanation = [];
        info.trialModifications_cModIdx = [];
        
        % Add basic trial start/stop info
        info.startFr = trialStartFr_tIdx(tIdx);
        info.stopFr = trialStopFr_tIdx(tIdx);
        
        info.sysTime_fr = sysTime_fr(trialStartFr_tIdx:trialStopFr_tIdx);
        info.eventFlag_fr = eventFlag(trialStartFr_tIdx:trialStopFr_tIdx);
        
        subIsWalkingUpAxis = -isWalkingDownAxis_tr(tIdx);
        info.subIsWalkingUpAxis = subIsWalkingUpAxis;
        
        info.type = trialType_tr(tIdx); 
        info.block = blockIndex_tr(tIdx);

        trialStructs_tr(tIdx).info  = info ;
        
        %frIdxList = trialStartFr_tIdx(tIdx):trialStopFr_tIdx(tIdx);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Prepare rotation matrix 
        
        if( subIsWalkingUpAxis )
            rotateRigidRads = 0;
        else
            rotateRigidRads  = 180 * (pi/180);
        end
        
        rigidRotMatrix = [ cos(rotateRigidRads) sin(rotateRigidRads) 0 0; ...
            -sin(rotateRigidRads) cos(rotateRigidRads) 0 0; 0 0 1 0 ; 0 0 0 1];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Right foot marker and rb data
        
        rFoot = struct;

        rFoot.pos_fr_xyz = rFoot_fr_XYZ;
        rFoot.quat_fr_wxyz = rFootQUAT_fr_WXYZ;
        rFoot.rot_fr_d1_d2 = quatVecToRotationMatVec(rFootQUAT_fr_WXYZ,subIsWalkingUpAxis);
        
        rFoot.rbPos_mFr_xyz = rFootRbPos_mFr_xyz;
        rFoot.rbPosSysTime_mFr_xyz = rFootRbSysTime_mFr;
        
        rFoot.rbQuat_mFr_xyz = rFootRbQuat_mFr_xyz;
        
        
        rFoot.rbQuatSysTime_mFr = rFootRbQuatSysTime_mFr;
        %%
        % Marker data
        for mIdx = 1:size(rFootMData_tr_mIdx_CmFr_xyz,2)
            
            rFoot.mkrPos_mIdx_Cfr_xyz(mIdx,:,:) = rFootMData_tr_mIdx_CmFr_xyz(tIdx,mIdx);
            rFoot.mkrSysTime_mIdx_Cfr(mIdx,:) = rFootSysTime_tr_mIdx_CmFr(tIdx,1);
            
        end
        
        % Collisions
        
        rFootCollisionFrames = intersect( ...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx > trialStartFr_tIdx(tIdx))),...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx  < trialStopFr_tIdx(tIdx))));
        
        rFoot.collisionFrames_idx = rFootCollisionFrames ;
        
        trialStructs_tr(tIdx).rFoot = rFoot;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Left foot marker and rb data
        
        lFoot = struct;

        lFoot.pos_fr_xyz = lFoot_fr_XYZ;
        lFoot.quat_fr_wxyz = lFootQUAT_fr_WXYZ;
        lFoot.rot_fr_d1_d2 = quatVecToRotationMatVec(lFootQUAT_fr_WXYZ,subIsWalkingUpAxis);
        
        lFoot.rbPos_mFr_xyz = lFootRbPos_mFr_xyz;
        lFoot.rbPosSysTime_mFr_xyz = lFootRbSysTime_mFr;
        
        lFoot.rbQuat_mFr_xyz = lFootRbQuat_mFr_xyz;
        lFoot.rbQuatSysTime_mFr = lFootRbQuatSysTime_mFr;
        
        % Marker data
        for mIdx = 1:size(lFootMData_tr_mIdx_CmFr_xyz,2)
            lFoot.mkrPos_mIdx_Cfr_xyz(mIdx,:,:) = lFootMData_tr_mIdx_CmFr_xyz(tIdx,mIdx);
            lFoot.mkrSysTime_mIdx_Cfr(mIdx,:) = lFootSysTime_tr_mIdx_CmFr(tIdx,mIdx);
        end
        
        lFootCollisionFrames = intersect( ...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx > trialStartFr_tIdx(tIdx))),...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx  < trialStopFr_tIdx(tIdx))));
        
        lFoot.collisionFrames_idx = lFootCollisionFrames ;
        
        trialStructs_tr(tIdx).lFoot = lFoot;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Glasses marker and rb data
        
        glasses = struct;

        % This is actually the position of the mainview, which is in a
        % fixed position relative to the glasses.  however, it may be
        % shifted slightly from the rbPos
        
        glasses.pos_fr_xyz = mainView_fr_XYZ;
        glasses.quat_fr_wxyz = mainViewQUAT_fr_WXYZ;
        glasses.rot_fr_d1_d2 = quatVecToRotationMatVec(mainViewQUAT_fr_WXYZ,subIsWalkingUpAxis);
        
        glasses.rbPos_mFr_xyz = glassRbPos_mFr_xyz;
        glasses.rbPosSysTime_mFr_xyz = glassRbSysTime_mFr;
        
        glasses.rbQuat_mFr_xyz = glassRbQuat_mFr_xyz;
        glasses.rbQuatSysTime_mFr = glassRbQuatSysTime_mFr;
        
        % Marker data
        for mIdx = 1:size(glassesMData_tr_mIdx_CmFr_xyz,2)
            glasses.mkrPos_mIdx_Cfr_xyz(mIdx,:) = glassesMData_tr_mIdx_CmFr_xyz(tIdx,mIdx);
            glasses.mkrSysTime_mIdx_Cfr(mIdx,:) = glassesSysTime_tr_mIdx_CmFr(tIdx,mIdx);
        end
        
        trialStructs_tr(tIdx).glasses = glasses;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Obstacle data
        
        obs = struct;
        
        obs.pos_xyz = prepareFOR(obstacle_tr_XYZ(tIdx,:),subIsWalkingUpAxis);
        obs.height = obstacleHeight_tr(tIdx);

        trialStructs_tr(tIdx).obs = obs;
        
        
    end
   
    sessionStruct.rawData_tr = trialStructs_tr;
    
    %% Set session struct and expStruct info
    
    expInfo = struct;

    
    % This will build an unordered vector of unique values that appear
    % in the list of trials
    %%
    %expInfo.obstacleHeights = sort(unique( obstacleHeight_tr ));
    %expInfo.trialTypes = sort(unique( [trialStructs_tr.trialType] ));
        
    expInfo.numTrials = numTrials;
    expInfo.numBlocks = numel(unique(blockIndex_tr));
    
    info_tr = [trialStructs_tr.info];
    expInfo.numTrialTypes = numel(unique([info_tr.type]));
    expInfo.trialTypes = unique([info_tr.type]);
    
    expInfo.changeLog_cChangeIdx = [];

    expInfo.obsHeightRatios = unique(obstacleHeight_tr ./ legLengthCM);
    
    sessionStruct.expInfo = expInfo;
    
end
