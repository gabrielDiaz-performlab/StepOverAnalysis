function figH = plotTrialMarkers(sessionData,trialNum)

trialData = sessionData.processedData_tr(trialNum);


% Create figure
figH = figure;
grid on; axis equal;
hold on 


%% Plot Marker data
plotMarkersFromRigid(trialData.rFoot.mkrPos_mIdx_Cfr_xyz,'r')
plotMarkersFromRigid(trialData.lFoot.mkrPos_mIdx_Cfr_xyz,'b')
plotMarkersFromRigid(trialData.glasses.mkrPos_mIdx_Cfr_xyz,'k')
plotMarkersFromRigid(trialData.spine.mkrPos_mIdx_Cfr_xyz,'g');

%% Plot obstacle
plotObs(sessionData,trialNum,'c')

view([46 8]);

axis([-2, 2, -0.5, 7.5, 0,2.25])
axis equal


%%
TitleText = sprintf('Trial number %1.0f ', trialNum);

% Create titles
title(TitleText,'FontWeight','bold','FontSize',14,'FontName','Arial');
xlabel('X (m)','FontWeight','bold','FontSize',12,'FontName','Arial');
ylabel('Y (m)','FontWeight','bold','FontSize',12,'FontName','Arial');
zlabel('Z (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

%%

set(gcf,'position',[0,350,950,450])
