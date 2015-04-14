function sessionData = calcMean_cIdx_hIdx(sessionData,varString,removeOutliersBool)

%% How to average over data and plot
% Fixme:  create generalized function that calculate the mean/std
% for any input variable of the form data_tr.

loadParameters

%%

dm = sessionData.dependentMeasures_tr;
data_tr = eval( [ '[' sprintf('dm.%s',varString) ']' ]);

%%
% condition (real vs virtual) vs height (s, m, tall).
% Fixme: must average over trial types

numConditions = sessionData.expInfo.numConditions;
numObsHeights = sessionData.expInfo.numObsHeights;

dataMean_cIdx_hIdx = nan(numConditions ,numObsHeights);
dataStd_cIdx_hIdx = nan(numConditions ,numObsHeights);

% if( nargin > 2 && removeOutliersBool == 1 )
%     fprintf('dataStd_cIdx_hIdx: Removing outliers \n');
% end

for cIdx = 1:numConditions
    for hIdx = 1:numObsHeights
        
        
        %% Exclude trials marked for exlusion in sessionData.rawData_tr.excludeTrial
        
        % Get indices for the trial type specified by hIdx and cIdx
        trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == hIdx + ((cIdx-1)*3)  );
        % Get indices for trials to be exlcuded
        excludeTrials_tIdx = find( [sessionData.rawData_tr.excludeTrial] == 1 );
        % Set diff
        trOfType_tIdx = setdiff(trOfType_tIdx,excludeTrials_tIdx);
        
        %%
            if( sum( isnan([data_tr(trOfType_tIdx)]) ) > 0 )
               fprintf( 'Found a NAN value!\n' )
            end
            
            yData_tr = data_tr(trOfType_tIdx);
            
            outlierIdx = [];
            
            if( nargin > 2 && removeOutliersBool == 1)
                fprintf('dataStd_cIdx_hIdx: Removing outliers \n')
                [yData_tr outlierVals outlierIdx] = removeOutliers(yData_tr,outlierThreshold);
                outlierIdx = trOfType_tIdx(outlierIdx);
                
                outlierVals 
            else
                outlierVals = [];
                outlierIdx = [];
            end
            
            dataMean_cIdx_hIdx(cIdx,hIdx) = nanmean([yData_tr]);
            dataStd_cIdx_hIdx(cIdx,hIdx) = nanstd(yData_tr);
            outlierIdx_cIdx_hIdx(cIdx,hIdx) = {outlierIdx};
            outlierValues_cIdx_hIdx(cIdx,hIdx) = {outlierVals};
            numAveraged_cIdx_hIdx(cIdx,hIdx) = numel(yData_tr);
            values_cIdx_hIdx(cIdx,hIdx) = {yData_tr};


    end
end

%%
evalStr1 = ['sessionData.summaryStats.' lower(varString(1)) varString(2:end) ' = struct;' ];

eval(evalStr1);

summaryStruct = struct;
summaryStruct.values_cIdx_hIdx = values_cIdx_hIdx;
summaryStruct.mean_cIdx_hIdx = dataMean_cIdx_hIdx;
summaryStruct.std_cIdx_hIdx = dataStd_cIdx_hIdx;
summaryStruct.outlierIdx_cIdx_hIdx = outlierIdx_cIdx_hIdx;
summaryStruct.outlierValues_cIdx_hIdx = outlierValues_cIdx_hIdx;
summaryStruct.numAveraged_cIdx_hIdx = numAveraged_cIdx_hIdx;

evalStr2 = ['sessionData.summaryStats.' lower(varString(1)) varString(2:end) '= summaryStruct;' ];
eval(evalStr2);


