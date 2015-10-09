%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hand-ball error over time

figure(1021)
clf
hold on    
xlabel('Trial')
ylabel('Hand-to-ball distance')
%plot(handToBallErrM_tr )
set(1021,'Units','Normalized','Position',[0.013 0.44 0.67 0.47]);


for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    plot( handToBallDist_tr(idx), colorList(eIdx))
    display(sprintf('Standard deviation in hand error e%i: %1.2f',eIdx,std( handToBallDist_tr(idx) )));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gaze elevaiton to bouncepoint

figure(1002)
hold on
%set(gcf,'Units','Normalized','Position',[0.0410714285714286 0.444552529182879 0.670833333333333 0.463035019455253]);
set(gcf,'Units','Normalized','Position',[0.021 0.28 0.61 0.57]);
hold on
%xlim([-35 -10])
title('Gaze elevation to bounce-point')

%[n,xout] = hist(gazePitch_rep_el,-40:1:-10);

for eIdx = 1:numel(elasticityList)
    [n,xout] = hist(gca,-fixElev2Bounce_el_cRep{eIdx},-10:1:15);
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix to ball distance

figure(1030)
clf
hold on           
set(1030,'Units','Normalized','Position',[0.061 0.24 0.34 0.67]);
        
for eIdx = 1:numel(elasticityList)
    subplot(2,1,eIdx)
    xlabel('fix-to-ball distance (degrees)')
    ylabel('number of trials')
    hold on
    xlim([0 10])
    [n,xout] = hist(gca,fix2BallMinDegs_el_cRep{eIdx},0:10);
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
end

