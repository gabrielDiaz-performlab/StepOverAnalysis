function trialStructs_tr =  generateRawData(MatFileName)
    
    %MatFileName = 'Exp_RawMat_exp_data-2014-11-26-16-38.mat';
    load(MatFileName)
    
    %% Trial Index is extracted here
    % The Format is like [TrialType TrialStartIndex TrialEndIndex]
    % For Example:
    %     TrialIndex = [
    %                1         370         587
    %                2           1         185
    %                3         186         369
    %                5         810        1013
    %                6         588         809
    %                6        1014        1207 ]

    
    %% FIXME This is a hack to produce a fake list of trial types in order
    % Similar to what one would get if using an event flag
    
    TrialIndex = extractTrialIndex(trialType);
    TrialIndex = sort(TrialIndex,1)
    TrialStartFr_tIdx = TrialIndex(:,2);
    TrialStopFr_tIdx = TrialIndex(:,3);
    TrialType_tIdx = TrialIndex(:,1);
    %[TrialStartFr_tIdx sortIdx]  = sort(TrialIndex(:,2))
    %sortIdx = sort(TrialIndex(:,2))
    
    
    
    % FIXME:  Hacked in block indices, which are missing from the data
    % record.
    BlockIndex_tr = [1 1 1 2 2 2];    
   
    %% FIXME: Data export hardcoded for expected number of markers
    
    [m, n, p] = size(shutterGlass_XYZ);
    TrialNumber = 1
    a = TrialIndex(TrialNumber,2);
    b = TrialIndex(TrialNumber,3);

    if (m<1 || n<1)
        fprintf('.mat file is empty !!\n')
        return
    end
    Head_fr_mkr_XYZ = zeros(m,4,3);
    for k = 0:4
        for j = 1:3
            Head_fr_mkr_XYZ (:, k+1, j) = double(shutterGlass_XYZ(:,3*k+j));
        end
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
        trialStructs_tr(tIdx).type = TrialType_tIdx(tIdx);
        % Fix ME:
        %trialStructs_tr(tIdx).block = BlockIndex_tr(tIdx);
        
        frIdx = TrialStartFr_tIdx(tIdx):TrialStopFr_tIdx(tIdx);
        % Data
        trialStructs_tr(tIdx).rightFoot_fr_mkr_XYZ = ...
            RightFoot_fr_mkr_XYZ(frIdx,:,:);
        
        trialStructs_tr(tIdx).leftFoot_fr_mkr_XYZ = ...
            LeftFoot_fr_mkr_XYZ(frIdx,:,:);
        
        trialStructs_tr(tIdx).head_fr_mkr_XYZ = ...
            Head_fr_mkr_XYZ(frIdx,:,:);
        
        trialStructs_tr(tIdx).spine_fr_mkr_XYZ = ...
            Spine_fr_mkr_XYZ(frIdx,:,:);
        
        % FIXME: Obstacle XYZ is time-series data.  I treat it here like
        % it's per-trial data.
        trialStructs_tr(tIdx).obstacle_XYZ = ...
            obstacle_XYZ(TrialStartFr_tIdx(tIdx),:);
        
        trialStructs_tr(tIdx).frameTime_fr = ...
            frameTime(frIdx);
    end
    
end
