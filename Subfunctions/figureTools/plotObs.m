function handle = plotObs(sessionData,trialNum,color)

loadParameters

trialData = sessionData.processedData_tr(trialNum);

%FIXME:  Obstacle height should be a part of the text file
% legLength = sessionData.expInfo.obstacleHeights(1) ./ sessionData.expInfo.obsHeightRatios(1);
% obsHeight = legLength * obsHeightRatio_trialType ( trialData.trialType );

obstacle_XposYposZpos = trialData.obs.pos_xyz;
obstacle_Height = trialData.obs.height;

btmZ = obstacle_XposYposZpos(3); 
topZ = obstacle_Height;

frY = obstacle_XposYposZpos(2) - obsLW(2)/2;
bkY = obstacle_XposYposZpos(2) + obsLW(2)/2;

lX = obstacle_XposYposZpos(1) - obsLW(1)/2;
rX = obstacle_XposYposZpos(1) + obsLW(1)/2;

my_vertices = [lX frY topZ; rX frY topZ;  rX frY btmZ; lX frY btmZ; lX bkY topZ; rX bkY topZ;  rX bkY btmZ; lX bkY btmZ];

my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8 ; 1 5 8 4; 1 2 6 5; 5 6 7 8];

%[1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];

handle = patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', color);