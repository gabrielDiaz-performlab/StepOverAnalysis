%%
function [] =  plotLeadFootTrafForEachSubAndCond(sessionData_sIdx)

frBefore = 80;
frAfter = 30;

figure(1010)
hold on
cla

set(1010,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
title({'lead foot position','in units of leg length','for 1 obstacle height'})


% Here, we take a few steps that allow us to normalize over frames
% temporally aligned with arrival at the obstacle

% pre-initialize a matrix of NaNs that is larger than the possible trial
% duration

padLength = round(sessionData.expInfo.meanTrialDuration / sessionData.expInfo.meanFrameDur)*2;
leadFoot_tr_fr_XYZ = nan(sessionData.expInfo.numTrials,padLength,3);

subSpacingList_idx = linspace(0,2,numel(sessionFileList)*2);

hIdx = 1;

for sIdx = 1:numel(sessionData_sIdx)
    for cIdx = 1:2
        
        sessionData = sessionData_sIdx(sIdx);
        
        ttypeNum = hIdx + ((cIdx-1)*3);
        % Get indices for the trial type specified by hIdx and cIdx
        trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == ttypeNum );
        % Get indices for trials to be exlcuded
        excludeTrials_tIdx = find( [sessionData.rawData_tr.excludeTrial] == 1 );
        % Set diff
        trOfType_tIdx = setdiff(trOfType_tIdx,excludeTrials_tIdx);
        
        for trIdx = 1:numel(trOfType_tIdx)
            
            trNum = trOfType_tIdx(trIdx);
            
            if( strcmp( sessionData.dependentMeasures_tr(trNum).firstCrossingFoot, 'Left' ) )
                
                crossFr = find(sessionData.processedData_tr(trNum).lFootBS_fr_XYZ(:,2) < 0,1,'first');
                footData_fr_XYZ = sessionData.processedData_tr(trNum).lFootBS_fr_XYZ;
                %if( ~isempty(crossFr) )
                %leadFoot_tr_fr_XYZ(trIdx,:,:) = sessionData.processedData_tr(trIdxList(trIdx)).lFootBS_fr_XYZ(crossFr-frBefore:crossFr+frAfter,:);
                %end
                
            else
                crossFr = find(sessionData.processedData_tr(trNum).rFootBS_fr_XYZ(:,2) < 0,1,'first');
                footData_fr_XYZ = sessionData.processedData_tr(trNum).rFootBS_fr_XYZ;
            end
            
            if( ~isempty(crossFr) )
                paddedFrNums = [1:size(footData_fr_XYZ,1)] + ceil(padLength/2) - crossFr;
                leadFoot_tr_fr_XYZ(trIdx,paddedFrNums,:) = footData_fr_XYZ;
            end
            
        end
            leadFoot_fr_XYZ = squeeze(nanmean(leadFoot_tr_fr_XYZ,1));
            
            if( cIdx  == 1 )
                %xVal = sessionData.expInfo.obsHeightRatios((ttypeNum - 3));
                plotColor = 'r';
            else
                %xVal = sessionData.expInfo.obsHeightRatios((ttypeNum));
                plotColor = 'b';
            end
            
            xVal = subSpacingList_idx(sIdx + (3 * (cIdx-1)));
            
            X = repmat(xVal,1,size(leadFoot_fr_XYZ,1));
            Y = leadFoot_fr_XYZ(:,2);
            Z = leadFoot_fr_XYZ(:,3);
            
            plot3(X,Y,Z,plotColor)
    end
end
