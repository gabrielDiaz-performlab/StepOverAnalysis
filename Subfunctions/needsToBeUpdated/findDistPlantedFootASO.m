%Andrew Smith
%Assumptions:...
%FIXME:...

function [ sessionData ] = findDistPlantedFootASO(sessionData, trIdx)
%findDistPlantedFootsASO [description]
%[Description of inputs]

sessionData.rawData_tr(trIdx)
rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);

%Determine if step is with right or left foot, then X location of other foot
stepFoot = proTrialStruct.firstCrossingFoot;
if strcmp(stepFoot, 'Right')
    crossFrame = proTrialStruct.rightFootCrossingFr;
    plantedFootLoc = rawTrialStruct.leftFoot_fr_mkr_XYZ(crossFrame,1,1); %Should be location of off foot at cross frame, marker 1, in x direction
    
elseif strcmp(stepFoot, 'Left')
    crossFrame = proTrialStruct.leftFootCrossingFr;
    plantedFootLoc = rawTrialStruct.rightFoot_fr_mkr_XYZ(crossFrame,1,1); %Should be location of off foot at cross frame, marker 1, in x direction

else
    print('findDistOfPlantedFootASO: Unknown initial step foot');
end


obsLoc = rawTrialStruct.obstacle_XYZ(1,1);  %FIXME: what is in this struct
sessionData.processedData_tr(trIdx).distPlantedFoot = abs(obsLoc - plantedFootLoc);

end