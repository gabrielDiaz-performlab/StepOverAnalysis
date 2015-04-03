%Gabriel Diaz
%Last modified: 3/27/15

function [ sessionData ] = stepLengthAndDurASO(sessionData, trIdx)


%rawTrialStruct = sessionData.rawData_tr(trIdx);
%proTrialStruct = sessionData.processedData_tr(trIdx);


dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

if(sum(strcmp(fieldnames(dmTrialStruct),'bothFeet'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end

% If a stepover was not found, set stepLengthASO and stepDurASO_sIdx to nan
if( isnan(dmTrialStruct.bothFeet.crossingStepIdx) )
    %fprintf('stepLengthAndDurASO: Subject did not pass the obstacle. \n');
    sessionData.dependentMeasures_tr(trIdx).stepLengthASO = nan;
    sessionData.dependentMeasures_tr(trIdx).stepDurASO_sIdx = nan;
    return
end

bf = dmTrialStruct.bothFeet;
crossStepIdx = bf.crossingStepIdx;
    
stepLength = bf.stepDist_sIdx(crossStepIdx);
stepDur_sIdx = bf.stepDur_sIdx(crossStepIdx);

%%

sessionData.dependentMeasures_tr(trIdx).stepLengthASO = stepLength;
sessionData.dependentMeasures_tr(trIdx).stepDurASO_sIdx = stepLength;

%%



