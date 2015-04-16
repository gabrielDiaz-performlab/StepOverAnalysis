

clear all
close all

loadParameters

sessionFileList = [1 2 3 4];

%% Build struct sessionData_sIdx that includes summary stats for each session
for sIdx = 1:numel(sessionFileList )
    
    sessionNumber = sessionFileList(sIdx);
    dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})
    sessionData = loadSession(sessionNumber);
    
    removeOutliersBool = 1;
    showIndividualTrialsBool = 0;
    
    sessionData  = calculateSSandPlot(sessionData,removeOutliersBool,showIndividualTrialsBool )
    close all
    
    %% Generate or open session file struct
    sessionData_sIdx(sIdx) = sessionData;
    
end

%% For each fieldname, measure between subject error
fieldNames_fIdx = fieldnames(sessionData_sIdx(1).summaryStats);

betweenSubStats = struct;

for fIdx = 1:numel(fieldNames_fIdx)
    
    fieldName = fieldNames_fIdx{fIdx};
    %fprintf('Calculating stats for: %s\n',fieldName)
    withinAvgn_sIdx_cIdx_hIdx = [];
    
    for sIdx = 1:numel(sessionFileList )
        
        withinAvgn_sIdx_cIdx_hIdx(sIdx,:,:) = eval(['sessionData_sIdx(sIdx).summaryStats.' fieldName '.mean_cIdx_hIdx' ]);
        
    end
    
    sessionAvgStruct = struct;
    
    sessionAvgStruct.mean_cIdx_hIdx = squeeze(mean(withinAvgn_sIdx_cIdx_hIdx,1));
    sessionAvgStruct.stdErr_cIdx_hIdx = squeeze(std(withinAvgn_sIdx_cIdx_hIdx,1) / sqrt(numel(sessionFileList )));

    % FIxme:  Store specific values for plotting
%     %allSubData_sIdx_cIdx_hIdx = cell;
%     
%     for sIdx = 1:numel(sessionFileList )    
%         
%         allSubData_sIdx_cIdx_hIdx(sIdx,:,:)  = {[squeeze(withinAvgn_sIdx_cIdx_hIdx(sIdx,:,:)) ]} ;
%     end
%     
%     sessionAvgStruct.values_cIdx_hIdx = {allSubData_sIdx_cIdx_hIdx};
    eval([  'betweenSubStats.' fieldName '=sessionAvgStruct;'])
end

betweenSubStats

%% For each fieldname, measure between subject error

fieldNames_fIdx = fieldnames(betweenSubStats);
showIndividualTrials = 0;

betweenSubStats.expInfo.obsHeightRatios = sessionData.expInfo.obsHeightRatios;
betweenSubStats.expInfo.numConditions = sessionData.expInfo.numConditions;
betweenSubStats.expInfo.numObsHeights = sessionData.expInfo.numObsHeights;
    
for fIdx = 1:numel(fieldNames_fIdx)
    fieldName = fieldNames_fIdx{fIdx};
    plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials)
    ylabel(fieldName)
end
