function sessionData = mean_cIdx_hIdx(sessionData,data_tr,varOutStr)

%% How to average over data and plot
% Fixme:  create generalized function that calculate the mean/std
% for any input variable of the form data_tr.


%%
% condition (real vs virtual) vs height (s, m, tall).
% Fixme: must average over trial types
numConditions = sessionData.expInfo.numConditions;
numObsHeights = sessionData.expInfo.numObsHeights;

dataMean_cIdx_hIdx = nan(numConditions ,numObsHeights);
dataStd_cIdx_hIdx = nan(numConditions ,numObsHeights);

for cIdx = 1:numConditions
    for hIdx = 1:numObsHeights
        
        trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == hIdx * cIdx );
            
            if( sum( isnan([data_tr(trOfType_tIdx)]) ) > 0 )
               print( 'Found a NAN value!' )
               return
            end
            
            dataMean_cIdx_hIdx(cIdx,hIdx) = mean([data_tr(trOfType_tIdx)]);
            dataStd_cIdx_hIdx(cIdx,hIdx) = std([data_tr(trOfType_tIdx)]);

    end
end


%%

eval(['sessionData.summaryStats.mean' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataMean_cIdx_hIdx;' ])
eval(['sessionData.summaryStats.std' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataStd_cIdx_hIdx;' ])

%eval(['sessionData.summaryStats.mean' upper(varNameStr(1)) varNameStr(2:end) '_cIdx_hIdx = dataMean_cIdx_hIdx;' ])
%eval(['sessionData.summaryStats.std' upper(varNameStr(1)) varNameStr(2:end) '_cIdx_hIdx = dataStd_cIdx_hIdx;' ])


