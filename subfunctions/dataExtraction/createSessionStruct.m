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
		
    trialStartFr_trIdx = find(eventFlag == 1 );
    trialStopFr_trIdx = union(find(eventFlag == 6),find(eventFlag == 7));
    blockEndFr_blIdx = find(eventFlag == 7);
    
    %%
    
    clear blockIndex_tr
    
    % The 0 makes it easier to find trials between bIdx-1 and
    % bIdx
    bList = [0 blockEndFr_blIdx];
        
    for bIdx = 1:numel(bList)-1

        trialsInBIdx = intersect( find(trialStartFr_trIdx > bList(bIdx)), find(trialStartFr_trIdx < bList(bIdx+1)));
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
    numTrials = length(trialStartFr_trIdx);
    trialStructs_tr = repmat(trialStruct, numTrials, 1 );
    
    %% Per trial loop
    for trIdx = 1:numTrials
        
        info = struct;
        
        info.excludeTrial = 0;
        info.excludeTrialExplanation = [];
        info.trialModifications_cModIdx = [];
        
        % Add basic trial start/stop info
        info.startFr = trialStartFr_trIdx(trIdx);
        info.stopFr = trialStopFr_trIdx(trIdx);

        trialFrames = trialStartFr_trIdx(trIdx):trialStopFr_trIdx(trIdx);
        info.sysTime_fr = sysTime_fr(trialFrames); 
        info.eventFlag_fr = eventFlag(trialFrames );
        
        %RK: This inversion sign is necessary. subIsWalkingUpAxis = 1 means
        %walking towards the front wall from the main lab entrance.
        
        subIsWalkingUpAxis = ~isWalkingDownAxis_tr(trIdx); 
        info.subIsWalkingUpAxis = subIsWalkingUpAxis;
        
        
        info.type = trialType_tr(trIdx); 
        info.block = blockIndex_tr(trIdx);

        trialStructs_tr(trIdx).info  = info ;

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

        rFoot.pos_fr_xyz = prepareFOR(rFoot_fr_XYZ(trialFrames ,:),subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        rFoot.quat_fr_wxyz = rFootQUAT_fr_WXYZ(trialFrames ,:);
        rFoot.rot_fr_d1_d2 = quatVecToRotationMatVec(rFootQUAT_fr_WXYZ(trialFrames ,:),subIsWalkingUpAxis);
        
        
        try
            rFoot.rbPos_mFr_xyz = cell2mat(rFootRbPos_tr_CmFr(trIdx));
            rFoot.rbPos_mFr_xyz = prepareFOR(rFoot.rbPos_mFr_xyz,subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
            rFoot.rbPosSysTime_mFr_xyz = cell2mat(rFootRbSysTime_tr_CmFr(trIdx));
        catch
           keyboard 
        end
        
        rFoot.rbQuat_mFr_xyz = cell2mat(rFootRbQuat_tr_CmFr_xyz(trIdx));
        rFoot.rbQuatSysTime_mFr = cell2mat(rFootRbQuatSysTime_tr_CmFr(trIdx));
        
        %%
        % Marker data
        for mIdx = 1:size(rFootMData_tr_mIdx_CmFr_xyz,2)
            
            rFoot.mkrPos_mIdx_Cfr_xyz(mIdx,:,:) = {prepareFOR(cell2mat(rFootMData_tr_mIdx_CmFr_xyz(trIdx,mIdx)), subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx))};
            rFoot.mkrSysTime_mIdx_Cfr(mIdx,:) = rFootSysTime_tr_mIdx_CmFr(trIdx,mIdx);
            
        end
        
        % Collisions
        
        rFootCollisionFrames = intersect( ...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx > trialStartFr_trIdx(trIdx))),...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx  < trialStopFr_trIdx(trIdx))));
        
        rFoot.collisionFrames_idx = rFootCollisionFrames ;
        
        trialStructs_tr(trIdx).rFoot = rFoot;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Left foot marker and rb data
        
        lFoot = struct;

        lFoot.pos_fr_xyz = prepareFOR(lFoot_fr_XYZ(trialFrames ,:),subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        lFoot.quat_fr_wxyz = lFootQUAT_fr_WXYZ(trialFrames ,:);
        lFoot.rot_fr_d1_d2 = quatVecToRotationMatVec(lFootQUAT_fr_WXYZ(trialFrames ,:), subIsWalkingUpAxis);
        
        lFoot.rbPos_mFr_xyz = cell2mat(lFootRbPos_tr_CmFr(trIdx));
        lFoot.rbPos_mFr_xyz = prepareFOR(lFoot.rbPos_mFr_xyz,subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        lFoot.rbPosSysTime_mFr_xyz = cell2mat(lFootRbSysTime_tr_CmFr(trIdx));
        
        lFoot.rbQuat_mFr_xyz = cell2mat(lFootRbQuat_tr_CmFr_xyz(trIdx));
        lFoot.rbQuatSysTime_mFr = cell2mat(lFootRbQuatSysTime_tr_CmFr(trIdx));
                       
        % Marker data
        for mIdx = 1:size(lFootMData_tr_mIdx_CmFr_xyz,2)
            lFoot.mkrPos_mIdx_Cfr_xyz(mIdx,:,:) = {prepareFOR(cell2mat(lFootMData_tr_mIdx_CmFr_xyz(trIdx,mIdx)), subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx))};
            lFoot.mkrSysTime_mIdx_Cfr(mIdx,:) = lFootSysTime_tr_mIdx_CmFr(trIdx,mIdx);
        end
        
        lFootCollisionFrames = intersect( ...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx > trialStartFr_trIdx(trIdx))),...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx  < trialStopFr_trIdx(trIdx))));
        
        lFoot.collisionFrames_idx = lFootCollisionFrames ;
        
        trialStructs_tr(trIdx).lFoot = lFoot;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Glasses marker and rb data
        
        glasses = struct;

        % This is actually the position of the mainview, which is in a
        % fixed position relative to the glasses.  however, it may be
        % shifted slightly from the rbPos
        
        glasses.pos_fr_xyz = prepareFOR(glasses_fr_XYZ(trialFrames ,:),subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        glasses.quat_fr_wxyz = glassesQUAT_fr_WXYZ(trialFrames ,:);
        glasses.rot_fr_d1_d2 = quatVecToRotationMatVec(glassesQUAT_fr_WXYZ(trialFrames ,:),subIsWalkingUpAxis);
        
        glasses.rbPos_mFr_xyz = cell2mat(glassRbPos_tr_CmFr(trIdx));
        glasses.rbPos_mFr_xyz = prepareFOR(glasses.rbPos_mFr_xyz,subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        glasses.rbPosSysTime_mFr_xyz = cell2mat(glassRbSysTime_tr_CmFr(trIdx));
        
        glasses.rbQuat_mFr_xyz = cell2mat(glassRbQuat_tr_CmFr_xyz(trIdx));
        glasses.rbQuatSysTime_mFr = cell2mat(glassRbQuatSysTime_tr_CmFr(trIdx));
        
        % Marker data
        for mIdx = 1:size(glassesMData_tr_mIdx_CmFr_xyz,2)
            glasses.mkrPos_mIdx_Cfr_xyz(mIdx,:) = {prepareFOR(cell2mat(glassesMData_tr_mIdx_CmFr_xyz(trIdx,mIdx)), subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx))};
            glasses.mkrSysTime_mIdx_Cfr(mIdx,:) = glassesSysTime_tr_mIdx_CmFr(trIdx,mIdx);
        end
        
        trialStructs_tr(trIdx).glasses = glasses;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Spine marker and rb data
        
        spine = struct;
        
        spine.rbPos_mFr_xyz = cell2mat(spineRbPos_tr_CmFr(trIdx));
        spine.rbPos_mFr_xyz = prepareFOR(spine.rbPos_mFr_xyz,subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        spine.rbPosSysTime_mFr_xyz = cell2mat(spineRbSysTime_tr_CmFr(trIdx));
        
        spine.rbQuat_mFr_xyz = cell2mat(spineRbQuat_tr_CmFr_xyz(trIdx));
        spine.rbQuatSysTime_mFr = cell2mat(spineRbQuatSysTime_tr_CmFr(trIdx));
        
        % Marker data 
        for mIdx = 1:size(spineMData_tr_mIdx_CmFr_xyz,2)
            spine.mkrPos_mIdx_Cfr_xyz(mIdx,:) = {prepareFOR(cell2mat(spineMData_tr_mIdx_CmFr_xyz(trIdx,mIdx)), subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx))};
            spine.mkrSysTime_mIdx_Cfr(mIdx,:) = spineSysTime_tr_mIdx_CmFr(trIdx,mIdx);
        end
        
        trialStructs_tr(trIdx).spine = spine;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Obstacle data
        
        obs = struct;
        
        obs.pos_xyz = prepareFOR(obstacle_tr_XYZ(trIdx,:),subIsWalkingUpAxis,standingBoxOffset_posZ(trIdx),standingBoxOffset_negZ(trIdx));
        obs.height = obstacleHeight_tr(trIdx);

        trialStructs_tr(trIdx).obs = obs;
        
        
    end
   
    sessionStruct.rawData_tr = trialStructs_tr;
    
    %% Set session struct and expStruct info
    
    expInfo = struct;
    
    % This will build an unordered vector of unique values that appear
    % in the list of trials
    %%
        
    expInfo.numTrials = numTrials;
    expInfo.numBlocks = numel(unique(blockIndex_tr));
    
    info_tr = [trialStructs_tr.info];
    expInfo.numTrialTypes = numel(unique([info_tr.type]));
    expInfo.trialTypes = unique([info_tr.type]);
    
    expInfo.changeLog_cChangeIdx = [];

    expInfo.obsHeightRatios = unique(obstacleHeight_tr ./ legLengthCM);
    
    sessionStruct.expInfo = expInfo;
    
end
