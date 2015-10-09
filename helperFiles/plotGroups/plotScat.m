
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hand Height Vs Ball height Scatter

figure(1011)
clf
hold on    
xlabel('Final ball height')
ylabel('Hand height at bounce')

axis square equal
axis([.5 2.5 .5 2.5])

line([0 5],[0 5],'LineStyle',':','Color','k')

for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    %idx = intersect( idx, find(~isnan(fix2BallMinDegs_tr)));
    temp = corrcoef( ballHeightAtArrival_tr(idx),handHeightAtBounce_tr(idx)) ;
    sprintf('Correlation between gaze error and hand error for e%i: %f',eIdx,temp(1,2));
    scatter( ballHeightAtArrival_tr(idx),handHeightAtBounce_tr(idx)  ,80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Scatter - fix to ball distance

figure(1003)
clf
hold on    
xlabel('minimum fix-to-ball  distance')
ylabel('minimum hand-to-ball  distance')

fix2BallMinDegsTEMP_tr = removeOutliers(fix2BallMinDegs_tr,2.5);
ballHeightAtArrivalTEMP_tr = removeOutliers(ballHeightAtArrival_tr,2.5);
handHeightAtBounceTEMP_tr = removeOutliers(handHeightAtBounce_tr,2.5);

for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(fix2BallMinDegs_tr)));
    temp = corrcoef( abs(fix2BallMinDegs_tr(idx)), abs(ballHeightAtArrivalTEMP_tr (idx)-handHeightAtBounceTEMP_tr(idx)));
    sprintf('Correlation between gaze error and hand error for e%i: %f',eIdx,temp(1,2));
    scatter( abs(fix2BallMinDegsTEMP_tr(idx)),abs(ballHeightAtArrivalTEMP_tr (idx)-handHeightAtBounceTEMP_tr(idx)),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Scatter - gaze height vs hand height

figure(1005)
clf
hold on    
xlabel('fixation height at bounce')
ylabel('hand height')
xlim([-35 -15])
gazePitchDuringFixTEMP_tr= removeOutliers(gazePitchDuringFix_tr,2.5);
handHeightAtBounceTEMP_tr = removeOutliers(handHeightAtBounce_tr,2.5);

idx = find(~isnan(gazePitchDuringFixTEMP_tr));
idx = intersect( idx, find(~isnan(handHeightAtBounceTEMP_tr)));
    
temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx));
display(sprintf('Correlation between fix elevation and hand height at bounce for all trials: %f',temp(1,2)));
    
for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(gazePitchDuringFixTEMP_tr)));
    idx = intersect( idx, find(~isnan(handHeightAtBounceTEMP_tr)));
    
    temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx));
    
    display(sprintf('Correlation between fix elevation and hand height at bounce e%i: %f',eIdx,temp(1,2)));
    scatter( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)

end