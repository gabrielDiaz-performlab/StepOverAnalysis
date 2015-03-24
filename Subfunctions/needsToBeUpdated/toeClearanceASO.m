%Andrew Smith
%Last modified: 2/16/15

function [ sessionData ] = toeClearanceASO(sessionData, trIdx)

%toeClearanceASO finds the distance between each toe and the obstacle at
%their respective crossing frames.
%SessionData is a struct containing raw and processed data from Main.m
%trialNumber is the current trial number.

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%% Determine if step is with right or left foot, then X location of other foot

stepFoot = dmTrialStruct .firstCrossingFoot;
obsLoc = rawTrialStruct.obstacle_XposYposHeight(1,1);
rightCrossFrame = dmTrialStruct .rightFootCrossingFr;
leftCrossFrame = dmTrialStruct .leftFootCrossingFr;

%% 

if strcmp(stepFoot, 'Right')
    
    leadToeZDist = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3) - obsLoc; %FIXME: Which marker is toe?
    trailToeZDist = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3) - obsLoc; %FIXME: Which marker is toe?

elseif strcmp(stepFoot, 'Left')
    
    leadToeZDist = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3) - obsLoc; %FIXME: Which marker is toe?
    trailToeZDist = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3) - obsLoc; %FIXME: Which marker is toe?
    
else
    print('toeClearanceASO: Unknown initial step foot');
end

sessionData.dependentMeasures_tr(trIdx).leadToeZDist = leadToeZDist;
sessionData.dependentMeasures_tr(trIdx).trailToeZDist = trailToeZDist;

% display 'In toeClearanceASO: leadToeZDist, trailToeZDist'

end