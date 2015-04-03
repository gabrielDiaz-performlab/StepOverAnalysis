function figH  = plot_cIdx_hIdx_REP(sessionData,ydata_tr,xLabelStr,yLabelStr)

%%  Plot data
% Fixme:  create generalized function that plot the mean/std
% for any input variable of the form data_tr.
%yVarStr = 'LeadToeZASO';
%xData = sessionData.expInfo.obsHeightRatios;

%%
loadParameters

figH = figure( sum(double( yLabelStr )) );
clf
hold on


for cIdx = 1:numConditions
    for hIdx = 1:numObsHeights
        
        trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == hIdx + ((cIdx-1)*3) );
        
        if( sum( isnan([ydata_tr(trOfType_tIdx)]) ) > 0 )
            fprintf( 'Found a NAN value!\n' )
        end
        
        plot(ydata_tr(trOfType_tIdx),'LineStyle',lineStyle_cond(cIdx),'Color',lineColor_height(hIdx),'LineWidth',2);
        
    end
end



