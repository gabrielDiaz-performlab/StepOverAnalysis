figure(1031)
clf
hold on           
set(gcf,'Units','Normalized','Position',[0.061 0.24 0.34 0.67]);

title('Time of ball arrival at fixation')
   
for eIdx = 1:numel(elasticityList)
    subplot(2,1,eIdx)
    xlabel('time of the min')
    ylabel('number of trials')
    hold on
    
    [n,xout] = hist(gca,fixMinS2B_el_cRep{eIdx}*1000,-100:20:300);
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix elevation to bouncepoint

figure(1002)
hold on
%set(gcf,'Units','Normalized','Position',[0.0410714285714286 0.444552529182879 0.670833333333333 0.463035019455253]);
set(gcf,'Units','Normalized','Position',[0.021 0.28 0.61 0.57]);
hold on
%xlim([-35 -10])
title('Gaze elevation to bounce-point')

%[n,xout] = hist(gazePitch_rep_el,-40:1:-10);

for eIdx = 1:numel(elasticityList)
    [n,xout] = hist(gca,-fixElev2Bounce_el_cRep{eIdx},-25:1:40);
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
end