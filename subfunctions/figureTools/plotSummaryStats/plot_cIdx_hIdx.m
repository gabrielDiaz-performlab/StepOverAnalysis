function figH  = plot_cIdx_hIdx(xData,meanYData_cIdx_hIdx,stdYData_cIdx_hIdx,varString) %,xLabelStr,yLabelStr) 

%%  Plot data

loadParameters

% if( isempty(inputname(2)) )
%     fprintf('Please assign your Y data means (argIn #2) to a variable with a UNIQUE name before passing into plot_cIdx_hIdx \n')
%     fprintf('This variable name is used to generate a unique number specific to this variable.\n')
%     figH = NaN;
%     return
% end

%%
figH = figure( sum(double( varString )) );
clf
hold on

% % Make sure caps aren't an issue
% yVarStr = [upper(yVarStr(1)) yVarStr(2:end)];
% meanVarString = ['mean' yVarStr '_cIdx_hIdx'];
% stdVarString = ['std' yVarStr '_cIdx_hIdx'];
% 
% if(sum(strcmp(fieldnames(sessionData.summaryStats),meanVarString ))==0)
%     fprintf('plot:  No such data in .plot  \n')
%     %return
% else
%     eval( [ 'meanYData_cIdx_hIdx = [sessionData.summaryStats.' meanVarString '];']);
%     eval( [ 'stdYData_cIdx_hIdx = [sessionData.summaryStats.' stdVarString '];']);
% end


l1 = errorbar( xData, meanYData_cIdx_hIdx(1,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(1),'Color',lineColor_cond(1),'Marker','o','MarkerFaceColor',lineColor_cond(1),'MarkerSize',10,'MarkerEdgeColor','k');
l2 = errorbar( xData, meanYData_cIdx_hIdx(2,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',3,'LineStyle',lineStyle_cond(2),'Color',lineColor_cond(2),'Marker','o','MarkerFaceColor',lineColor_cond(2),'MarkerSize',10,'MarkerEdgeColor','k');



allXData = [ l1.XData l2.XData ];

l2X = l2.XData;
l2.XData = l2X - .1 * figBufferPro * range(allXData);

l1X = l1.XData;
l1.XData = l1X+ .1 * figBufferPro *range(allXData);

set(gca,'xtick',xData);
xlim([ min(allXData)-figBufferPro*range(allXData) max(allXData)+figBufferPro*range(allXData) ]);

allYData = [ l1.YData l2.YData ];
allYLData = [ l1.YData-l1.LData l2.YData-l2.LData]; % lower part of error bar
allYUData = [ l1.YData+l1.UData l2.YData+l2.UData ]; % upper parts of error bar

ylim([ min(allYLData)-figBufferPro*range(allYData) max(allYUData)+ figBufferPro*range(allYData) ]);

xlabel({'obstacle heights', '(in units of leg length)'})

% xlabel(xLabelStr)
% 
% if(nargin < 4)
%     ylabel(meanVarString)
% else
%     ylabel(yLabelStr)
% end


