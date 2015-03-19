function plotTrialMarkers(sessionData,trialNum)

trialData = sessionData.rawData_tr(trialNum);

trialData.subIsWalkingUpAxis

% Create figure
figure1 = figure(trialNum);
hold on 


%%
headFirst_XYZ = squeeze(trialData.head_fr_mkr_XYZ(1,2,:));
scatter3(headFirst_XYZ(1),headFirst_XYZ(2),headFirst_XYZ(3),400,'r','Filled')

plotRigidMarkers(figure1,trialData.rightFoot_fr_mkr_XYZ,'r')
plotRigidMarkers(figure1,trialData.leftFoot_fr_mkr_XYZ,'b')
plotRigidMarkers(figure1,trialData.head_fr_mkr_XYZ,'k')
plotRigidMarkers(figure1,trialData.spine_fr_mkr_XYZ,'g')

plotObs(sessionData,trialNum,'c')

grid on 


view([46 8]);

%grid(axes1,'on');
%axis([-2, 3, -2.5, -0.5, 0,2])
axis([-2, 2, -0.5, 7.5, 0,2.25])
axis equal


%%
TitleText = sprintf('Trial number %1.0f ', trialNum);

% Create title
title(TitleText,'FontWeight','bold','FontSize',14,'FontName','Arial');

% Create xlabel
xlabel('X (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

% Create ylabel
ylabel('Y (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

% Create zlabel
zlabel('Z (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

%%


set(gcf,'position',[0,350,950,450])
