%Andrew Smith
%Last modified: 2/16/15

function [ sessionData ] = toeClearanceASO(sessionData, trIdx)
%toeClearanceASO finds the distance between each toe and the obstacle at
%their respective crossing frames.
%SessionData is a struct containing raw and processed data from Main.m
%trialNumber is the current trial number.

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);

%Determine if step is with right or left foot, then X location of other foot
stepFoot = proTrialStruct.firstCrossingFoot;
obsLoc = rawTrialStruct.obstacle_XYZ(1,1);
rightCrossFrame = proTrialStruct.rightFootCrossingFr;
leftCrossFrame = proTrialStruct.leftFootCrossingFr;

if strcmp(stepFoot, 'Right')
    leadToeDist = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,1) - obsLoc; %FIXME: Which marker is toe?
    trailToeDist = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,1) - obsLoc; %FIXME: Which marker is toe?

elseif strcmp(stepFoot, 'Left')
    leadToeDist = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,1) - obsLoc; %FIXME: Which marker is toe?
    trailToeDist = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,1) - obsLoc; %FIXME: Which marker is toe?
    
else
    print('toeClearanceASO: Unknown initial step foot');
end

sessionData.processedData_tr(trIdx).leadToeDist = leadToeDist;
sessionData.processedData_tr(trIdx).trailToeDist = trailToeDist;

end