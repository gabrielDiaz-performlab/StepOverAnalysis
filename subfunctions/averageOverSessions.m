

clear all
close all

loadParameters

sessionFileList = [1 2 3 4 5];

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

%% For each fieldname, measure between subject error

fieldNames_fIdx = fieldnames(betweenSubStats);
showIndividualTrials = 0;

betweenSubStats.expInfo.obsHeightRatios = sessionData.expInfo.obsHeightRatios;
betweenSubStats.expInfo.numConditions = sessionData.expInfo.numConditions;
betweenSubStats.expInfo.numObsHeights = sessionData.expInfo.numObsHeights;
    
plotGroupAvgs(betweenSubStats,showIndividualTrials)

% for fIdx = 1:numel(fieldNames_fIdx)
%     fieldName = fieldNames_fIdx{fIdx};
%     if( ~strcmp(fieldName,'expInfo') )
%         plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials)
%         ylabel(fieldName)
%     end
% end
