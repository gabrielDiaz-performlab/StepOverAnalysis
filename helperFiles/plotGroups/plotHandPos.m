
c = [.2, .2, .2, .2, .2]';

colorList = 'rbckg';
shapeList = 'sdo';
styleList = ':*-';
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ball and hand distributions

if( isempty(focusOnBlocks) )
    setYlimsTo = [0 10*numBlocks+10];
else
    setYlimsTo = [0 10*numel(focusOnBlocks)+10];
end

figure(1000)
hold on
set(1000,'Units','Normalized','Position',[0.041 0.55 0.31 0.41]);


subplot(2,1,1)
hold on
xlim([.75 2.25])
ylim([0 .3])
xlabel('final ball height (m)')
ylabel('probability')

[n,xout] = hist(finalBallHeight_rep_el,0:0.05:4);
n(:,1) = n(:,1)./sum(n(:,1));
n(:,2) = n(:,2)./sum(n(:,2));
h = bar(xout,n,2);

for eIdx = 1:numel(elasticityList)
    set(h(eIdx),'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n(:,eIdx),'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hand position

subplot(2,1,2)
hold on
xlim([.75 2.25])
ylim([0 .3])
ylabel('probability')
xlabel('predictive hand height (m)')


[n,xout] = hist(predHandHeight_rep_el,0:0.05:4);
n(:,1) = n(:,1)./sum(n(:,1));
n(:,2) = n(:,2)./sum(n(:,2));
h = bar(xout,n,2);


for eIdx = 1:numel(elasticityList)
    set(h(eIdx),'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n(:,eIdx),'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Final hand position
% 
% subplot(3,1,3)
% hold on
% xlim([0 2.5])
% ylim(setYlimsTo)
% title('Final Hand Height')
% 
% [n,xout] = hist(finalHandPos_rep_el,0:0.05:4);
% h = bar(xout,n,2);
% 
% for eIdx = 1:numel(elasticityList)
%     set(h(eIdx),'facecolor',colorList(eIdx))
%     f1 = ezfit(xout,n(:,eIdx),'gauss');
%     showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Hand position over time
% 
% figure(1031)
% clf
% hold on    
% xlabel('Trial')
% ylabel('Hand position')
% set(gcf,'Units','Normalized','Position',[0.013 0.44 0.67 0.47]);
% 
% for eIdx = 1:numel(elasticityList)
%     idx = find(elasticity_tr==elasticityList(eIdx));
%     plot( handPosAtBounce_tr(idx), colorList(eIdx))
%     plot( ballHeightAtArrival_tr(idx),[styleList(1) colorList(eIdx)])
% end
% 

plot2svg('probFinalHeights')
