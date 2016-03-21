%Gabriel Diaz

function [ sessionData ] = maxVelAndHeightAXS(sessionData, trIdx)

% If this trial is being excluded, skip the analysis

dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%  Some checks

if(sum(strcmp(fieldnames(dmTrialStruct),'lFoot'))==0 || sum(strcmp(fieldnames(dmTrialStruct),'rFoot'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end


if(sessionData.rawData_tr(trIdx).info.excludeTrial == 1)
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = nan;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = nan;
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = nan;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = nan;
    
    return
end

if( strcmp( dmTrialStruct.firstCrossingFoot, 'Left' ) ) 
    
    leadFootDM = sessionData.dependentMeasures_tr(trIdx).lFoot;
    trailFootDM = sessionData.dependentMeasures_tr(trIdx).rFoot;
    
    leadStepFrames_idx = leadFootDM.toeOff_idx( leadFootDM.crossingStepIdx):leadFootDM.heelStrike_idx( leadFootDM.crossingStepIdx );
    trailStepFrames_idx = trailFootDM.toeOff_idx( trailFootDM.crossingStepIdx):trailFootDM.heelStrike_idx( trailFootDM.crossingStepIdx );
    
    leadFoot_fr_XYZ = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(leadStepFrames_idx,:);
    trailFoot_fr_XYZ = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(trailStepFrames_idx ,:);
    
elseif( strcmp( dmTrialStruct.firstCrossingFoot, 'Right' ) )
    
    leadFootDM = sessionData.dependentMeasures_tr(trIdx).rFoot;
    trailFootDM = sessionData.dependentMeasures_tr(trIdx).lFoot;
    
    leadStepFrames_idx = leadFootDM.toeOff_idx( leadFootDM.crossingStepIdx):leadFootDM.heelStrike_idx( leadFootDM.crossingStepIdx );
    trailStepFrames_idx = trailFootDM.toeOff_idx( trailFootDM.crossingStepIdx):trailFootDM.heelStrike_idx( trailFootDM.crossingStepIdx );
    
    leadFoot_fr_XYZ = sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(leadStepFrames_idx,:);
    trailFoot_fr_XYZ = sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(trailStepFrames_idx ,:);
      
else
   error('invalid entry for sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot') 
end


%% LEAD FOOT

leadFootVel_fr = [0; sqrt(sum(diff(leadFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];

[maxLeadFootVelASX, ~] = max(leadFootVel_fr);

[maxLeadFootZASX, ~] = max(leadFoot_fr_XYZ(:,3));

%% TRAIL FOOT

trailFootVel_fr = [0; sqrt(sum(diff(trailFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];

[maxTrailFootVelASX, ~] = max(trailFootVel_fr);

[maxTrailFootZASX, ~] = max(trailFoot_fr_XYZ(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Assign to variables

sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = maxLeadFootVelASX;
sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = maxTrailFootVelASX;

sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = maxLeadFootZASX;
sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = maxTrailFootZASX;


