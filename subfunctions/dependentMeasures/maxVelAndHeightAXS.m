%Gabriel Diaz

function [ sessionData ] = maxVelAndHeightAXS(sessionData, trIdx)

dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%%  Some checks

if(sum(strcmp(fieldnames(dmTrialStruct),'lFoot'))==0 || sum(strcmp(fieldnames(dmTrialStruct),'rFoot'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end


if( strcmp( dmTrialStruct.firstCrossingFoot, 'Left' ) ) 
    
    leadFootDM = sessionData.dependentMeasures_tr(trIdx).lFoot;
    trailFootDM = sessionData.dependentMeasures_tr(trIdx).rFoot;
    
    leadStepFrames_idx = leadFootDM.toeOff_idx( leadFootDM.crossingStepIdx):leadFootDM.heelStrike_idx( leadFootDM.crossingStepIdx );
    trailStepFrames_idx = trailFootDM.toeOff_idx( trailFootDM.crossingStepIdx):trailFootDM.heelStrike_idx( trailFootDM.crossingStepIdx );
    
    leadFoot_fr_XYZ = sessionData.processedData_tr(trIdx).leftFoot_fr_XYZ(leadStepFrames_idx,:);
    trailFoot_fr_XYZ = sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ(trailStepFrames_idx ,:);
    
elseif( strcmp( dmTrialStruct.firstCrossingFoot, 'Right' ) )
    
    leadFootDM = sessionData.dependentMeasures_tr(trIdx).rFoot;
    trailFootDM = sessionData.dependentMeasures_tr(trIdx).lFoot;
    
    leadStepFrames_idx = leadFootDM.toeOff_idx( leadFootDM.crossingStepIdx):leadFootDM.heelStrike_idx( leadFootDM.crossingStepIdx );
    trailStepFrames_idx = trailFootDM.toeOff_idx( trailFootDM.crossingStepIdx):trailFootDM.heelStrike_idx( trailFootDM.crossingStepIdx );
    
    leadFoot_fr_XYZ = sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ(leadStepFrames_idx,:);
    trailFoot_fr_XYZ = sessionData.processedData_tr(trIdx).leftFoot_fr_XYZ(trailStepFrames_idx ,:);
      
else
   error('invalid entry for sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot') 
end


%% LEAD FOOT


leadFootVel_fr = [0; sqrt(sum(diff(leadFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];

[maxLeadFootVelASX maxIdxVelLead] = max(leadFootVel_fr);
maxIdxVelLead = -1 + leadStepFrames_idx(1) + maxIdxVelLead;

[maxLeadFootZASX maxZIdxLead] = max(leadFoot_fr_XYZ(:,3));
maxZIdxLead = -1 + leadStepFrames_idx(1) + maxZIdxLead;

%% TRAIL FOOT

trailFootVel_fr = [0; sqrt(sum(diff(trailFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];
[maxTrailFootVelASX maxIdxTrail] = max(trailFootVel_fr);
maxIdxVelTrail = -1 + trailStepFrames_idx(1) + maxIdxTrail;
[maxTrailFootZASX maxZIdxTrail] = max(trailFoot_fr_XYZ(:,3));
maxZIdxTrail = -1 + trailStepFrames_idx(1) + maxZIdxTrail;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Assign to variables

sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = maxLeadFootVelASX;
sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = maxTrailFootVelASX;

sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = maxLeadFootZASX;
sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = maxTrailFootZASX;


