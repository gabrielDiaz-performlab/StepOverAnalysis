%% Rakshit Kothari
% This function computes the frames when the object was on the visual field
% of the participant. It also computes the step percentage completion.  

function [ sessionData ] = findObstacleFix( sessionData, trIdx, plotOn)

loadParameters

Ts = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
sysTime = sessionData.processedData_tr(trIdx).info.sysTime_fr;

angSep_fr = sessionData.processedData_tr(trIdx).ETG.angSeparation;
ETGtsSec_fr = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
rFootStep = [sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx;   sessionData.dependentMeasures_tr(trIdx).rFoot.heelStrike_idx];
lFootStep = [sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;   sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx];
glasses_fr_xyz = sessionData.processedData_tr(trIdx).glasses.pos_fr_xyz;

objLoc = sessionData.processedData_tr(trIdx).obs.pos_xyz;

roiOnObs_fr = angSep_fr <= tAngSep;

firstCrossingFoot = sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot;

if strcmp(firstCrossingFoot, 'right')
    crossingFr = sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr;
    crossingTs = sessionData.processedData_tr(trIdx).rFoot.rbPosSysTime_mFr_xyz(crossingFr);   
else
    crossingFr = sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr;
    crossingTs = sessionData.processedData_tr(trIdx).lFoot.rbPosSysTime_mFr_xyz(crossingFr);  
end

%% Clump pursuits within clump_t_thresh of one another
lastROIOnObsFr = find( roiOnObs_fr == 1,1,'first');

for idx = (lastROIOnObsFr+1):numel(roiOnObs_fr)

    if( roiOnObs_fr(idx) == 1) 
        % If temporal distance to lastPur is less than a threshold, make sure
        % intermediate frames are also 1
        if( (ETGtsSec_fr(idx) - ETGtsSec_fr(lastROIOnObsFr)) <= (roiTemporalClumpThreshMS/1000) )
            roiOnObs_fr(lastROIOnObsFr:idx) = 1;
        end        
        lastROIOnObsFr = idx;      
    end    
end


locObjVisible = (objLoc(:,2) - glasses_fr_xyz(:,2)) > 0 & (Ts > sysTime(sessionData.processedData_tr(trIdx).info.eventFlag_fr == 3));

roiOnObs_fr = roiOnObs_fr & locObjVisible;
totalObjVisibleTime = ETGtsSec_fr(locObjVisible);
totalObjVisibleTime = totalObjVisibleTime(end) - totalObjVisibleTime(1);

if plotOn
    figure; hold on;
    plot(ETGtsSec_fr, angSep_fr,'LineWidth',3); xlabel('Time'), ylabel('Angular separation (degrees)')
    title(['Angular separation for Trial: ' num2str(trIdx) ' Distance: ' num2str(objLoc(2))])
end

if sum(roiOnObs_fr)>0
    
    % Convert into stops/starts format
    roiOnObs_idx_onOff = contiguous(roiOnObs_fr, 1);
    roiOnObs_idx_onOff = roiOnObs_idx_onOff{1,2};

    % must pass min duration thershold
    belowDurThresIdx = 1000*(ETGtsSec_fr(roiOnObs_idx_onOff(:,2)) - ETGtsSec_fr(roiOnObs_idx_onOff(:,1))) <= roiOnObsMinDuration;
    roiOnObs_idx_onOff(belowDurThresIdx,:) = [];
 
    if ~isempty(roiOnObs_idx_onOff)
     
        frObjFirstSeen = find(roiOnObs_fr,1);
        tStart = ETGtsSec_fr(roiOnObs_idx_onOff(:,1));
        tStop = ETGtsSec_fr(roiOnObs_idx_onOff(:,2));

        locr = frObjFirstSeen < rFootStep(2,:) & frObjFirstSeen > rFootStep(1,:);
        locl = frObjFirstSeen < lFootStep(2,:) & frObjFirstSeen > lFootStep(1,:);
        
        if sum(locr) == 0 && sum(locl) == 0
            StepFlag = 2; % During double support
            firstLookStepPer = 100;
        elseif xor( sum(locr) == 1 ,sum(locl) == 1) 
            firstLookStepPer = sum(locr)*findFootPercent(frObjFirstSeen, rFootStep(:,locr)) + sum(locl)*findFootPercent(frObjFirstSeen, lFootStep(:,locl));
            StepFlag = 1;
        else 
            StepFlag = 0;
            firstLookStepPer = NaN;
            display('Error: Both feet cannot be taking a step')
            keyboard
        end
        
        if plotOn
            for i = 1:size(tStart,1)
                plot([tStart(i) tStart(i)], [0 180],'g--','LineWidth',3);
                plot([tStop(i) tStop(i)], [0 180],'r--','LineWidth',3);
            end
        end
        % Find steps to obstacle after made visible
        loc = find(locObjVisible, 1);
        stepLocs = cell2mat(sessionData.dependentMeasures_tr(trIdx).stepFlow(1:end-1, 3));
        inSteps = loc >= stepLocs(:,1) & loc <= stepLocs(:,2);
        
        if sum(inSteps) == 0
            sessionData.dependentMeasures_tr(trIdx).stepsToObs = sum(stepLocs(:,1) >= loc);
        else
            if abs(loc - stepLocs(inSteps, 1)) < abs(loc - stepLocs(inSteps, 2)) 
                sessionData.dependentMeasures_tr(trIdx).stepsToObs = size(stepLocs, 1) - find(inSteps) + 1;
            else
                sessionData.dependentMeasures_tr(trIdx).stepsToObs = size(stepLocs, 1) - find(inSteps);
            end
        end
  
        loc = roiOnObs_idx_onOff(:, 1);
        sessionData.dependentMeasures_tr(trIdx).stepsToObs = repmat(sessionData.dependentMeasures_tr(trIdx).stepsToObs, [length(loc) 1]);
    
        for k = 1:length(loc)
           inSteps = loc(k) >= stepLocs(:,1) & loc(k) <= stepLocs(:,2);
           
           if sum(inSteps) == 0
               sessionData.dependentMeasures_tr(trIdx).fixOnStep(k) = sum(stepLocs(:,1) >= loc(k)) + 0.5;
           else
               sessionData.dependentMeasures_tr(trIdx).fixOnStep(k) = size(stepLocs, 1) - find(inSteps) + 1;
           end
        end
        
        sessionData.dependentMeasures_tr(trIdx).fixOnStep = sessionData.dependentMeasures_tr(trIdx).fixOnStep';
        
        sessionData.processedData_tr(trIdx).roiOnObs_onOff = roiOnObs_idx_onOff;
        sessionData.dependentMeasures_tr(trIdx).numFixOnObj = length(tStart);
        sessionData.dependentMeasures_tr(trIdx).totLenFixOnObj = 100*sum(tStop - tStart)/totalObjVisibleTime;
        sessionData.dependentMeasures_tr(trIdx).firstLook = crossingTs - tStart(1);
        sessionData.dependentMeasures_tr(trIdx).firstLookStepPer = firstLookStepPer;
        sessionData.dependentMeasures_tr(trIdx).StepFlag = StepFlag;
        sessionData.dependentMeasures_tr(trIdx).timeFromObjAppear = tStart(1) -  ETGtsSec_fr(find(locObjVisible,1));
        
        sessionData.dependentMeasures_tr(trIdx).distFromSBFirstLook = ...
                sessionData.processedData_tr(trIdx).glasses.rbPos_mFr_xyz(frObjFirstSeen,2);
        
        sessionData.dependentMeasures_tr(trIdx).distFromObjFirstLook = ...
                sessionData.processedData_tr(trIdx).obs.pos_xyz(2) - ...
                sessionData.processedData_tr(trIdx).spine.rbPos_mFr_xyz(frObjFirstSeen,2);
    else
        sessionData.processedData_tr(trIdx).roiOnObs_onOff = NaN;
        sessionData.dependentMeasures_tr(trIdx).numFixOnObj = 0;
        sessionData.dependentMeasures_tr(trIdx).totLenFixOnObj = NaN;
        sessionData.dependentMeasures_tr(trIdx).firstLook = NaN;
        sessionData.dependentMeasures_tr(trIdx).distFromObjFirstLook = NaN;
        sessionData.dependentMeasures_tr(trIdx).distFromSBFirstLook = NaN;
        sessionData.dependentMeasures_tr(trIdx).firstLookStepPer = NaN;
        sessionData.dependentMeasures_tr(trIdx).StepFlag = NaN;
        sessionData.dependentMeasures_tr(trIdx).timeFromObjAppear = NaN;
    end
else
    sessionData.processedData_tr(trIdx).roiOnObs_onOff = NaN;
    sessionData.dependentMeasures_tr(trIdx).numFixOnObj = NaN;
    sessionData.dependentMeasures_tr(trIdx).totLenFixOnObj = NaN;
    sessionData.dependentMeasures_tr(trIdx).firstLook = NaN;
    sessionData.dependentMeasures_tr(trIdx).distFromObjFirstLook = NaN;
    sessionData.dependentMeasures_tr(trIdx).distFromSBFirstLook = NaN;   
    sessionData.dependentMeasures_tr(trIdx).firstLookStepPer = NaN;
    sessionData.dependentMeasures_tr(trIdx).StepFlag = NaN;
    sessionData.dependentMeasures_tr(trIdx).timeFromObjAppear = NaN;
end

end