function handle = plotObs(sessionData,trialNum,color)

loadParameters

trialData = sessionData.rawData_tr(trialNum);

%FIXME:  Obstacle height should be a part of the text file

obsHeight = legLength * obsHeightRatio_trialType ( trialData.trialType );
obstacle_XposYposHeight = trialData.obstacle_XposYposHeight;


btmZ = 0; %obstacle_XYZ(3); %- obsHeight/2;
topZ = obstacle_XposYposHeight(3);% + obsHeight/2;

frY = obstacle_XposYposHeight(2) - obsLW(2)/2;
bkY = obstacle_XposYposHeight(2) + obsLW(2)/2;

lX = obstacle_XposYposHeight(1) - obsLW(1)/2;
rX = obstacle_XposYposHeight(1) + obsLW(1)/2;

my_vertices = [lX frY topZ; rX frY topZ;  rX frY btmZ; lX frY btmZ; lX bkY topZ; rX bkY topZ;  rX bkY btmZ; lX bkY btmZ];

my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8 ; 1 5 8 4; 1 2 6 5; 5 6 7 8];

%[1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];

handle = patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', color);

%[0 0 0; 0 1 0; 1 1 0; 1 0 0; 0 0 1; 0 1 1; 1 1 1; 1 0 1];