function plotTrialRigid(sessionData,trialNum)

loadParameters

trialData = sessionData.rawData_tr(trialNum);
numFrames = size(trialData.rightFoot_fr_mkr_XYZ,1);

if( sessionData.rawData_tr(trialNum).subIsWalkingUpAxis == 0 )
    fprintf('Trial is flipped\n')
end

% Create figure
figure1 = figure(trialNum);
clf
set(gcf,'Renderer','OpenGL');
hold on 
axis off

%% Plot markers over time

% plotMarkersFromRigid(figure1,trialData.rightFoot_fr_mkr_XYZ,'r')
% plotMarkersFromRigid(figure1,trialData.leftFoot_fr_mkr_XYZ,'b')
% plotMarkersFromRigid(figure1,trialData.head_fr_mkr_XYZ,'k')
% plotMarkersFromRigid(figure1,trialData.spine_fr_mkr_XYZ,'g')

%% Plot obstacle
plotObs(sessionData,trialNum,'c');

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
camproj('orthographic')
camva('manual') 
camva(60)

spine_fr_xyz = sessionData.processedData_tr.spine_fr_xyz;

frIdx = 1;

footPos_XYZ = squeeze(mean(trialData.rightFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
footSize_LWH = [.25 .1 .07];
rotMat_d1_d2 = squeeze(trialData.rightFootRot_fr_d1_d2(frIdx,:,:));

% WHen the first arg passed to plotBox() is a figure object, it adds a new
% patch object
rFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');

footPos_XYZ = squeeze(mean(trialData.leftFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
footSize_LWH = [.25 .1 .07];
rotMat_d1_d2 = squeeze(trialData.leftFootRot_fr_d1_d2(frIdx,:,:));
lFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'b');

for frIdx = 1:5:numFrames
   
    camPos_XYZ = [1 spine_fr_xyz(frIdx,2) .7];
    camTarg_XYZ = [0 spine_fr_xyz(frIdx,2) .7];
    
    campos(camPos_XYZ);
    camtarget(camTarg_XYZ);
    
    footPos_XYZ = squeeze(mean(trialData.rightFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
    rotMat_d1_d2 = squeeze(trialData.rightFootRot_fr_d1_d2(frIdx,:,:)); 
    % WHen the first arg passed to plotBox() is a patch object, it updates
    % the patch object
    rFootBox = plotBox(rFootBox,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');
    
	footPos_XYZ = squeeze(mean(trialData.leftFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
    rotMat_d1_d2 = squeeze(trialData.leftFootRot_fr_d1_d2(frIdx,:,:)); 
    lFootBox = plotBox(lFootBox,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'b');
    
    %pause(1/60)
    drawnow
    
end
