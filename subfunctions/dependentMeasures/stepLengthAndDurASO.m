%Gabriel Diaz
%Last modified: 3/27/15

function [ sessionData ] = stepLengthAndDurASO(sessionData, trIdx)


dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

if(sum(strcmp(fieldnames(dmTrialStruct),'bothFeet'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end

if( isnan(dmTrialStruct.lFoot.crossingStepIdx) || isnan(dmTrialStruct.rFoot.crossingStepIdx)  )
    
    sessionData.dependentMeasures_tr(trIdx).leadStepLengthASO = nan;
    sessionData.dependentMeasures_tr(trIdx).leadStepDurASO = nan;
    
    sessionData.dependentMeasures_tr(trIdx).trailStepLengthASO = nan;
    sessionData.dependentMeasures_tr(trIdx).trailStepDurASO = nan;
    
    sessionData.rawData_tr(trIdx).excludeTrial = 1;
    sessionData.rawData_tr(trIdx).excludeTrialExplanation{end+1} = 'stepLengthAndDurASO: At least one foot did not pass the barrier.'
    
    return
end

%%
if( strcmp( dmTrialStruct.firstCrossingFoot, 'Left' ) ) 
    
    leadFoot = sessionData.dependentMeasures_tr(trIdx).lFoot;
    trailFoot = sessionData.dependentMeasures_tr(trIdx).rFoot;
    
elseif( strcmp( dmTrialStruct.firstCrossingFoot, 'Right' ) )
    
    leadFoot = sessionData.dependentMeasures_tr(trIdx).rFoot;
    trailFoot = sessionData.dependentMeasures_tr(trIdx).lFoot;
    
else
   error('invalid entry for sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot') 
end


%% FIND LEAD STEP LENGTH / DURATION

crossStepIdx = leadFoot.crossingStepIdx;
leadStepLengthASO = leadFoot.stepDist_sIdx(crossStepIdx);
leadStepDurASO = leadFoot.stepDur_sIdx(crossStepIdx);

%% FIND TRAIL STEP LENGTH / DURATION

crossStepIdx = trailFoot.crossingStepIdx;
trailStepLengthASO = trailFoot.stepDist_sIdx(crossStepIdx);
trailStepDurASO = trailFoot.stepDur_sIdx(crossStepIdx);

%% SAVE TO SESSIONDATA

sessionData.dependentMeasures_tr(trIdx).leadStepLengthASO = leadStepLengthASO;
sessionData.dependentMeasures_tr(trIdx).leadStepDurASO = leadStepDurASO;

sessionData.dependentMeasures_tr(trIdx).trailStepLengthASO = trailStepLengthASO;
sessionData.dependentMeasures_tr(trIdx).trailStepDurASO = trailStepDurASO;





