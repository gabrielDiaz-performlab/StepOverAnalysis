%Andrew Smith
%Last Modified: 2 March 2015
function [sessionData] = stepSize(sessionData, trIdx)
%stepSize finds the both the step length and step width between each foot
%for each frame. 

%Identify needed data
rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);

%Average markers on right and left feet
rightFoot = mean(rawTrialStruct.rightFoot_fr_mkr_XYZ,2);
leftFoot = mean(rawTrialStruct.leftFoot_fr_mkr_XYZ,2);

%Step length is simply the difference between X locations, width is Y
if strcmp(proTrialStruct.firstCrossingFoot, 'Right')
    stepLength = rightFoot(:,:,1) - leftFoot(:,:,1);
    stepWidth = rightFoot(:,:,2) - leftFoot(:,:,2);
else
    stepLength = leftFoot(:,:,1) - rightFoot(:,:,1);
    stepWidth = leftFoot(:,:,2) - rightFoot(:,:,2);
end

sessionData.processedData_tr(trIdx).stepLength = stepLength;
sessionData.processedData_tr(trIdx).stepWidth = stepWidth;

%Do we have a way to find how many total steps are taken in a trial?



end