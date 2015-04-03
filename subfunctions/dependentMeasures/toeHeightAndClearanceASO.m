%Andrew Smith
%Last modified: 2/16/15

function [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx)

%toeClearanceASO finds the distance between each toe and the obstacle at
%their respective crossing frames.
%SessionData is a struct containing raw and processed data from Main.m
%trialNumber is the current trial number.

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%% Determine if step is with right or left foot, then X location of other foot


stepFoot = dmTrialStruct.firstCrossingFoot;
obsYLoc = rawTrialStruct.obstacle_XposYposHeight(2);
obsHeight = rawTrialStruct.obstacle_XposYposHeight(3);
rightCrossFrame = dmTrialStruct.rFoot.crossingFr;
leftCrossFrame = dmTrialStruct.lFoot.crossingFr;

%% 

if strcmp(stepFoot, 'Right')
    
    leadToeZClearanceASO = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3) - obsHeight; %FIXME: Which marker is toe?
    trailToeZClearanceASO = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3) - obsHeight; %FIXME: Which marker is toe?
    
    leadToeZASO = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3); %FIXME: Which marker is toe?
    trailToeZASO= rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3); %FIXME: Which marker is toe?
    
elseif strcmp(stepFoot, 'Left')
    
    leadToeZClearanceASO = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3) - obsHeight; %FIXME: Which marker is toe?
    trailToeZClearanceASO = rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3) - obsHeight; %FIXME: Which marker is toe?
    
    leadToeZASO = rawTrialStruct.leftFoot_fr_mkr_XYZ(leftCrossFrame,1,3); %FIXME: Which marker is toe?
    trailToeZASO= rawTrialStruct.rightFoot_fr_mkr_XYZ(rightCrossFrame,1,3); %FIXME: Which marker is toe?
    
else
    fprintf('toeClearanceASO: Subject did not pass the obstacle. \n');
    
    leadToeZClearanceASO  = NaN;
    trailToeZClearanceASO  = NaN;
    leadToeZASO  = NaN;
    trailToeZASO  = NaN;
end

sessionData.dependentMeasures_tr(trIdx).leadToeZClearanceASO = leadToeZClearanceASO;
sessionData.dependentMeasures_tr(trIdx).trailToeZClearanceASO = trailToeZClearanceASO;

sessionData.dependentMeasures_tr(trIdx).leadToeZASO = leadToeZASO;
sessionData.dependentMeasures_tr(trIdx).trailToeZASO = trailToeZASO;

% display 'In toeClearanceASO: leadToeZDist, trailToeZDist'

end