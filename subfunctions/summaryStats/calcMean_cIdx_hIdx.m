function sessionData = calcMean_cIdx_hIdx(sessionData,data_tr,varOutStr,removeOutliersBool)

%% How to average over data and plot
% Fixme:  create generalized function that calculate the mean/std
% for any input variable of the form data_tr.

loadParameters
%%
% condition (real vs virtual) vs height (s, m, tall).
% Fixme: must average over trial types
numConditions = sessionData.expInfo.numConditions;
numObsHeights = sessionData.expInfo.numObsHeights;

dataMean_cIdx_hIdx = nan(numConditions ,numObsHeights);
dataStd_cIdx_hIdx = nan(numConditions ,numObsHeights);


if( nargin > 3 && removeOutliersBool == 1 )
    fprintf('dataStd_cIdx_hIdx: Removing outliers \n');
end

for cIdx = 1:numConditions
    for hIdx = 1:numObsHeights
        
        trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == hIdx + ((cIdx-1)*3)  );
            
            if( sum( isnan([data_tr(trOfType_tIdx)]) ) > 0 )
               fprintf( 'Found a NAN value!\n' )
            end
            
            yData_tr = data_tr(trOfType_tIdx);
            
            if( nargin > 3 && removeOutliersBool == 1)
                yData_tr = removeOutliers(yData_tr,outlierThreshold);
            end
            
            dataMean_cIdx_hIdx(cIdx,hIdx) = nanmean([yData_tr ]);
            dataStd_cIdx_hIdx(cIdx,hIdx) = nanstd(yData_tr);
            
%             if( cIdx == 2 && hIdx == 1)
%                 keyboard
%             end
    end
end


%%
evalStr1 = ['sessionData.summaryStats.mean' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataMean_cIdx_hIdx;' ];
evalStr2 = ['sessionData.summaryStats.std' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataStd_cIdx_hIdx;' ];

try
    eval(evalStr1);
catch
    
    fprintf('mean_cIdx:hIdx: Error evaluating: %s',evalStr1)
end

try
    eval(evalStr2);

catch
    
    fprintf('mean_cIdx:hIdx: Error evaluating: %s',evalStr2)
end

%eval(['sessionData.summaryStats.mean' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataMean_cIdx_hIdx;' ])
    %eval(['sessionData.summaryStats.std' upper(varOutStr(1)) varOutStr(2:end) '_cIdx_hIdx = dataStd_cIdx_hIdx;' ])


