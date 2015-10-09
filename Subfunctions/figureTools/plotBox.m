% If handleIn is a Figure, plot a box on that figure
% If handleIn is a Patch, update the patch

function [handleOut] = plotBox(handleIn,boxPos_XYZ,boxLWH,boxRot_d1_d2,face_color)

color = [0 0 0;1 1 1;1 0 0;0 1 0;0 0 1;1 1 0;0 1 1;1 0 1];

loadParameters

btmZ = -boxLWH(3)/2;
topZ = boxLWH(3)/2;

frY = -boxLWH(1)/2;
bkY = boxLWH(1)/2;

lX = -boxLWH(2)/2;
rX = boxLWH(2)/2;

unRotVert_vIdx_XYZ = [lX frY topZ; rX frY topZ;  rX frY btmZ; lX frY btmZ; lX bkY topZ; rX bkY topZ;  rX bkY btmZ; lX bkY btmZ];
rotVert_vIdx_XYZ = zeros(size(unRotVert_vIdx_XYZ));

for vIdx = 1:size(unRotVert_vIdx_XYZ,1)
    
    vert = unRotVert_vIdx_XYZ(vIdx,:);
    virtDir = boxRot_d1_d2(1:3,1:3) * vert'; 
    rotVert_vIdx_XYZ(vIdx,:) = boxPos_XYZ + virtDir';
    
end

my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8 ; 1 5 8 4; 1 2 6 5; 5 6 7 8];

if( isgraphics(handleIn,'Figure') )
    % Create a new box
    handleOut = patch('Vertices', rotVert_vIdx_XYZ, 'Faces', my_faces, 'FaceVertexCData',...
        color, 'MarkerFaceColor','flat','Marker','o','FaceColor',face_color);
    
elseif( isgraphics(handleIn,'Patch') )
    
    handleOut = handleIn;
    handleOut.Faces = my_faces; 
    handleOut.Vertices = rotVert_vIdx_XYZ;
    
end


