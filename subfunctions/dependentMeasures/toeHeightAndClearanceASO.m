%% Andrew Smith
% Last modified: 2/16/15

function [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx)

%toeClearanceASO finds the distance between each toe and the obstacle at
%their respective crossing frames.
%SessionData is a struct containing raw and processed data from Main.m
%trialNumber is the current trial number.

% rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

% Determine if step is with right or left foot, then X location of other foot

stepFoot = dmTrialStruct.firstCrossingFoot;
obsYLoc = proTrialStruct.obs.pos_xyz(2);
obsHeight = proTrialStruct.obs.height;

rightCrossFrame = dmTrialStruct.rFoot.crossingFr;
leftCrossFrame = dmTrialStruct.lFoot.crossingFr;

rightCrossMkrIdx = dmTrialStruct.rFoot.firstCrossingMkrIdx;
leftCrossMkrIdx = dmTrialStruct.lFoot.firstCrossingMkrIdx;

%% 
if strcmp(stepFoot, 'Right')
    
    leadToeZClearanceASO = proTrialStruct.rFoot.mkrPos_mIdx_Cfr_xyz{rightCrossMkrIdx}(rightCrossFrame,3) - obsHeight; 
    trailToeZClearanceASO = proTrialStruct.lFoot.mkrPos_mIdx_Cfr_xyz{leftCrossMkrIdx}(leftCrossFrame,3) - obsHeight; 
    
    leadToeZASO = proTrialStruct.rFoot.mkrPos_mIdx_Cfr_xyz{rightCrossMkrIdx}(rightCrossFrame,3); 
    trailToeZASO= proTrialStruct.lFoot.mkrPos_mIdx_Cfr_xyz{leftCrossMkrIdx}(leftCrossFrame,3); 
    
elseif strcmp(stepFoot, 'Left')
    
    leadToeZClearanceASO = proTrialStruct.lFoot.mkrPos_mIdx_Cfr_xyz{leftCrossMkrIdx}(leftCrossFrame,3) - obsHeight;  
    trailToeZClearanceASO = proTrialStruct.rFoot.mkrPos_mIdx_Cfr_xyz{rightCrossMkrIdx}(rightCrossFrame,3) - obsHeight;  
    
    leadToeZASO = proTrialStruct.lFoot.mkrPos_mIdx_Cfr_xyz{leftCrossMkrIdx}(leftCrossFrame,3);
    trailToeZASO= proTrialStruct.rFoot.mkrPos_mIdx_Cfr_xyz{rightCrossMkrIdx}(rightCrossFrame,3); 
    
else
    fprintf('toeClearanceASO: Subject did not pass the obstacle. \n');
    
    leadToeZClearanceASO  = NaN;
    trailToeZClearanceASO  = NaN;
    leadToeZASO  = NaN;
    trailToeZASO  = NaN;
end

%% Commit to session struct
sessionData.dependentMeasures_tr(trIdx).leadToeZClearanceASO = leadToeZClearanceASO;
sessionData.dependentMeasures_tr(trIdx).trailToeZClearanceASO = trailToeZClearanceASO;

sessionData.dependentMeasures_tr(trIdx).leadToeZASO = leadToeZASO;
sessionData.dependentMeasures_tr(trIdx).trailToeZASO = trailToeZASO;

% display 'In toeClearanceASO: leadToeZDist, trailToeZDist'

end