function sessionData = mean_cIdx_hIdx(sessionData,varNameStr,plotBool)

%% How to average over data and plot
% Fixme:  create generalized function that calculate the mean/std
% for any input variable of the form data_tr.
if( nargin < 2)
    plotBool = 0;
end



if(sum(strcmp(fieldnames(sessionData.dependentMeasures_tr),varNameStr))==0)
    fprintf('mean_cIdx_hIdx:  No such data in .dependentMeasures_tr  \n')
    return
else
    eval( [ 'data_tr = [sessionData.dependentMeasures_tr.' varNameStr '];']);
end

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

eval(['sessionData.summaryStats.mean' upper(varNameStr(1)) varNameStr(2:end) '_cIdx_hIdx = dataMean_cIdx_hIdx;' ])
eval(['sessionData.summaryStats.std' upper(varNameStr(1)) varNameStr(2:end) '_cIdx_hIdx = dataStd_cIdx_hIdx;' ])

%%


% %%  Plot data
% % Fixme:  create generalized function that plot the mean/std
% % for any input variable of the form data_tr.
% 
% figure(1);
% clf
% hold on
% 
% xlabel('Obs Height / Leg Length')
% ylabel('Toe height at stepover (m)')
% 
% obsHeightRatios = sessionData.expInfo.obsHeightRatios;
% 
% l1 = errorbar( obsHeightRatios, meanToeClearance_cIdx_hIdx(1,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2);
% l2 = errorbar( obsHeightRatios, meanToeClearance_cIdx_hIdx(2,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2);
% 
% %l1 = errorbar( sessionData.summaryStats.meanToeClearance_cIdx_hIdx(1,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2)
% %l2 = errorbar( sessionData.summaryStats.meanToeClearance_cIdx_hIdx(2,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(2,:)','LineWidth',2)
% 
% l2X = l2.XData;
% l2.XData = l2X-.005;
% 
% l1X = l1.XData;
% l1.XData = l1X+.005;
% 
% set(gca,'xtick',obsHeightRatios);
% xlim([obsHeightRatios(1)-.02 obsHeightRatios(end)+.02]);
% ylim([0 .7]);


