%% Calculate mean of rigid body positions
function [sessionData] = calcMeanRigidBodyPos(sessionData, trialNum)

spine_fr_xyz = squeeze(nanmean(sessionData.processedData_tr(trialNum).spine_fr_mkr_XYZ,2));
rightFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).rightFoot_fr_mkr_XYZ(:,[1 4],:),2));
leftFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).leftFoot_fr_mkr_XYZ(:,[1 4],:),2));
head_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).head_fr_mkr_XYZ(:,[4 5],:),2));

sessionData.processedData_tr(trialNum).spine_fr_xyz = spine_fr_xyz;
sessionData.processedData_tr(trialNum).rightFoot_fr_XYZ = rightFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).leftFoot_fr_XYZ = leftFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).head_fr_XYZ = head_fr_XYZ;
