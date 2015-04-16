%Andrew Smith
%Last updated: 3/31

function [ sessionData ] = findDistPlantedFootASO(sessionData, trIdx)
%findDistPlantedFootsASO returns the distance from the obstacle (Y position)
%center to the mean location of the subject's planted foot at step-over.

dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

if(sessionData.rawData_tr(trIdx).excludeTrial == 1)
    
    sessionData.dependentMeasures_tr(trIdx).distPlantedFootASO = nan;
    
    return
end


% if( isnan(dmTrialStruct.lFoot.crossingStepIdx) || ...
%         isnan(dmTrialStruct.rFoot.crossingStepIdx))
%     
%     sessionData.dependentMeasures_tr(trIdx).distPlantedFootASO = NaN;
% 
%     sessionData.rawData_tr(trIdx).excludeTrial = 1;
%     sessionData.rawData_tr(trIdx).excludeTrialExplanation{end+1} = 'findDistPlantedFootASO: At least one foot did not pass the barrier.'
%     
%     return
% end



%Determine if step is with right or left foot, then Y location of other foot
stepFoot = sessionData.dependentMeasures_tr.firstCrossingFoot;

if strcmp(stepFoot, 'Right')
    
    % Crossing frame of right foot
    crossFrame = sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr;
    % Position of leftfoot at cross
    plantedFootYLoc = sessionData.processedData_tr(trIdx).leftFoot_fr_XYZ(crossFrame,2);
    
elseif strcmp(stepFoot, 'Left')
    
    % Crossing frame of left foot
    crossFrame = sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr;
    % Position of right foot at cross
    plantedFootYLoc = sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ(crossFrame,2);
    
else
    error('findDistOfPlantedFootASO: Unknown initial step foot');
end

obsLoc = sessionData.rawData_tr.obstacle_XposYposHeight;
sessionData.dependentMeasures_tr(trIdx).distPlantedFootASO = abs(obsLoc(2) - plantedFootYLoc);

