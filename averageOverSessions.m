clear all
close all

loadParameters


sessionFileList = 1:7;
removeOutliersBool = 1;
showIndividualTrialsBool = 0;
    
if numel(sessionFileList)<2 error 'sessionFileList cannot be a single value'; end
%% Build struct sessionData_sIdx that includes summary stats for each session
for sIdx = 1:numel(sessionFileList )
    
    sessionNumber = sessionFileList(sIdx);
    %dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})
    %sessionData = loadSession(sessionNumber);
    %sessionData  = calculateSSandPlot(sessionData,removeOutliersBool,showIndividualTrialsBool )
    %save([ sessionFileDir dataFileList{sessionNumber} '.mat'] , 'sessionData');
    
    sessionData = processSession(sessionNumber);
        
    close all
    
    %% Generate or open session file struct
    sessionData_sIdx(sIdx) = sessionData;
    
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
        
        sessionAvgStruct.meanDiffBtCond_sIdx_hIdx(sIdx,:) = eval(['sessionData_sIdx(sIdx).summaryStats.' fieldName '.meanDiffBtCond_hIdx' ]);
        
    end
    
    sessionAvgStruct.mean_cIdx_hIdx = squeeze(mean(withinAvgn_sIdx_cIdx_hIdx,1));
    sessionAvgStruct.stdErr_cIdx_hIdx = squeeze(std(withinAvgn_sIdx_cIdx_hIdx,1) / sqrt(numel(sessionFileList )));
    
    sessionAvgStruct.meanDiffBtCond_hIdx = squeeze(mean(sessionAvgStruct.meanDiffBtCond_sIdx_hIdx,1));
    sessionAvgStruct.stdErrDiffBtCond_hIdx = squeeze(std(sessionAvgStruct.meanDiffBtCond_sIdx_hIdx,1) / sqrt(numel(sessionFileList )));
    
    eval([  'betweenSubStats.' fieldName '=sessionAvgStruct;'])
end

betweenSubStats

%% Add some expinfo necessary for plotting

betweenSubStats.expInfo.obsHeightRatios = sessionData.expInfo.obsHeightRatios;
betweenSubStats.expInfo.numConditions = sessionData.expInfo.numConditions;
betweenSubStats.expInfo.numObsHeights = sessionData.expInfo.numObsHeights;

%% Plot and save DM avgs
showIndividualSubData = 0;
betweenGroupsFigStruct = plotGroupAvgs(betweenSubStats,showIndividualSubData);
saveGroupAverageFigs(betweenGroupsFigStruct ,sessionFileList)

close all

%% Plot and save DM diff bt cond avgs
showIndividualSubData = 0;
betweenGroupsFigStruct = plotGroupAvgDiffs(betweenSubStats,showIndividualSubData);
saveGroupAverageFigs(betweenGroupsFigStruct ,sessionFileList)
 
close all

%% Save stats out to .txt for spss analysis

fieldNames_fIdx = fieldnames(sessionData_sIdx(1).summaryStats);

for fIdx = 1:numel(fieldNames_fIdx)
    
    fieldName = fieldNames_fIdx{fIdx};
    if( ~ strcmp('expInfo',fieldName ))
        
        spssFPath = [spssFileDir 'spss-' fieldName '.txt'];
        
        dlmwrite(spssFPath,eval(['betweenSubStats.' fieldName '.values_sIdx_ttIdx']),' ')
    end
    
end
