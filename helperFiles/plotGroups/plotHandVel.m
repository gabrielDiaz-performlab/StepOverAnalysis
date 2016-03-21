%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Hand velocity along the plane

figure(1021)
clf
[n,xout] = hist(handPlanarVelFilt_rep_el)

%[n,xout] = hist(handVelFilt_rep_el)
h = bar(xout,n,2);
xlabel('filtered hand velocity');
for eIdx = 1:numel(elasticityList)
    set(h(eIdx),'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n(:,eIdx),'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
end

axis([0 2.5 0 40])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Planar velocity at bounce

figure(1025)
clf
hold on
plot(1:numTrials/2,handPlanarVelFilt_rep_el(:,1),'g')
plot(1:numTrials/2,handPlanarVelFilt_rep_el(:,2),'r')
ylabel('filtered hand velocity (m/s)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% figure(1022)
% clf
% [n,xout] = hist(handPlanarVelFilt_fr(bounceFrame_tr),30);
% [n,xout] = hist(handVelFilt_rep_el)
% h = bar(xout,n);
% set(h,'facecolor',colorList(eIdx))
% f1 = ezfit(xout,n,'gauss');
% showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);




