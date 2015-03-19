function trialStructs_tr =  generateRawData(MatFileName)
    
    %MatFileName = 'Exp_RawMat_exp_data-2014-11-26-16-38.mat';
    load(MatFileName)
    
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
    
    BlockIndex_tr = [1 1 1 1 1 1 2 2 2 2 2 2];
    %FIXME:  Hacked in block numbers
    
    
    rightFootCollision_cIdx = find(eventFlag == 4 );
    leftFootCollision_cIdx = find(eventFlag == 5 );
    BlockEndFr_tIdx = find(eventFlag == 7 );
    
    %TrialIndex = extractTrialIndex(trialType);
    %TrialIndex = sort(TrialIndex,1)
    %TrialStartFr_tIdx = TrialIndex(:,2);
    %TrialStopFr_tIdx = TrialIndex(:,3);
    %TrialType_tIdx = TrialIndex(:,1);
    
    %[TrialStartFr_tIdx sortIdx]  = sort(TrialIndex(:,2))
    %sortIdx = sort(TrialIndex(:,2))
    
    % FIXME:  Hacked in block indices, which are missing from the data
    % record.
    %BlockIndex_tr = [1 1 1 2 2 2];    
   
    %% FIXME: Data export hardcoded for expected number of markers
    
    [m, n, p] = size(shutterGlass_XYZ);
    
    TrialNumber = 1

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
    N = length(TrialStartFr_tIdx);
    trialStructs_tr = repmat(trialStruct, N, 1 );
   
    %%  Now, fill each struct with data!
    
    
    for tIdx = 1:N
    
        % Add basic trial start/stop info
        trialStructs_tr(tIdx).startFr = TrialStartFr_tIdx(tIdx);
        trialStructs_tr(tIdx).stopFr = TrialStopFr_tIdx(tIdx);
        
        
        trialStructs_tr(tIdx).trialType = trialType(TrialStartFr_tIdx(tIdx)); 
        
        %trialStructs_tr.blockIdx = 
        
        
        % Fix ME:
        %trialStructs_tr(tIdx).block = BlockIndex_tr(tIdx);
        frIdxList = TrialStartFr_tIdx(tIdx):TrialStopFr_tIdx(tIdx);
        
        % FIXME: I'm am calculating, "subIsWalkingUpAxis." It should be in
        % .txt
        if( Head_fr_mkr_XYZ(TrialStartFr_tIdx(tIdx),1,2) < 0 )
            subIsWalkingUpAxis = 1;
            rotateRigids = 180 * (pi/180);
        else
            subIsWalkingUpAxis = 0;
            rotateRigids = 180 * (pi/180);
        end
        
        trialStructs_tr(tIdx).subIsWalkingUpAxis_tr(tIdx) = subIsWalkingUpAxis;
        
        % Data
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
        
        trialStructs_tr(tIdx).leftFootQUAT_fr_WXYZ = ...
            leftFootQUAT_fr_WXYZ(frIdxList,:,:,:);
        
        eyeRotation = -90 * (pi/180);
        %rotateLeftEyeMat = [ cos(eyeRotation) 0 -sin(eyeRotation) 0; 0 1 0 0 ; sin(eyeRotation) 0 cos(eyeRotation) 0; 0 0 0 1];
        rotateLeftEyeMat = [ cos(eyeRotation) sin(eyeRotation) 0 0; -sin(eyeRotation) cos(eyeRotation) 0 0; 0 0 1 0 ; 0 0 0 1];

        trialStructs_tr(tIdx).rightFootQUAT_fr_WXYZ = ...
            rightFootQUAT_fr_WXYZ(frIdxList,:,:,:);
        
    end
    
end
