function figH  = plotGroupAvgDiffs_hIdx(betweenSubStats,varString,showIndividualTrials) %,xLabelStr,yLabelStr) 

%%  Plot data

loadParameters

%%

figH = figure( sum(double( varString ))+1 );
clf
hold on


evalStr1 = ['summaryStruct = betweenSubStats.' lower(varString(1)) varString(2:end) ';' ];
eval(evalStr1)

xData = betweenSubStats.expInfo.obsHeightRatios;

meanYData_hIdx = summaryStruct.meanDiffBtCond_hIdx ;
stdYData_hIdx = summaryStruct.stdErrDiffBtCond_hIdx;
values_sIdx_hIdx = summaryStruct.meanDiffBtCond_sIdx_hIdx ;

l1 = errorbar( xData, meanYData_hIdx,stdYData_hIdx,'LineWidth',3,'LineStyle',lineStyle_cond(1),'Color',lineColor_cond(1),'Marker','o','MarkerFaceColor',lineColor_cond(1),'MarkerSize',10,'MarkerEdgeColor',lineColor_cond(1));
hlineH = hline(0,'k',2,':');
set(gca,'children',flipud(get(gca,'children')));



for hIdx = 1:numel(meanYData_hIdx)
    
    [h,p,ci,stats] = ttest(values_sIdx_hIdx(:,1));
    
    if( h == 1 )
        plot( xData(hIdx), meanYData_hIdx(hIdx),'*k','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',15,'LineWidth',3);
        textString = { sprintf('t(%1.2f) = %1.2f', stats.df, stats.tstat), sprintf('p = %1.2f',p)};
        text(xData(hIdx), meanYData_hIdx(hIdx)+0.15,textString,'FontSmoothing','on','HorizontalAlignment','center') ;
    end
    
end

%% Plot Scatterplot xdata
if (showIndividualTrials )
    
    numConditions = betweenSubStats.expInfo.numConditions;
    numObsHeights = betweenSubStats.expInfo.numObsHeights;
    allScatterData  = [];
    
    for cIdx = 1:numConditions
        for hIdx = 1:numObsHeights
            
            scatH = plot(xData,squeeze(values_sIdx_hIdx),'Color',lineColor_cond(2),'MarkerFaceColor',lineColor_cond(2),'LineWidth',1);
            
        end
    end
    
end

%%
allXData = l1.XData;

set(gca,'xtick',xData);
xlim([ min(allXData)-figBufferPro*range(allXData) max(allXData)+figBufferPro*range(allXData) ]);

xlabel({'obstacle heights', '(in units of leg length)'})


% allScatterData

