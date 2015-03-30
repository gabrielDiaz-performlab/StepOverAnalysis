%Gabriel Diaz
%Last modified: 3/27/15

function [ sessionData ] = stepLengthAndDurASO(sessionData, trIdx)


rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end


if(sum(strcmp(fieldnames(dmTrialStruct.lFoot),'stepDur_sIdx'))==0)
   error('Must run stepLengthAndDur.m prior to stepLengthAndDurASO.m \n')
   return 
end

%%
rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%%



