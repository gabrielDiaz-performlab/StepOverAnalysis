% Gabriel Diaz 4/15
% cNp = Calculate and plot
% This function automates the averaging and plotting of a variable by 
% condition and obstacle height.
% Averaging is computed in subfunction: calcMean_cIdx_hIdx
% Plotting is performed in subfunction: plot_cIdx_hIdx

function [sessionData, figH] = cNp_cIdx_hIdx(sessionData,varString,removeOutliersBool,showIndividualTrials)

%% Group trials by condition and obs height and take the average

% The third variable is a bool that enables the removal of outliers
if( removeOutliersBool == 1)
    sessionData = calcMean_cIdx_hIdx(sessionData,varString,removeOutliersBool);
else
    % By default, leave outliers in.
    sessionData = calcMean_cIdx_hIdx(sessionData,varString,0);
end

xData = sessionData.expInfo.obsHeightRatios;

%%

evalStr1 = ['summaryStruct = sessionData.summaryStats.' lower(varString(1)) varString(2:end) ';' ];
eval(evalStr1);

%%
% VARSTRING IS USED TO CREATE A UNIQUE FIGURE NUMBER
figH = plot_cIdx_hIdx(sessionData,varString,showIndividualTrials);


