function [figH] = plotAvgTraj_CxH(sessionData)

xLimVals = [-3.5 1];

figH1 = figure(1010);
hold on
cla
xlabel('foot distance (m)')
ylabel('foot height (m)')
set(1010,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
title({'lead foot position','for 1 obstacle height'})
xlim(xLimVals)

figH2 = figure(1011);
hold on
cla
xlabel('foot distance (m)')
ylabel('foot height (m)')
set(1011,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
title({'variation in lead foot position','for 1 obstacle height'})
xlim(xLimVals)
ylim([0 0.2])

figH2 = figure(1012);
hold on
cla
xlabel('foot distance (m)')
ylabel('foot height (m)')
set(1012,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
xlim(xLimVals)


% Here, we take a few steps that allow us to normalize over frames
% temporally aligned with arrival at the obstacle

% pre-initialize a matrix of NaNs that is larger than the possible trial
% duration
padLength = round(sessionData.expInfo.meanTrialDuration / sessionData.expInfo.meanFrameDur)*2;
%leadFoot_tr_fr_XYZ = nan(sessionData.expInfo.numTrials,padLength,3);


for hIdx = 1:3;
    for cIdx = 1:1
        
        ttypeNum = hIdx + ((cIdx-1)*3);
        
        % Get indices for the trial type specified by hIdx and cIdx
        trOfType_tIdx = find( [sessionData.expInfo.trialTypes_Idx] == ttypeNum );
            
        % Get indices for trials to be exlcuded
        excludeTrials_tIdx = find( [sessionData.expInfo.excludeTrial] == 1 );
        
        % Set diff
        trOfType_tIdx = setdiff(trOfType_tIdx,excludeTrials_tIdx);
%         frameTime_tr_fr = nan(numel(trOfType_tIdx),padLength);
%         TTC_tr_fr = nan(numel(trOfType_tIdx),padLength);
        leadFoot_tr_fr_XYZ = nan(numel(trOfType_tIdx),padLength,3);
        
        for trIdx = 1:numel(trOfType_tIdx)
            
            trNum = trOfType_tIdx(trIdx);
            
            if( strcmp( sessionData.dependentMeasures_tr(trNum).firstCrossingFoot, 'Left' ) )
                Foot_xyz = sessionData.processedData_tr(trNum).lFoot.rbPos_mFr_xyz;
                Obs_xyz = repmat(sessionData.processedData_tr(trNum).obs.pos_xyz,[length(Foot_xyz) 1]);
                obsCentered = Obs_xyz(2) - Foot_xyz(2);
                crossFr = find( obsCentered < 0,1,'first');
                footData_fr_XYZ = Obs_xyz - Foot_xyz;
                
            else
                Foot_xyz = sessionData.processedData_tr(trNum).rFoot.rbPos_mFr_xyz;
                Obs_xyz = repmat(sessionData.processedData_tr(trNum).obs.pos_xyz,[length(Foot_xyz) 1]);
                obsCentered = Obs_xyz(2) - Foot_xyz(2);
                crossFr = find( obsCentered < 0,1,'first');
                footData_fr_XYZ = Obs_xyz - Foot_xyz ;          
            end
            % footdata moves from positive to negative
            
            if( ~isempty(crossFr) )
                
                paddedFrNums = 1:size(footData_fr_XYZ,1) + ceil(padLength/2) - crossFr;
                leadFoot_tr_fr_XYZ(trIdx,paddedFrNums,:) = footData_fr_XYZ;
                
%                 frameTime_tr_fr(trNum,paddedFrNums) = sessionData.rawData_tr(trNum).frameTime_fr - sessionData.rawData_tr(trNum).frameTime_fr(1);
%                 crossTime = sessionData.rawData_tr(trNum).frameTime_fr(crossFr) - sessionData.rawData_tr(trNum).frameTime_fr(1);
%                 % Normalize time by crossing time.
%                 TTC_fr = sessionData.rawData_tr(trNum).frameTime_fr - sessionData.rawData_tr(trNum).frameTime_fr(1) - crossTime;
                
                % interpolate data
                % After normalization, subject moves from positive Y to - Y 
                interpYData_tr_fr(trIdx,:) = [-4:0.01:1];
                
                %%
                interpData_tr_fr_XZ(trIdx,:,:) = interp1(footData_fr_XYZ(:,2),footData_fr_XYZ(:,[1 3]),interpYData_tr_fr(trIdx,:),'pchip',NaN);
                
            end
            
            if( cIdx  == 1 && hIdx == 1)
                plotColor = 'r';
                
                figure(1012)
                hold on
                title('Foot height')
                plot(interpYData_tr_fr(trIdx,:), interpData_tr_fr_XZ(trIdx,:,2),plotColor,'LineWidth',2)
                vline(0)
            end

        end
                
        % Average over trials of this type.
        leadFootMean_fr_X = nanmean(interpYData_tr_fr,1);
        leadFootMean_fr_YZ = squeeze(nanmean(interpData_tr_fr_XZ,1));
        leadFootStd_fr_YZ = squeeze(nanstd(interpData_tr_fr_XZ,1));
        
        if( cIdx  == 1 )
            plotColor = 'r';
        else
            plotColor = 'b';
        end
        
        %%
        X = leadFootMean_fr_X;
        Y = leadFootMean_fr_YZ(:,2);

        %%
        
        %boundedline(X,Y,B,plotColor,'orientation', 'vert','alpha')
        figure(1010)
        hold on
        title('Foot height')
        plot(X,Y,plotColor,'LineWidth',2)
        vline(0)
        
        %%     
  
        figure(1011)
        hold on
        ylim([0, .3])
        title('STD in height')
        plot(X,leadFootStd_fr_YZ(:,2),plotColor,'LineWidth',2)
        vline(0)
        
    end
end