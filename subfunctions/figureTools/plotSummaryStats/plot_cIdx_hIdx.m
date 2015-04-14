function figH  = plot_cIdx_hIdx(sessionData,varString,showIndividualTrials) %,xLabelStr,yLabelStr) 

%%  Plot data

loadParameters

%%
figH = figure( sum(double( varString )) );
clf
hold on


evalStr1 = ['summaryStruct = sessionData.summaryStats.' lower(varString(1)) varString(2:end) ';' ];
eval(evalStr1)

xData = sessionData.expInfo.obsHeightRatios;

meanYData_cIdx_hIdx = summaryStruct.mean_cIdx_hIdx;
stdYData_cIdx_hIdx = summaryStruct.std_cIdx_hIdx;
values_cIdx_hIdx = summaryStruct.values_cIdx_hIdx;

l1 = errorbar( xData, meanYData_cIdx_hIdx(1,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(1),'Color',lineColor_cond(1),'Marker','o','MarkerFaceColor',lineColor_cond(1),'MarkerSize',10,'MarkerEdgeColor','k');
l2 = errorbar( xData, meanYData_cIdx_hIdx(2,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(2),'Color',lineColor_cond(2),'Marker','o','MarkerFaceColor',lineColor_cond(2),'MarkerSize',10,'MarkerEdgeColor','k');

%% Plot Scatterplot xdata
if (showIndividualTrials )
    
    numConditions = sessionData.expInfo.numConditions;
    numObsHeights = sessionData.expInfo.numObsHeights;
    allScatterData  = [];
    
    for cIdx = 1:numConditions
        for hIdx = 1:numObsHeights
            
            scatH = scatter(repmat(xData(hIdx),1,numel(values_cIdx_hIdx{cIdx,hIdx})),values_cIdx_hIdx{cIdx,hIdx},15,lineColor_cond(cIdx),'filled','MarkerFaceColor',lineColor_cond(cIdx));
            allScatterData = [allScatterData values_cIdx_hIdx{cIdx,hIdx}];
            
            if( cIdx == 1)
                scatHX = scatH.XData;
                scatH.XData = scatHX + .03 * figBufferPro * range(sessionData.expInfo.obsHeightRatios);
            else
                scatHX = scatH.XData;
                scatH.XData = scatHX -.03 * figBufferPro * range(sessionData.expInfo.obsHeightRatios);
            end
            
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

