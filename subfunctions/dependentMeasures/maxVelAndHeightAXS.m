%Gabriel Diaz

function [ sessionData ] = maxVelAndHeightAXS(sessionData, trIdx)

dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%%  Some checks

if(sum(strcmp(fieldnames(dmTrialStruct),'lFoot'))==0 || sum(strcmp(fieldnames(dmTrialStruct),'rFoot'))==0)
   error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
   return 
end

% If a stepover was not found, set stepLengthASO and stepDurASO_sIdx to nan
if( isnan(dmTrialStruct.bothFeet.crossingStepIdx) )
    
    fprintf('maxVelAndHeightAXS: Subject did not pass the obstacle. \n');
    
    sessionData.dependentMeasures_tr(trIdx).lFoot.maxVelASX = NaN;
    sessionData.dependentMeasures_tr(trIdx).rFoot.maxVelASX = NaN;
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = NaN;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = NaN;
    
    sessionData.dependentMeasures_tr(trIdx).lFoot.maxZASX = NaN;
    sessionData.dependentMeasures_tr(trIdx).rFoot.maxZASX = NaN;
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = NaN;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = NaN;

    return
    
    %sessionData.dependentMeasures_tr(trIdx).maxVelAndHeightAXS = nan;
    %sessionData.dependentMeasures_tr(trIdx).stepDurASO_sIdx = nan;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Left foot

lf = dmTrialStruct.lFoot;
crossStepIdx = lf.crossingStepIdx;

try
    stepFrames_idx = lf.toeOff_idx(crossStepIdx):lf.heelStrike_idx(crossStepIdx);
    lFoot_fr_XYZ = sessionData.processedData_tr(trIdx).leftFoot_fr_XYZ(stepFrames_idx,:);
catch
    keyboard
end
% Shouldn't velocity just be stored from the interpolation step?
lFootVel_fr = [0; sqrt(sum(diff(lFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];
    
%diff(sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ(:,3))./sessionData.expInfo.meanFrameDur];

[maxLeftFootVelASX maxIdxLeft] = max(lFootVel_fr);
maxIdxLeft = -1 + stepFrames_idx(1) + maxIdxLeft;

[maxLeftFootZASX maxZIdxLeft] = max(lFoot_fr_XYZ(:,3));
maxZIdxLeft = -1 + stepFrames_idx(1) + maxZIdxLeft;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Right foot

rf = dmTrialStruct.rFoot;
crossStepIdx = rf.crossingStepIdx;

stepFrames_idx = rf.toeOff_idx(crossStepIdx):rf.heelStrike_idx(crossStepIdx);
rFoot_fr_XYZ = sessionData.processedData_tr(trIdx).rightFoot_fr_XYZ(stepFrames_idx,:);

% Shouldn't velocity just be stored from the interpolation step?
rFootVel_fr = [0; sqrt(sum(diff(rFoot_fr_XYZ).^2,2))./sessionData.expInfo.meanFrameDur];
  

[maxRightFootVelASX maxVelIdxRight] = max(rFootVel_fr);
maxVelIdxRight= -1 + stepFrames_idx(1) + maxVelIdxRight;

[maxRightFootZASX maxZIdxRight] = max(rFoot_fr_XYZ(:,3));
maxZIdxRight= -1 + stepFrames_idx(1) + maxZIdxRight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Assign to variables

sessionData.dependentMeasures_tr(trIdx).lFoot.maxVelASX = maxLeftFootVelASX;
sessionData.dependentMeasures_tr(trIdx).rFoot.maxVelASX = maxRightFootVelASX;

sessionData.dependentMeasures_tr(trIdx).lFoot.maxZASX = maxLeftFootZASX;
sessionData.dependentMeasures_tr(trIdx).rFoot.maxZASX = maxRightFootZASX;

if( strcmp(sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot,'Left') )
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = maxLeftFootVelASX;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = maxRightFootVelASX;
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = maxLeftFootZASX;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = maxRightFootZASX;
    
elseif( strcmp(sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot,'Right'))
    
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxVelAXS = maxRightFootVelASX;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxVelAXS = maxLeftFootVelASX;
    
    sessionData.dependentMeasures_tr(trIdx).leadFootMaxZAXS = maxRightFootZASX;
    sessionData.dependentMeasures_tr(trIdx).trailFootMaxZAXS = maxLeftFootZASX;
    
    
end



