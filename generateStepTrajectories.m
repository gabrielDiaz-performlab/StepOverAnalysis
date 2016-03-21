function sessionData = generateStepTrajectories(sessionData, trIdx)

%% Template generator
% This function is used to generate templates for each step. This will be
% used to compute a comparison between blank trials and obstacle biased trials.

FR = sessionData.expInfo.meanFrameRate;
obs_loc = sessionData.processedData_tr(trIdx).obs.pos_xyz(2);

foots = {'lFoot','rFoot'};

%% Find toe offs and heel strikes 
for footIdx = 1:2
    
    heelStrike_idx = sessionData.dependentMeasures_tr(trIdx).(foots{footIdx}).heelStrike_idx;
    toeOff_idx = sessionData.dependentMeasures_tr(trIdx).(foots{footIdx}).toeOff_idx;
    rbPos_footIdx = sessionData.processedData_tr(trIdx).(foots{footIdx}).rbPos_mFr_xyz; 
    TS = sessionData.processedData_tr(trIdx).(foots{footIdx}).rbPosSysTime_mFr_xyz;
   
    if length(heelStrike_idx) ~= length(toeOff_idx)
        error('The number of Heel Strikes and Toe Offs should be the same')
    end
    
    cond = (heelStrike_idx - toeOff_idx) > 0 & abs(heelStrike_idx - toeOff_idx)/FR > 0.3;
    
    heelStrike_idx(~cond) = [];
    toeOff_idx(~cond) = [];
    
    foot_trajectory = cell(length(heelStrike_idx),2);
          
    for i = 1:length(foot_trajectory)
        ZData = rbPos_footIdx(toeOff_idx(i):heelStrike_idx(i),3);
        YData = rbPos_footIdx(toeOff_idx(i):heelStrike_idx(i),2);
        XData = rbPos_footIdx(toeOff_idx(i):heelStrike_idx(i),1);
        TData = TS(toeOff_idx(i):heelStrike_idx(i));
        
        cond = strcmp(sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot, 'Right') && strcmp(foots{footIdx}, 'rFoot') ||...
            strcmp(sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot, 'Left') && strcmp(foots{footIdx}, 'lFoot'); 
        
        if rbPos_footIdx(toeOff_idx(i),2) < obs_loc && rbPos_footIdx(heelStrike_idx(i),2) > obs_loc && cond
           sessionData.dependentMeasures_tr(trIdx).StepToCross = i; 
        end
        
        YData = YData - YData(1);
        TData = TData - TData(1);
        
        [pkvals, loc] = findpeaks(max(ZData) - ZData);

        if isempty(loc)
            [~, loc] = min(ZData);
        end

        if length(loc) >= 2
           loc = loc(pkvals == max(pkvals));
        end
        
        foot_trajectory(i,1) = {[XData YData ZData]}; 
        foot_trajectory(i,2) = {TData};
        foot_trajectory(i,3) = {[TData(loc) YData(loc) ZData(loc)]};
    end
    
    if ~sessionData.processedData_tr(trIdx).info.isBlankTrial
        sessionData.dependentMeasures_tr(trIdx).(foots{footIdx}).footTrajectory = foot_trajectory;  
    else
        sessionData.dependentMeasures_tr(trIdx).(foots{footIdx}).unbiasedModel = foot_trajectory;
    end
end
end