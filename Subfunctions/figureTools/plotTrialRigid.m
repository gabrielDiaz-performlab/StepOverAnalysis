function plotTrialRigid(sessionData,trialNum)

trialData = sessionData.rawData_tr(trialNum);
numFrames = size(trialData.rightFoot_fr_mkr_XYZ,1);
% Create figure
figure1 = figure(trialNum);
set(gcf,'Renderer','OpenGL');
hold on 

%%
plotMarkersFromRigid(figure1,trialData.rightFoot_fr_mkr_XYZ,'r')
plotMarkersFromRigid(figure1,trialData.leftFoot_fr_mkr_XYZ,'b')
plotMarkersFromRigid(figure1,trialData.head_fr_mkr_XYZ,'k')
plotMarkersFromRigid(figure1,trialData.spine_fr_mkr_XYZ,'g')


%%

% sessionData.rawData_tr.leftFootQUAT_fr_WXYZ

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



% FixMe:  foot posiion should be saved
%%
rFootBox = 0;
lFootBox = 0;

camtarget('manual')
campos('manual')

campos([29.6054  -24.6541    6.4757]);
camtarget([0.5446    3.4096    0.7980]);

for frIdx = 1:5:numFrames

    if( frIdx>1 )
        delete(rFootBox)
        delete(lFootBox)
    end
    
    footPos_XYZ = squeeze(mean(trialData.rightFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
    footSize_LWH = [.25 .1 .07];
    rotMat_d1_d2 = squeeze(trialData.rightFootRot_fr_d1_d2(frIdx,:,:)); 
    rFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');
    
    
	footPos_XYZ = squeeze(mean(trialData.leftFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
    footSize_LWH = [.25 .1 .07];
    rotMat_d1_d2 = squeeze(trialData.leftFootRot_fr_d1_d2(frIdx,:,:)); 
    lFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'b');
    
    pause(1/30)
end
%%
    %function [] = plotBox(figHandle,boxPos_fr_XYZ,boxLWH,boxRot_d1_d2,color)

%end
%%
