%Andrew Smith
%Last updated: 3/31

function [ sessionData ] = findDistPlantedFootASO(sessionData, trIdx)
%findDistPlantedFootsASO returns the distance from the obstacle (Y position) 
%center to the mean location of the subject's planted foot at step-over.

%Determine if step is with right or left foot, then Y location of other foot
stepFoot = sessionData.dependentMeasures_tr.firstCrossingFoot;
if strcmp(stepFoot, 'Right')
    crossFrame = sessionData.dependentMeasures_tr.rightFootCrossingFr;
    %Take location of off foot (average of all markers) at cross frame, 
    %mean foot marker location, y direction
    footData = sessionData.processedData_tr.leftFoot_fr_mkr_XYZ; 
    
    %ignore NaNs, take mean
    plantedFootLoc = nanmean(footData(crossFrame,:,2));
    
elseif strcmp(stepFoot, 'Left')
    crossFrame = sessionData.dependentMeasures_tr.leftFootCrossingFr;
    %Take location of off foot (average of all markers) at cross frame, 
    %mean foot marker location, y direction
    footData = sessionData.processedData_tr.rightFoot_fr_mkr_XYZ;
    
    %ignore NaNs, take mean
    plantedFootLoc = nanmean(footData(crossFrame,:,2)); 
    
else
    print('findDistOfPlantedFootASO: Unknown initial step foot');
end


obsLoc = sessionData.rawData_tr.obstacle_XposYposHeight;  

sessionData.dependentMeasures_tr(trIdx).distPlantedFoot = abs(obsLoc(2) - plantedFootLoc);

end