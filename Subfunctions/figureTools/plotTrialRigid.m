function plotTrialRigid(sessionData,trialNum)

loadParameters

trialData = sessionData.processedData_tr(trialNum);
numFrames = size(trialData.rFoot.rbPos_mFr_xyz,1);

if( trialData.info.subIsWalkingUpAxis == 0 )
    fprintf('Trial is flipped\n')
end

% Create figure
figure1 = figure;
clf
set(gcf,'Renderer','OpenGL');
hold on 
axis off

%% Plot markers over time

plotMarkersFromRigid(trialData.rFoot.mkrPos_mIdx_Cfr_xyz,'r')
plotMarkersFromRigid(trialData.lFoot.mkrPos_mIdx_Cfr_xyz,'b')
plotMarkersFromRigid(trialData.glasses.mkrPos_mIdx_Cfr_xyz,'k')
plotMarkersFromRigid(trialData.spine.mkrPos_mIdx_Cfr_xyz,'g');

%% Plot obstacle
plotObs(sessionData,trialNum,'c');

axis([-2, 2, -0.5, 7.5, 0,7])
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
% rFootBox = 0;
% lFootBox = 0;

camtarget('manual')
campos('manual')
camproj('orthographic')
camva('manual') 
camva(60)

spine_fr_xyz = trialData.spine.rbPos_mFr_xyz;

frIdx = 1;

% footPos_XYZ = squeeze(mean(trialData.rightFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
footPos_XYZ = trialData.rFoot.rbPos_mFr_xyz(frIdx,:);
footSize_LWH = [.25 .1 .07];
rotMat_d1_d2 = squeeze(trialData.rFoot.rot_fr_d1_d2(frIdx,:,:));

% WHen the first arg passed to plotBox() is a figure object, it adds a new
% patch object
rFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');

% footPos_XYZ = squeeze(mean(trialData.leftFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
footPos_XYZ = trialData.lFoot.rbPos_mFr_xyz(frIdx,:);
footSize_LWH = [.25 .1 .07];
rotMat_d1_d2 = squeeze(trialData.lFoot.rot_fr_d1_d2(frIdx,:,:));

lFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'b');

for frIdx = 1:20:numFrames
   
    camPos_XYZ = [1 spine_fr_xyz(frIdx,2) .7];
    camTarg_XYZ = [0 spine_fr_xyz(frIdx,2) .7];
    
    if any(isnan(camPos_XYZ))
        camPos_XYZ = [0 0 0];
        camTarg_XYZ = [0 0 0];
    end
    
    campos(camPos_XYZ);
    camtarget(camTarg_XYZ);
    
    footPos_XYZ = trialData.rFoot.rbPos_mFr_xyz(frIdx,:);
    rotMat_d1_d2 = squeeze(trialData.rFoot.rot_fr_d1_d2(frIdx,:,:));
    
    rFootBox = plotBox(rFootBox,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');
    
	footPos_XYZ = trialData.lFoot.rbPos_mFr_xyz(frIdx,:);
    rotMat_d1_d2 = squeeze(trialData.lFoot.rot_fr_d1_d2(frIdx,:,:));
    
    lFootBox = plotBox(lFootBox,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'b');
    
    drawnow
    
end
