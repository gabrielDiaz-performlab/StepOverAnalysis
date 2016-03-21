function [figH] = plotAvgTraj_Tr_C_H(sessionData)

% Here, we take a few steps that allow us to normalize over frames
% temporally aligned with arrival at the obstacle

% pre-initialize a matrix of NaNs that is larger than the possible trial
% duration

padLength = round(sessionData.expInfo.meanTrialDuration / sessionData.expInfo.meanFrameDur)*2;
%leadFoot_tr_fr_XYZ = nan(sessionData.expInfo.numTrials,padLength,3);

for hIdx = 1:3;
    
    figH = figure(1011+hIdx);
    hold on
    cla
    xlabel('foot distance (m)')
    ylabel('foot height (m)')
    
    
    set(gcf,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
    title({'lead foot position','in units of leg length','for 1 obstacle height'})
    
    for cIdx = 1:1
        
        ttypeNum = hIdx + ((cIdx-1)*3);
        % Get indices for the trial type specified by hIdx and cIdx
        trOfType_tIdx = find( [sessionData.expInfo.trialTypes_Idx] == ttypeNum );
        % Get indices for trials to be exlcuded
        excludeTrials_tIdx = find( [sessionData.expInfo.excludeTrial] == 1 );
        % Set diff
        trOfType_tIdx = setdiff(trOfType_tIdx,excludeTrials_tIdx);
        
        leadFoot_tr_fr_XYZ = nan(numel(trOfType_tIdx),padLength,3);
%         frameTime_tr_fr = nan(numel(trOfType_tIdx),padLength);
        
        for trIdx = 1:numel(trOfType_tIdx)
            
            trNum = trOfType_tIdx(trIdx);
            
            if( strcmp( sessionData.dependentMeasures_tr(trNum).firstCrossingFoot, 'Left' ) )
                
                crossFr = find(sessionData.processedData_tr(trNum).lFootBS_fr_XYZ(:,2) < 0,1,'first');
                footData_fr_XYZ = sessionData.processedData_tr(trNum).lFootBS_fr_XYZ;
                
            else
                crossFr = find(sessionData.processedData_tr(trNum).rFootBS_fr_XYZ(:,2) < 0,1,'first');
                footData_fr_XYZ = sessionData.processedData_tr(trNum).rFootBS_fr_XYZ;
            end
            
            if( ~isempty(crossFr) )
                
                if( cIdx  == 1 )
                    %xVal = sessionData.expInfo.obsHeightRatios((ttypeNum - 3));
                    plotColor = 'r';
                else
                    %xVal = sessionData.expInfo.obsHeightRatios((ttypeNum));
                    plotColor = 'b';
                end
                
                
                plot(footData_fr_XYZ(:,2),footData_fr_XYZ(:,3),plotColor)
        
                paddedFrNums = [1:size(footData_fr_XYZ,1)] + ceil(padLength/2) - crossFr;
                leadFoot_tr_fr_XYZ(trIdx,paddedFrNums,:) = footData_fr_XYZ;
                
            end
            
        end
                
        
   
        %%
        
        %fprintf('%s \n',mat2str(trOfType_tIdx))
        
        
    end
end

vline(0,'k',2,':')