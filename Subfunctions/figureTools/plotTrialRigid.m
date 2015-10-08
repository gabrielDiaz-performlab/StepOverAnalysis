function F = plotTrialRigid(sessionData,trialNum)

loadParameters

trialData = sessionData.processedData_tr(trialNum);
numFrames = size(trialData.rFoot.rbPos_mFr_xyz,1);

if( trialData.info.subIsWalkingUpAxis == 0 )
    fprintf('Trial is flipped\n')
end

% Create figure
% figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
figure1 = figure;
clf
set(gcf,'Renderer','OpenGL');
hold on 
axis off
axis manual

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
%TitleText = sprintf('Trial number %1.0f ', trialNum);

% Create title
%title(TitleText,'FontWeight','bold','FontSize',14,'FontName','Arial');

% Create xlabel
xlabel('X (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

% Create ylabel
ylabel('Y (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

% Create zlabel
zlabel('Z (m)','FontWeight','bold','FontSize',12,'FontName','Arial');

%%

set(gcf,'position',[0,350,950,450])

set(gca,'cameraviewanglemode','manual');
camtarget('manual')
campos('manual')
camproj('orthographic')
camva('manual') 
camva(60)

GIW = trialData.ETG.cycGIW_fr_vec;
GIWx = trialData.ETG.cycGIWx_fr_vec;
GIWy = trialData.ETG.cycGIWy_fr_vec;
GIWz = trialData.ETG.cycGIWz_fr_vec;

headPos = trialData.glasses.rbPos_mFr_xyz;

% gazePoint = headPos + GIW*1.5;
gazePointx = headPos + GIWx*0.5;
gazePointy = headPos + GIWy*0.5;
gazePointz = headPos + GIWz*0.5;
gazePoint = trialData.ETG.GVPosOnObj;

frIdx = 1;

footPos_XYZ = trialData.rFoot.rbPos_mFr_xyz(frIdx,:);
footSize_LWH = [.25 .1 .07];
headSize_LWH = [0.3 0.3 0.3];

rotMat_d1_d2 = squeeze(trialData.rFoot.rot_fr_d1_d2(frIdx,:,:));

% WHen the first arg passed to plotBox() is a figure object, it adds a new
% patch object
rFootBox = plotBox(figure1, footPos_XYZ, footSize_LWH, rotMat_d1_d2, 'r');

footPos_XYZ = trialData.lFoot.rbPos_mFr_xyz(frIdx,:);
footSize_LWH = [.25 .1 .07];
rotMat_d1_d2 = squeeze(trialData.lFoot.rot_fr_d1_d2(frIdx,:,:));

lFootBox = plotBox(figure1, footPos_XYZ, footSize_LWH, rotMat_d1_d2, 'b');

%Plot a box for the head too
rotMat_d1_d2 = squeeze(trialData.glasses.rot_fr_d1_d2(frIdx,:,:));
glassesBox = plotBox(figure1, headPos(frIdx,:), headSize_LWH, rotMat_d1_d2, 'g');

gaze = plotGV(figure1, headPos, gazePoint, frIdx);

nFrames = length(1:20:numFrames);

% Preallocate movie structure.
F(1:nFrames) = struct('cdata', [], 'colormap', []);

counter = 1;
for frIdx = 1:20:numFrames
   
    camPos_XYZ =  [3 headPos(frIdx,2) 3];
    camTarg_XYZ = [0 headPos(frIdx,2) .5];
    
    if any(isnan(camPos_XYZ))
        camPos_XYZ = [0 0 0];
        camTarg_XYZ = [0 0 0];
    end
    
    campos(camPos_XYZ);
    camtarget(camTarg_XYZ);
    
    %footPos_XYZ = trialData.rFoot.rbPos_mFr_xyz(frIdx,:);
    %rotMat_d1_d2 = squeeze(trialData.rFoot.rot_fr_d1_d2(frIdx,:,:));
    
    %rFootBox = plotBox(rFootBox, footPos_XYZ, footSize_LWH, rotMat_d1_d2, 'r');
    
	%footPos_XYZ = trialData.lFoot.rbPos_mFr_xyz(frIdx,:);
    %rotMat_d1_d2 = squeeze(trialData.lFoot.rot_fr_d1_d2(frIdx,:,:));
    
    %lFootBox = plotBox(lFootBox, footPos_XYZ, footSize_LWH, rotMat_d1_d2, 'b');
    
%     headPos_XYZ = headPos(frIdx,:);
%     rotMat_d1_d2 = squeeze(trialData.glasses.rot_fr_d1_d2(frIdx,:,:));
%     
%     glassesBox = plotBox(glassesBox, headPos_XYZ, headSize_LWH, rotMat_d1_d2, 'g');
    
    % update gaze vector
    gaze = plotGV(gaze, headPos, gazePoint, frIdx);
    
    gazex = line([headPos(frIdx,1) gazePointx(frIdx,1)],[headPos(frIdx,2) gazePointx(frIdx,2)],[headPos(frIdx,3) gazePointx(frIdx,3)],'Color',[1 0 0],'LineWidth',2);
    gazey = line([headPos(frIdx,1) gazePointy(frIdx,1)],[headPos(frIdx,2) gazePointy(frIdx,2)],[headPos(frIdx,3) gazePointy(frIdx,3)],'Color',[0 1 0],'LineWidth',2);
    gazez = line([headPos(frIdx,1) gazePointz(frIdx,1)],[headPos(frIdx,2) gazePointz(frIdx,2)],[headPos(frIdx,3) gazePointz(frIdx,3)],'Color',[0 0 1],'LineWidth',2);
    
    drawnow
    
    F(counter) = getframe(figure1);
    counter = counter + 1;
    
end