function figH  = plot_cIdx_hIdx(xData,meanYData_cIdx_hIdx,stdYData_cIdx_hIdx,xLabelStr,yLabelStr) 

%%  Plot data
% Fixme:  create generalized function that plot the mean/std
% for any input variable of the form data_tr.
%yVarStr = 'LeadToeZASO';
%xData = sessionData.expInfo.obsHeightRatios;

%%

figH = figure( sum(double( yLabelStr )) );
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

l1 = errorbar( xData, meanYData_cIdx_hIdx(1,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',2);
l2 = errorbar( xData, meanYData_cIdx_hIdx(2,:)',stdYData_cIdx_hIdx(1,:)','LineWidth',2);

buff = 0.1;

allXData = [ l1.XData l2.XData ];

l2X = l2.XData;
l2.XData = l2X-0.25*buff*range(allXData);

l1X = l1.XData;
l1.XData = l1X+0.25*buff*range(allXData);

set(gca,'xtick',xData);
xlim([ min(allXData)-buff*range(allXData) max(allXData)+buff*range(allXData) ]);

allYData = [ l1.YData l2.YData ];
allYLData = [ l1.YData-l1.LData l2.YData-l2.LData]; % lower part of error bar
allYUData = [ l1.YData+l1.UData l2.YData+l2.UData ]; % upper parts of error bar

ylim([ min(allYLData)-buff*range(allYData) max(allYUData)+ buff*range(allYData) ]);

xlabel(xLabelStr)

if(nargin < 4)
    ylabel(meanVarString)
else
    ylabel(yLabelStr)
end


