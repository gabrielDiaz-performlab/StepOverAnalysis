%Gabriel Diaz
%Last modified: 3/27/15

function [ sessionData ] = stepLengthAndDur(sessionData, trIdx)

if(sessionData.rawData_tr(trIdx).info.excludeTrial == 1)
    
    sessionData.dependentMeasures_tr(trIdx).lFoot.stepDur_sIdx = NaN;
    sessionData.dependentMeasures_tr(trIdx).rFoot.stepDur_sIdx = NaN;
    
    
    sessionData.dependentMeasures_tr(trIdx).lFoot.stepDist_sIdx = NaN;
    sessionData.dependentMeasures_tr(trIdx).rFoot.stepDist_sIdx = NaN;
    
    return
end

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
   fprintf('Must run findSteps.m prior to stepLength.m \n')
   return 
end

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
   fprintf('Must run findSteps.m prior to stepLength.m \n')
   return 
end


%% 

rTO_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx;
rHS_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.heelStrike_idx;

lTO_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;
lHS_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx;

%% Left foot step duration

frameTime_fr = sessionData.processedData_tr(trIdx).info.sysTime_fr;

%% Left & Right foot step length along the XY plane

rightFoot_fr_mkr_XYZ = sessionData.processedData_tr(trIdx).rFoot.mkrPos_mIdx_Cfr_xyz;
leftFoot_fr_mkr_XYZ = sessionData.processedData_tr(trIdx).lFoot.mkrPos_mIdx_Cfr_xyz;

rightFoot_fr_mkr_XYZ = cell2mat(permute(rightFoot_fr_mkr_XYZ, [3 2 1]));
leftFoot_fr_mkr_XYZ = cell2mat(permute(leftFoot_fr_mkr_XYZ, [3 2 1]));

% Grab the position on Y axis
rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,2,:));
leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,2,:));

% Find the Y data of the foot marker that is furthest up the Y axis
[ rightFootMaxY_frIdx,maxRightMkrIdx_fr] = max(rightFootY_frIdx_mIdx,[],2);
[ leftFootMaxY_frIdx, maxLeftMkrIdx_fr] = max(leftFootY_frIdx_mIdx,[],2);

% Find the Y data of the heel marker that is furthest down the Y axis
[ rightFootMinY_frIdx,minRightMkrIdx_fr] = min(rightFootY_frIdx_mIdx,[],2);
[ leftFootMinY_frIdx, minLeftMkrIdx_fr] = min(leftFootY_frIdx_mIdx,[],2);

%%

startPos_sIdx_Y = rightFootMaxY_frIdx(rTO_sIdx);
endPos_sIdx_Y = rightFootMinY_frIdx(rHS_sIdx);
rightFootDist_sIdx = (endPos_sIdx_Y-startPos_sIdx_Y);

startPos_sIdx_Y = leftFootMaxY_frIdx(lTO_sIdx);
endPos_sIdx_Y = leftFootMinY_frIdx(lHS_sIdx);
leftFootDist_sIdx = (endPos_sIdx_Y-startPos_sIdx_Y );

%%

sessionData.dependentMeasures_tr(trIdx).lFoot.stepDur_sIdx = frameTime_fr(lHS_sIdx)-frameTime_fr(lTO_sIdx);
sessionData.dependentMeasures_tr(trIdx).rFoot.stepDur_sIdx = frameTime_fr(rHS_sIdx)-frameTime_fr(rTO_sIdx);


sessionData.dependentMeasures_tr(trIdx).lFoot.stepDist_sIdx = leftFootDist_sIdx;
sessionData.dependentMeasures_tr(trIdx).rFoot.stepDist_sIdx = rightFootDist_sIdx;

