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
		
    TrialStartFr_tIdx = find(eventFlag == 1 );
    TrialStopFr_tIdx = [TrialStartFr_tIdx(2:end)-1 length(shutterGlass_XYZ)];
    
    %%
    blockIndex_tr = blockNum(TrialStartFr_tIdx);
    sessionStruct.expInfo.legLengthCM  = legLengthCM(1);

    
    rightFootCollisionFr_cIdx = find(eventFlag == 4 );
    leftFootCollisionFr_idx = find(eventFlag == 5 );
    
    BlockEndFr_tIdx = find(eventFlag == 7 );

    %% FIXME: Data export hardcoded for expected number of markers
    
    [m, n, p] = size(shutterGlass_XYZ);
    
    TrialNumber = 1;

    if (m<1 || n<1)
        fprintf('.mat file is empty !!\n')
        return
    end
    
    % FIXME:  subIsWalkingUpAxis should be drawn from data file.
    
    Head_fr_mkr_XYZ = zeros(m,4,3);
    for k = 0:4
        
        for j = 1:3
            Head_fr_mkr_XYZ (:, k+1, j) = double(shutterGlass_XYZ(:,3*k+j));
        end
        
        %Head_fr_mkr_XYZ(:,k,:) = prepareFOR( squeeze(Head_fr_mkr_XYZ(:,k,:)) , subIsWalkingUpAxis );
        
    end
    
    %% FIXME: Data export hardcoded for expected number of markers
    RightFoot_fr_mkr_XYZ = zeros(m,4,3);
    for k = 0:3
        for j = 1:3
            RightFoot_fr_mkr_XYZ (:, k+1, j) = double(rightFoot_XYZ(:,3*k+j));
        end
    end
    size(RightFoot_fr_mkr_XYZ);
    
    %% FIXME: Data export hardcoded for expected number of markers
    LeftFoot_fr_mkr_XYZ = zeros(m,4,3);
    for k = 0:3
        for j = 1:3
            LeftFoot_fr_mkr_XYZ(:, k+1, j) = double(leftFoot_XYZ(:,3*k+j));
        end
    end
    size(LeftFoot_fr_mkr_XYZ);

    %% FIXME: Data export hardcoded for expected number of markers
    Spine_fr_mkr_XYZ = zeros(m,4,3);
    for k = 0:3
        for j = 1:3
            Spine_fr_mkr_XYZ(:, k+1, j) = double(spinal_XYZ(:,3*k+j));
        end
    end
    size(Spine_fr_mkr_XYZ);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Assemble data into vector of trial structs
    
    % First, create an array of empty structs.
    
    trialStruct = struct;
    numTrials = length(TrialStartFr_tIdx);
    trialStructs_tr = repmat(trialStruct, numTrials, 1 );
   
    %%  Now, fill each struct with data!
    
    %% 
    for tIdx = 1:numTrials
    
        % Add basic trial start/stop info
        trialStructs_tr(tIdx).startFr = TrialStartFr_tIdx(tIdx);
        trialStructs_tr(tIdx).stopFr = TrialStopFr_tIdx(tIdx);

        
        %%
        rFootCollisionFrames = intersect( ...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx > TrialStartFr_tIdx(tIdx))),...
            rightFootCollisionFr_cIdx(find(rightFootCollisionFr_cIdx  < TrialStopFr_tIdx(tIdx))));
        % Collisions
        
        
        trialStructs_tr(tIdx).rightFootCollisions_idx = rFootCollisionFrames ;
        
        lFootCollisionFrames = intersect( ...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx > TrialStartFr_tIdx(tIdx))),...
            leftFootCollisionFr_idx(find(leftFootCollisionFr_idx  < TrialStopFr_tIdx(tIdx))));
        
        trialStructs_tr(tIdx).leftFootCollisions_idx = lFootCollisionFrames;
       
        
        if( numel(rFootCollisionFrames) > 0 || numel(lFootCollisionFrames) > 0 )
           fprintf('Collision on trial %u\n', tIdx) 
        end
        
        trialStructs_tr(tIdx).trialType = trialType(TrialStartFr_tIdx(tIdx)); 
        trialStructs_tr(tIdx).blockIdx = blockIndex_tr(tIdx);
        
        %%
        % Fix ME:
        %trialStructs_tr(tIdx).block = BlockIndex_tr(tIdx);
        frIdxList = TrialStartFr_tIdx(tIdx):TrialStopFr_tIdx(tIdx);
        
        % FIXME: I'm am calculating, "subIsWalkingUpAxis." It should be in
        % .txt
        % Remember, data is still in VIZARD coordinates.
        % Z is depth, not Y!
        if( Head_fr_mkr_XYZ(TrialStartFr_tIdx(tIdx),1,3) < 0 )
            subIsWalkingUpAxis = 1;
            rotateRigidRads = 0;
        else
            subIsWalkingUpAxis = 0;
            rotateRigidRads  = 180 * (pi/180);
        end
        
        trialStructs_tr(tIdx).subIsWalkingUpAxis = subIsWalkingUpAxis;
        
        trialStructs_tr(tIdx).rightFoot_fr_mkr_XYZ = ...
            prepareFOR( RightFoot_fr_mkr_XYZ(frIdxList,:,:), subIsWalkingUpAxis);
        
        trialStructs_tr(tIdx).leftFoot_fr_mkr_XYZ = ...
            prepareFOR( LeftFoot_fr_mkr_XYZ(frIdxList,:,:), subIsWalkingUpAxis);
        
        trialStructs_tr(tIdx).head_fr_mkr_XYZ = ...
            prepareFOR( Head_fr_mkr_XYZ(frIdxList,:,:), subIsWalkingUpAxis);
        
        trialStructs_tr(tIdx).spine_fr_mkr_XYZ = ...
            prepareFOR( Spine_fr_mkr_XYZ(frIdxList,:,:), subIsWalkingUpAxis);
        
        % FIXME: Obstacle XYZ is time-series data.  I treat it here like
        % it's per-trial data.
        
        trialStructs_tr(tIdx).obstacle_XposYposHeight = ...
            prepareFOR( obstacle_XYZ(TrialStartFr_tIdx(tIdx),:), subIsWalkingUpAxis);
        
        trialStructs_tr(tIdx).frameTime_fr = ...
            frameTime(frIdxList);
        
        
        %%% Quaternions
        
        trialStructs_tr(tIdx).leftFootQUAT_fr_WXYZ = ...
            leftFootQUAT_fr_WXYZ(frIdxList,:,:,:);
        
        trialStructs_tr(tIdx).rightFootQUAT_fr_WXYZ = ...
            rightFootQUAT_fr_WXYZ(frIdxList,:,:,:);
        
        %%% Rotation matrices
        
        rigidRotMatrix = [ cos(rotateRigidRads) sin(rotateRigidRads) 0 0; ...
            -sin(rotateRigidRads) cos(rotateRigidRads) 0 0; 0 0 1 0 ; 0 0 0 1];
        
        rightFootRotTemp_fr_d1_d2 = zeros(length(frIdxList),4,4);
        leftFootRotTemp_fr_d1_d2 = zeros(length(frIdxList),4,4);
        
        for frIdx = 1:length(frIdxList)
            
            frInExpVec = frIdxList(frIdx);
            
            rQuat_WXYZ = squeeze(rightFootQUAT_fr_WXYZ(frInExpVec ,:,:,:,:));
            lQuat_WXYZ = squeeze(leftFootQUAT_fr_WXYZ(frInExpVec ,:,:,:,:));
            
            if( subIsWalkingUpAxis == 0 )
                rQuat_WXYZ([2 3]) = -rQuat_WXYZ([2 3]);
                lQuat_WXYZ([2 3]) = -lQuat_WXYZ([2 3]);
            end
            
            leftFootRotTemp_fr_d1_d2(frIdx,:,:) = quaternion2matrix(lQuat_WXYZ);
            rightFootRotTemp_fr_d1_d2(frIdx,:,:) = quaternion2matrix(rQuat_WXYZ);
        end
        
        trialStructs_tr(tIdx).rightFootRot_fr_d1_d2 = rightFootRotTemp_fr_d1_d2;
        trialStructs_tr(tIdx).leftFootRot_fr_d1_d2 = leftFootRotTemp_fr_d1_d2;
    
        trialStructs_tr(tIdx).excludeTrial = 0;
        trialStructs_tr(tIdx).excludeTrialExplanation = [];
        trialStructs_tr(tIdx).trialModifications_cModIdx = [];
        
        % This will build an unordered vector of unique values that appear
        % in the list of trials
       
        expInfo.obstacleHeights = sort(unique( [[expInfo.obstacleHeights] [trialStructs_tr(tIdx).obstacle_XposYposHeight(3)]] )); 
        expInfo.trialTypes = sort(unique( [[expInfo.trialTypes] [trialStructs_tr(tIdx).trialType]] ));
        
        
    end
   
    %% Set session struct and expStruct info
    
    sessionStruct.rawData_tr = trialStructs_tr;
    
    expInfo.numTrials = numTrials;
    expInfo.numBlockTypes = numel(unique(blockIndex_tr));
    expInfo.numTrialTypes = numel(unique([trialStructs_tr(tIdx).trialType]));
    
    expInfo.eventFlag_fr = eventFlag;
    
    expInfo.changeLog_cChangeIdx = [];
    
    %rightFootCollision_cIdx = find(eventFlag == 4 );
    %leftFootCollision_cIdx = find(eventFlag == 5 );
    
    expInfo.obsHeightRatios = obsHeightRatios ;%[.15 .25 .35];
    %display(fprintf('FIXME: generateRawData - IMPORT LEG LENGTH RATIO ***CURRENTLY HARDCODED at %f %f %f **\n',expInfo.obsHeightRatios))
    
    
    sessionStruct.expInfo = expInfo;
    
end
