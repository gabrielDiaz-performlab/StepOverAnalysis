function figH  = plotGroupAvg_cIdx_hIdx(betweenSubStats,varString,showIndividualTrials) %,xLabelStr,yLabelStr) 

%%  Plot data

loadParameters

%%
figH = figure( sum(double( varString )) );
clf
hold on

evalStr1 = ['summaryStruct = betweenSubStats.' lower(varString(1)) varString(2:end) ';' ];
eval(evalStr1)

xData = betweenSubStats.expInfo.obsHeightRatios;

meanYData_cIdx_hIdx = summaryStruct.mean_cIdx_hIdx;
stdYData_cIdx_hIdx = summaryStruct.stdErr_cIdx_hIdx;
values_sIdx_cIdx_hIdx = summaryStruct.values_sIdx_cIdx_hIdx ;

l1 = errorbar( xData, meanYData_cIdx_hIdx(1,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(1),'Color',lineColor_cond(1),'Marker','o','MarkerFaceColor',lineColor_cond(1),'MarkerSize',10,'MarkerEdgeColor',lineColor_cond(1));
l2 = errorbar( xData, meanYData_cIdx_hIdx(2,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(2),'Color',lineColor_cond(2),'Marker','o','MarkerFaceColor',lineColor_cond(2),'MarkerSize',10,'MarkerEdgeColor',lineColor_cond(2));

%% Plot Scatterplot xdata
if (showIndividualTrials )
    
    numConditions = betweenSubStats.expInfo.numConditions;
    numObsHeights = betweenSubStats.expInfo.numObsHeights;
    allScatterData  = [];
    
    for cIdx = 1:numConditions
        for hIdx = 1:numObsHeights
            
            scatH = plot(xData,squeeze(values_sIdx_cIdx_hIdx(:,cIdx,:)),'Color',lineColor_cond(cIdx),'MarkerFaceColor',lineColor_cond(cIdx),'LineWidth',1);
            
        end
    end
    
end

%%
allXData = [ l1.XData l2.XData ];

l2X = l2.XData;
l2.XData = l2X - .1 * figBufferPro * range(allXData);

l1X = l1.XData;
l1.XData = l1X+ .1 * figBufferPro *range(allXData);

set(gca,'xtick',xData);
xlim([ min(allXData)-figBufferPro*range(allXData) max(allXData)+figBufferPro*range(allXData) ]);

xlabel({'obstacle heights', '(in units of leg length)'})


% allScatterData

