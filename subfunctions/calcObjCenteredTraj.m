function [ sessionData ] = calcObjCenteredTraj(sessionData, trIdx)
%findDistPlantedFootsASO returns the distance from the obstacle (Y position)
%center to the mean location of the subject's planted foot at step-over.

if(sessionData.rawData_tr(trIdx).info.excludeTrial == 1)    
    sessionData.processedData_tr(trIdx).rFootBS_fr_XYZ = nan;
    sessionData.processedData_tr(trIdx).lFootBS_fr_XYZ = nan;
    return
end

%%
procData = sessionData.processedData_tr(trIdx);
rawData = sessionData.rawData_tr(trIdx);

% Leg length
% legLength = sessionData.expInfo.obstacleHeights(1) ./ sessionData.expInfo.obsHeightRatios(1);

%% Right foot

rFootObsCentered_fr_XYZ = procData.rFoot.rbPos_mFr_xyz;
rFootObsCentered_fr_XYZ(:,2) = rFootObsCentered_fr_XYZ(:,2) - rawData.obs.pos_xyz(2); 
%rFootObsCentered_fr_XYZ = rFootObsCentered_fr_XYZ ./ repmat(legLength,size(rFootObsCentered_fr_XYZ));

%% Left foot

lFootObsCentered_fr_XYZ = procData.lFoot.rbPos_mFr_xyz;
lFootObsCentered_fr_XYZ(:,2) =   lFootObsCentered_fr_XYZ(:,2) - rawData.obs.pos_xyz(2);
%lFootObsCentered_fr_XYZ = lFootObsCentered_fr_XYZ ./ repmat(legLength,size(lFootObsCentered_fr_XYZ));

%%

sessionData.processedData_tr(trIdx).rFoot.rFootObsCentered_fr_XYZ = rFootObsCentered_fr_XYZ;
sessionData.processedData_tr(trIdx).lFoot.lFootObsCentered_fr_XYZ  = lFootObsCentered_fr_XYZ;