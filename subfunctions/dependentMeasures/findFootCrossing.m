function [sessionData, returnFlag] = findFootCrossing( sessionData, trIdx )
%% Summary: 
% This function finds the marker which furtherest along the plane and finds 
% the frame where it crosses the object plane. 

%% Kamran Binaee
% Find when each foot breaks the plane of the obstacle first
% Identify which one crosses first

%% 11/20/2015: Rakshit Kothari
% Added a summary and modified code to work with new format.

%% 
returnFlag = 0;
if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
    fprintf('Must run findSteps.m prior to findFootCrossing.m \n')
    return
end

loadParameters

procData = sessionData.processedData_tr(trIdx);
rawData = sessionData.rawData_tr(trIdx);

obstacleFront_Y = rawData.obs.pos_xyz(2) - obsLW(2)/2;

% Get marker data for all markers on the feet
rightFoot_fr_mkr_XYZ = procData.rFoot.mkrPos_mIdx_Cfr_xyz;
leftFoot_fr_mkr_XYZ = procData.lFoot.mkrPos_mIdx_Cfr_xyz;

rightFoot_fr_mkr_XYZ = cell2mat(permute(rightFoot_fr_mkr_XYZ, [3 2 1]));
leftFoot_fr_mkr_XYZ = cell2mat(permute(leftFoot_fr_mkr_XYZ, [3 2 1]));

% Grab the position on Y axis
rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,2,:));
leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,2,:));

% Find the Y data of the foot marker that is furthest up the Y axis
[ rightFootMaxY_frIdx, maxRightMkrIdx_fr] = max(rightFootY_frIdx_mIdx,[],2);
[ leftFootMaxY_frIdx, maxLeftMkrIdx_fr] = max(leftFootY_frIdx_mIdx,[],2);

%%  Find frames and markerIDX of first crossing

rightFootCrossingFr = find( rightFootMaxY_frIdx > obstacleFront_Y ,1,'first');
leftFootCrossingFr = find( leftFootMaxY_frIdx > obstacleFront_Y ,1,'first');

rightFootMkrIdx = maxRightMkrIdx_fr(rightFootCrossingFr);
leftFootMkrIdx = maxLeftMkrIdx_fr(leftFootCrossingFr);

%%  Record which foot crossed first
if( rightFootCrossingFr <= leftFootCrossingFr )
    firstCrossingFr = rightFootCrossingFr;
    firstCrossingFoot = 'Right';
    
elseif( leftFootCrossingFr < rightFootCrossingFr )
    firstCrossingFr = leftFootCrossingFr;
    firstCrossingFoot = 'Left';
else
    %FIXME: Will this crash if it can't find anyhing > obstacle_X??
    % e.g. if they did not cross obstacle in time
    display 'FindToeClearance: No crossing found'!;
    firstCrossingFr = NaN;
    firstCrossingFoot = 'None';
end

%%  Find step in which crossing ocurred

rTO_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx;
rHS_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.heelStrike_idx;

if( isempty(rightFootCrossingFr) )
    rightFootCrossingStepIdx  = NaN;
else
    rightFootCrossingStepIdx = intersect(find( rTO_sIdx < rightFootCrossingFr,1,'last'), find( rHS_sIdx > rightFootCrossingFr,1,'first'));
end

lTO_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;
lHS_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx;

if( isempty(leftFootCrossingFr) )
    leftFootCrossingStepIdx= NaN;
else
    leftFootCrossingStepIdx = intersect(find( lTO_sIdx < leftFootCrossingFr,1,'last'), find( lHS_sIdx > leftFootCrossingFr,1,'first'));
end

%% Find foot placement variability for the lead and trailing feet

% if isempty(leftFootCrossingStepIdx) || isempty(rightFootCrossingStepIdx)
%     sessionData.processedData_tr(trIdx).info.excludeTrial = 1;
%     sessionData.processedData_tr(trIdx).info.excludeTrialExplanation = [sessionData.processedData_tr(trIdx).info.excludeTrialExplanation 'Incomplete trial'];
% end

try
    lCrossingFr = [lTO_sIdx(leftFootCrossingStepIdx) lHS_sIdx(leftFootCrossingStepIdx)];
    rCrossingFr = [rTO_sIdx(rightFootCrossingStepIdx) rHS_sIdx(rightFootCrossingStepIdx)];

    lCrossingStepOn = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(lCrossingFr(1), 2);  
    lCrossingStepOff = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(lCrossingFr(2), 2);
    lCrossingTraj = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(lCrossingFr(1):lCrossingFr(2), :);
    lCrossingStepOn = lCrossingStepOn - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);
    lCrossingStepOff = lCrossingStepOff - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);

    rCrossingStepOn = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(rCrossingFr(1), 2);
    rCrossingStepOff = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(rCrossingFr(2), 2);
    rCrossingTraj = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(rCrossingFr(1):rCrossingFr(2), :);
    rCrossingStepOn = rCrossingStepOn - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);
    rCrossingStepOff = rCrossingStepOff - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);

    %% Commit data to the session structure
    % This should happen in one place, for simplicity.

    sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr = rightFootCrossingFr;
    sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr = leftFootCrossingFr;

    if strcmp(firstCrossingFoot,'Right')
        sessionData.dependentMeasures_tr(trIdx).leadFootPlacementVariability = [rCrossingStepOn rCrossingStepOff];
        sessionData.dependentMeasures_tr(trIdx).trailFootPlacementVariability = [lCrossingStepOn lCrossingStepOff];
        sessionData.dependentMeasures_tr(trIdx).leadFootCrossingTrajectory = rCrossingTraj;
        sessionData.dependentMeasures_tr(trIdx).trailFootCrossingTrajectory = lCrossingTraj;
    else

        sessionData.dependentMeasures_tr(trIdx).leadFootPlacementVariability = [lCrossingStepOn lCrossingStepOff];
        sessionData.dependentMeasures_tr(trIdx).trailFootPlacementVariability = [rCrossingStepOn rCrossingStepOff];
        sessionData.dependentMeasures_tr(trIdx).leadFootCrossingTrajectory = lCrossingTraj;
        sessionData.dependentMeasures_tr(trIdx).trailFootCrossingTrajectory = rCrossingTraj;
    end

    sessionData.dependentMeasures_tr(trIdx).rFoot.firstCrossingMkrIdx = rightFootMkrIdx;
    sessionData.dependentMeasures_tr(trIdx).lFoot.firstCrossingMkrIdx = leftFootMkrIdx;

    sessionData.dependentMeasures_tr(trIdx).rFoot.crossingStepIdx = rightFootCrossingStepIdx;
    sessionData.dependentMeasures_tr(trIdx).lFoot.crossingStepIdx  = leftFootCrossingStepIdx;

    sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot = firstCrossingFoot;
catch
    disp(['Incomplete trial. Trial no:' num2str(trIdx)])
    sessionData.processedData_tr(trIdx).info.excludeTrial = 1;
    returnFlag = 1;
end
end


