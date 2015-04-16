function sessionData = findFootCrossing( sessionData, trIdx , plotData )

% Kamran Binaee
% Find when each foot breaks the plane of the obstacle first
% Identify which one crosses first
%FIXME:  Add plotting functionality to validate process

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
    fprintf('Must run findSteps.m prior to findFootCrossing.m \n')
    return
end

%FINDTOECLEARANCE Summary of this function goes here
%   Detailed explanation goes here

loadParameters

%trialStruct = sessionData.rawData_tr(trIdx);
procData = sessionData.processedData_tr(trIdx);
rawData = sessionData.rawData_tr(trIdx);

%FIXME: Obstacle has no width

obstacleFront_Y = rawData.obstacle_XposYposHeight(2) - obsLW(2)/2;

% Get marker data for all markers on the feet
rightFoot_fr_mkr_XYZ = procData.rightFoot_fr_mkr_XYZ;
leftFoot_fr_mkr_XYZ = procData.leftFoot_fr_mkr_XYZ;

% Grab the position on Y axis
rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,:,2));
leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,:,2));

% Find the Y data of the foot marker that is furthest up the Y axis
[ rightFootMaxY_frIdx,maxRightMkrIdx_fr] = max(rightFootY_frIdx_mIdx,[],2);
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

%% Here is where variables are saved out to sessionData.
% This should happen in one place, for simplicity.

sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr = rightFootCrossingFr;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr = leftFootCrossingFr;

sessionData.dependentMeasures_tr(trIdx).rFoot.firstCrossingMkrIdx = rightFootMkrIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.firstCrossingMkrIdx = leftFootMkrIdx;

sessionData.dependentMeasures_tr(trIdx).rFoot.crossingStepIdx = rightFootCrossingStepIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingStepIdx  = leftFootCrossingStepIdx;

sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot = firstCrossingFoot;



