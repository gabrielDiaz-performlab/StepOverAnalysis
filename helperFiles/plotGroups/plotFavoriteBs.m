
focusOnTrIdx = [];

for bIdx = 1:numel(focusOnBlocks)
    focusOnTrIdx = [ focusOnTrIdx trInBlk_Cblk{focusOnBlocks(bIdx)}];
end

%focusOnTrIdx = sort(reshape(trInBlk_Cblk(focusOnBlocks,:),numel(trInBlk_blk(focusOnBlocks,:)),1));

%%

plotHandPos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Caching success

figure(800)
clf
hold on    
xlabel('trial')
ylabel('Ball caught')

for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( focusOnTrIdx, idx)
    plot( smooth(successfulCatch_tr(idx  ),5) ,'Color',colorList(eIdx))
end

%%


figure(1010)
clf
hold on    
xlabel('trial')
ylabel('Hand height at bounce')

for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( focusOnTrIdx, idx)
    plot(smooth(abs(ballHeightAtArrival_tr(idx)-handHeightAtBounce_tr(idx)),3),'Color',colorList(eIdx))
end



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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix elevation at minimum

figure(1041)
hold on
clf

histRange = -3:.5:10;

%%%

subplot(2,1,1)
%xlabel('fix elevation at minimum')
xlabel('fix distance at minimum')
ylabel('number of trials')
hold on

[n,xout] = hist(gca,[fixDist2Bounce_el_cRep{1} fixDist2Bounce_el_cRep{2}],histRange );
h = bar(gca,xout-((eIdx-1)*.25),n,.5);
set(h,'facecolor',colorList(3))
f1 = ezfit(xout,n,'gauss');
showfit(f1, 'fitcolor', colorList(3), 'fitlinewidth', 2);
hold on
    
for eIdx = 1:numel(elasticityList)
    
    
    %[n,xout] = hist(gca,fixPitch_el_cRep{eIdx},histRange );
    [n,xout] = hist(gca,fixDist2Bounce_el_cRep{eIdx},histRange );
    
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
    xlim([min(histRange) max(histRange)])
end

%%

subplot(2,1,2)
xlabel('Ball-to-bounce distance at mean time of minimum')
ylabel('number of trials')
hold on

[n,xout] = hist(gca,[ball2BounceDegsAtMeanMin_el_cRep{1} ball2BounceDegsAtMeanMin_el_cRep{2}],histRange );
h = bar(gca,xout-((eIdx-1)*.25),n,.5);
set(h,'facecolor',colorList(3))
f1 = ezfit(xout,n,'gauss');
showfit(f1, 'fitcolor', colorList(3), 'fitlinewidth', 2);
hold on
%%
for eIdx = 1:numel(elasticityList)
    
    
    %[n,xout] = hist(gca,ballLocationAtMeanMin_el_cRep{eIdx},histRange );
    [n,xout] = hist(gca,ball2BounceDegsAtMeanMin_el_cRep{eIdx},histRange );
    
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
    xlim([min(histRange) max(histRange)])
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Scatter - gaze height vs hand height

figure(1005)
clf
hold on    
xlabel('gaze pitch at fixation')
ylabel('hand height at bounce')
xlim([-35 -15])
ylim([.75 1.75])

gazePitchDuringFixTEMP_tr= removeOutliers(gazePitchDuringFix_tr,2.5);
handHeightAtBounceTEMP_tr = removeOutliers(handHeightAtBounce_tr,2.5);

idx = find(~isnan(gazePitchDuringFixTEMP_tr));
idx = intersect( idx, find(~isnan(handHeightAtBounceTEMP_tr)));
    
temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx));
fprintf('\n**Corr fix elevation Vs hand height at bounce**\n');
fprintf('- For all: %1.2f\n',temp(1,2));
    
for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(gazePitchDuringFixTEMP_tr)));
    idx = intersect( idx, find(~isnan(handHeightAtBounceTEMP_tr)));
    
    temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx));
    
    fprintf('for e%i: %1.2f \n',eIdx,temp(1,2));
    scatter( gazePitchDuringFixTEMP_tr(idx),handHeightAtBounceTEMP_tr(idx),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)

end


%%


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Scatter - gaze elevation vs ball elevation at aveage min

figure(1006)
clf
hold on    
xlabel('gaze elevation at fixation')
ylabel('ball elevation at avg time of minimum')
%xlim([-35 -15])
%ylim([.5 2.5])

gazePitchDuringFixTEMP_tr= removeOutliers(gazePitchDuringFix_tr,2.5);
ballLocationAtMeanMinTEMP_tr= removeOutliers(ballLocationAtMeanMin_tr,2.5);

idx = find(~isnan(gazePitchDuringFixTEMP_tr));
idx = intersect( idx, find(~isnan(gazePitchAtMeanMin_tr)));
    
temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),ballLocationAtMeanMinTEMP_tr(idx));
fprintf('\n**Corr fix elevation Vs hand height at bounce**\n');
fprintf('- For all: %1.2f\n',temp(1,2));
    
line([-31 -20],[-31 -20],'LineStyle',':','Color','k')

for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(gazePitchDuringFixTEMP_tr)));
    idx = intersect( idx, find(~isnan(ballLocationAtMeanMinTEMP_tr)));
    
    temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),gazePitchAtMeanMin_tr(idx));
    
    fprintf('for e%i: %1.2f \n',eIdx,temp(1,2));
    scatter( gazePitchDuringFixTEMP_tr(idx),ballLocationAtMeanMinTEMP_tr(idx),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)

end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Scatter - gaze elevation vs ball elevation at aveage min

figure(1006)
clf
hold on    
xlabel('gaze elevation at fixation')
ylabel('ball height at apex')
axis square equal
%xlim([-35 -15])
%ylim([.5 2.5])

gazePitchDuringFixTEMP_tr= removeOutliers(gazePitchDuringFix_tr,2.5);
ballElevationAtApexTEMP_tr= removeOutliers(ballElevationAtApex_tr,2.5);

idx = find(~isnan(gazePitchDuringFixTEMP_tr));
idx = intersect( idx, find(~isnan(ballElevationAtApexTEMP_tr)));
    
temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),ballElevationAtApexTEMP_tr(idx));
fprintf('\n**Corr fix elevation Vs hand height at bounce**\n');
fprintf('- For all: %1.2f\n',temp(1,2));
    
line([-3 3],[-3 3],'LineStyle',':','Color','k')

for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(~isnan(gazePitchDuringFixTEMP_tr)));
    idx = intersect( idx, find(~isnan(ballElevationAtApexTEMP_tr)));
    
    temp = corrcoef( gazePitchDuringFixTEMP_tr(idx),ballElevationAtApexTEMP_tr(idx));
    
    fprintf('for e%i: %1.2f \n',eIdx,temp(1,2));
    scatter( zscore(gazePitchDuringFixTEMP_tr(idx)),zscore(ballElevationAtApexTEMP_tr(idx)),80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)

end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



