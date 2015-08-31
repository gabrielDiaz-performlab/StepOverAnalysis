%% Calculate mean of rigid body positions
function [sessionData] = calcMeanRigidBodyPos(sessionData, trIdx)

spine_fr_xyz = squeeze(nanmean(sessionData.processedData_tr(trIdx).rbPos_mFr_xyz,2));

rFoot_fr_mkr_XYZ = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz;

% Check to make sure critical marker data is not NAN
if( sum(sum(isnan(rFoot_fr_mkr_XYZ(:,[1 4],2)))) < 10 )
    rightFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(:,[1 4],:),2));
else
   % Attempting to calculate rigid body position from bad data
   sessionData.processedData_tr(trIdx).excludeTrial = 1;
   excludeMessage = sprintf('calcMeanRigidBodyPos: Bad marker data for right foot');
   
   if( isempty( sessionData.processedData_tr(trIdx).excludeTrialExplanation) )
       sessionData.processedData_tr(trIdx).excludeTrialExplanation{1} = excludeMessage;
   else
       sessionData.processedData_tr(trIdx).excludeTrialExplanation{end+1} = excludeMessage;
   end
   
   rightFoot_fr_XYZ = NaN;
   
end

leftFoot_fr_XYZ  = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz;

% Check to make sure critical marker data is not NAN
if( sum(sum(isnan(leftFoot_fr_XYZ(:,[1 4],2)))) < 10 )
    leftFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(:,[1 4],:),2));
else
    
   % Attempting to calculate rigid body position from bad data
   sessionData.processedData_tr(trIdx).excludeTrial = 1;
   excludeMessage = sprintf('calcMeanRigidBodyPos: Bad marker data for left foot');
   
   if( isempty( sessionData.processedData_tr(trIdx).excludeTrialExplanation) )
       sessionData.processedData_tr(trIdx).excludeTrialExplanation{1} = excludeMessage;
   else
       sessionData.processedData_tr(trIdx).excludeTrialExplanation{end+1} = excludeMessage;
   end
   
   leftFoot_fr_XYZ = NaN;
   
end

head_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trIdx).glasses.rbPos_mFr_xyz(:,[4 5],:),2));


sessionData.processedData_tr(trIdx).spine_fr_xyz = spine_fr_xyz;
sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ = rightFoot_fr_XYZ;
sessionData.processedData_tr(trIdx).leftFoot_fr_XYZ = leftFoot_fr_XYZ;
sessionData.processedData_tr(trIdx).head_fr_XYZ = head_fr_XYZ;

