

clear all
close all

loadParameters


sessionFileList = 1:3;

if numel(sessionFileList)<2 error 'sessionFileList cannot be a single value'; end
%% Build struct sessionData_sIdx that includes summary stats for each session
for sIdx = 1:numel(sessionFileList )
    
    sessionNumber = sessionFileList(sIdx);
    dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})
    sessionData = loadSession(sessionNumber);
    
    removeOutliersBool = 1;
    showIndividualTrialsBool = 0;
    
    sessionData  = calculateSSandPlot(sessionData,removeOutliersBool,showIndividualTrialsBool )
    save([ sessionFileDir dataFileList{sessionNumber} '.mat'] , 'sessionData');
    
    close all
    
    %% Generate or open session file struct
    sessionData_sIdx(sIdx) = sessionData;
    
end
keyboard

%%
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

%%
%% For each fieldname, measure between subject error
fieldNames_fIdx = fieldnames(sessionData_sIdx(1).summaryStats);

betweenSubStats = struct;

for fIdx = 1:numel(fieldNames_fIdx)
    
    fieldName = fieldNames_fIdx{fIdx};
    %fprintf('Calculating stats for: %s\n',fieldName)
    withinAvgn_sIdx_cIdx_hIdx = [];
    
    sessionAvgStruct = struct;
    
    for sIdx = 1:numel(sessionFileList )
        
        withinAvgn_sIdx_cIdx_hIdx(sIdx,:,:) = eval(['sessionData_sIdx(sIdx).summaryStats.' fieldName '.mean_cIdx_hIdx' ]);
        sessionAvgStruct.values_sIdx_cIdx_hIdx(sIdx,:,:) = squeeze(eval(['sessionData_sIdx(sIdx).summaryStats.' fieldName '.mean_cIdx_hIdx' ]));
        
        sessionAvgStruct.values_sIdx_ttIdx(sIdx,:) = [ squeeze(sessionAvgStruct.values_sIdx_cIdx_hIdx(sIdx,1,:))' ...
            squeeze(sessionAvgStruct.values_sIdx_cIdx_hIdx(sIdx,2,:))'];
        
    end
    
    sessionAvgStruct.mean_cIdx_hIdx = squeeze(mean(withinAvgn_sIdx_cIdx_hIdx,1));
    sessionAvgStruct.stdErr_cIdx_hIdx = squeeze(std(withinAvgn_sIdx_cIdx_hIdx,1) / sqrt(numel(sessionFileList )));
    
    eval([  'betweenSubStats.' fieldName '=sessionAvgStruct;'])
end

betweenSubStats

%% Add some expinfo necessary for plotting

betweenSubStats.expInfo.obsHeightRatios = sessionData.expInfo.obsHeightRatios;
betweenSubStats.expInfo.numConditions = sessionData.expInfo.numConditions;
betweenSubStats.expInfo.numObsHeights = sessionData.expInfo.numObsHeights;

%% Plot avgs
showIndividualTrials = 0;
betweenGroupsFigStruct = plotGroupAvgs(betweenSubStats,showIndividualTrials);

%% Save figures
saveGroupAverageFigs(betweenGroupsFigStruct ,sessionFileList)

%% Save stats out to .txt for spss analysis

fieldNames_fIdx = fieldnames(sessionData_sIdx(1).summaryStats);

for fIdx = 1:numel(fieldNames_fIdx)
    
    fieldName = fieldNames_fIdx{fIdx};
    if( ~ strcmp('expInfo',fieldName ))
        
        spssFPath = [spssFileDir 'spss-' fieldName '.txt'];
        
        dlmwrite(spssFPath,eval(['betweenSubStats.' fieldName '.values_sIdx_ttIdx']),' ')
    end
    
end
