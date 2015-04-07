% Gabriel Diaz 4/15
% cNp = Calculate and plot
% This function automates the averaging and plotting of a variable by 
% condition and obstacle height.
% Averaging is computed in subfunction:  calcMean_cIdx_hIdx
% Plotting is performed in subfunction: plot_cIdx_hIdx

function [sessionData figH] = cNp_cIdx_hIdx(sessionData,varString)

dm = sessionData.dependentMeasures_tr;


data_tr = eval( [ '[' sprintf('dm.%s',varString) ']' ]);


%% Group trials by condition and obs height and take the average
%%

sessionData = calcMean_cIdx_hIdx(sessionData,data_tr,varString);
xData = sessionData.expInfo.obsHeightRatios;

evalStr1 = ['dataMean_cIdx_hIdx = sessionData.summaryStats.mean' upper(varString(1)) varString(2:end) '_cIdx_hIdx;' ];
evalStr2 = ['dataStd_cIdx_hIdx = sessionData.summaryStats.std' upper(varString(1)) varString(2:end) '_cIdx_hIdx;' ]

eval(evalStr1);
eval(evalStr2);

% VARSTRING IS USED TO CREATE A UNIQUE FIGURE NUMBER
figH = plot_cIdx_hIdx(xData,dataMean_cIdx_hIdx,dataStd_cIdx_hIdx,varString)


