function [sessionData] = calcGVPosOnObj(sessionData, trIdx)
%% Rakshit Kothari
% This function computes the angular separation between the fixation
% location in the obstacle plane and the 3D object. These fixations are
% later used to characterize if the object was present on the participant's
% visual field. 

loadParameters

Ts = sessionData.processedData_tr(trIdx).ETG.ETG_ts;

glasses_fr_xyz = sessionData.processedData_tr(trIdx).glasses.pos_fr_xyz;
GIW = sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec;  
ObjLoc = sessionData.processedData_tr(trIdx).obs.pos_xyz;
ObjH = sessionData.processedData_tr(trIdx).obs.height;
ObjL = obsLW(1);
ObjBoundaries = [-ObjL/2, ObjLoc(2), 0; -ObjL/2,  ObjLoc(2), ObjH; ObjL/2,  ObjLoc(2), 0; ObjL/2,  ObjLoc(2), ObjH];

P = glasses_fr_xyz;

GIW_len = (ObjLoc(2) - P(:,2))./GIW(:,2);

loc = ObjLoc(:,2) - P(:,2) > 0 & P(:,2) > showObsAtDistOf;

Q = P + repmat(GIW_len,[1 3]).*GIW;
Q(~loc,:) = NaN;

[dist12, ~, pos12] = distancePointEdge3d(Q,[ObjBoundaries(1,:) ObjBoundaries(2,:)]);
[dist24, ~, pos24] = distancePointEdge3d(Q,[ObjBoundaries(2,:) ObjBoundaries(4,:)]);
[dist43, ~, pos43] = distancePointEdge3d(Q,[ObjBoundaries(4,:) ObjBoundaries(3,:)]);
[dist31, ~, pos31] = distancePointEdge3d(Q,[ObjBoundaries(3,:) ObjBoundaries(1,:)]);

pos(:,:,1) = pos12;
pos(:,:,2) = pos24;
pos(:,:,3) = pos43; 
pos(:,:,4) = pos31;

[~, d] = min([dist12 dist24 dist43 dist31],[],2); 

closestPtOnObj = zeros(length(d),3);

for i = 1:length(d)
    if loc(i)
        closestPtOnObj(i,:) = pos(i,:,d(i));
    else
        closestPtOnObj(i,:) = NaN;
    end
end

eyeToClosestPtDir = normr(closestPtOnObj - P);
angSeparation = acosd(sum(eyeToClosestPtDir.*GIW,2)); angSeparation(~loc) = NaN;

sessionData.processedData_tr(trIdx).ETG.GVPosOnPlane_fr = Q;
sessionData.processedData_tr(trIdx).ETG.closestPtOnObj_fr = closestPtOnObj;
sessionData.processedData_tr(trIdx).ETG.angSeparation = angSeparation;
end

