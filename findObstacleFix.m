function [ sessionData ] = findObstacleFix( sessionData, trIdx, plotOn)

loadParameters

angSep_fr = sessionData.processedData_tr(trIdx).ETG.angSeparation;
ETGtsSec_fr = sessionData.processedData_tr(trIdx).ETG.ETG_ts;

% compute fixMS_idx_onOff
roiOnObs_fr = angSep_fr <= tAngSep;

%% Clump pursuits within clump_t_thresh of one another
lastROIOnObsFr = find( roiOnObs_fr== 1,1,'first');

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

% Convert into stops/starts format
roiOnObs_idx_onOff = contiguous(roiOnObs_fr, 1);
roiOnObs_idx_onOff = roiOnObs_idx_onOff{1,2};

% must pass min duration thershold
belowDurThresIdx = 1000*(ETGtsSec_fr(roiOnObs_idx_onOff(:,2)) - ETGtsSec_fr(roiOnObs_idx_onOff(:,1))) <= roiOnObsMinDuration;
roiOnObs_idx_onOff(belowDurThresIdx,:)=[];

tStart = ETGtsSec_fr(roiOnObs_idx_onOff(:,1));
tStop = ETGtsSec_fr(roiOnObs_idx_onOff(:,2));

if plotOn
    figure; hold on;
    plot(ETGtsSec_fr, angSep_fr); xlabel('Time'), ylabel('Angular separation (degrees)')
    for i = 1:size(tStart,1)
        plot([tStart(i) tStart(i)], [0 180],'g--','LineWidth',2.5);
        plot([tStop(i) tStop(i)], [0 180],'r--','LineWidth',2.5);
    end
end
sessionData.processedData_tr(trIdx).ETG.roiOnObs_onOff = roiOnObs_idx_onOff;

end