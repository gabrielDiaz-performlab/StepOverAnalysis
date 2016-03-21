function plotScatter = plotScatter (figNum,dataX_tr, xLabel, dataY_tr, yLabel, axisIn)

global processedDataFileString;

loadParameters

impData = load( processedDataFileString,'elasticityList','elasticity_tr');

elasticityList = impData.elasticityList;
elasticity_tr = impData.elasticity_tr;

figure(figNum)
clf
hold on    
xlabel(xLabel)
ylabel(yLabel)

axis square equal

if( nargin>5 && numel(axisIn) == 2 )
    axis([axisIn axisIn])
elseif( nargin>5 && numel(axisIn) == 4 )
    axis([axisIn])
end



line([0 5],[0 5],'LineStyle',':','Color','k')

dataXTemp_tr = removeOutliers(dataX_tr,2.5);
dataYTemp_tr = removeOutliers(dataY_tr,2.5);

idx = find(~isnan(dataXTemp_tr));
idx = intersect( idx, find(~isnan(dataYTemp_tr)));
    
temp = corrcoef( dataXTemp_tr(idx),dataYTemp_tr(idx));
fprintf('\n**Corr %s x %s:**\n',xLabel,yLabel);
fprintf('- For all: %1.2f\n',temp(1,2));
    
for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(dataXTemp_tr)));
    idx = intersect( idx, find(~isnan(dataYTemp_tr)));
    
    temp = corrcoef( dataXTemp_tr(idx),dataYTemp_tr(idx));
    
    fprintf('for e%i: %1.2f \n',eIdx,temp(1,2));
    scatter( dataXTemp_tr(idx),dataYTemp_tr(idx),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)

end




