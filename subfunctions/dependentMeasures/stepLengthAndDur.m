%Gabriel Diaz
%Last modified: 3/27/15

function [ sessionData ] = stepLengthAndDur(sessionData, trIdx)

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);


if(sessionData.rawData_tr(trIdx).excludeTrial == 1)
    
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

%% Left food step duration

frameTime_fr = sessionData.rawData_tr(trIdx).frameTime_fr;

%% Left food step length along the XY plane

%%
rightFoot_fr_mkr_XYZ = rawTrialStruct.rightFoot_fr_mkr_XYZ;
leftFoot_fr_mkr_XYZ = rawTrialStruct.leftFoot_fr_mkr_XYZ;

rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,:,2));
leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,:,2));

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

