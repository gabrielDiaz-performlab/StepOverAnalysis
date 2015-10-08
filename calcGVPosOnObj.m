function [sessionData] = calcGVPosOnObj(sessionData, trIdx)

loadParameters

glasses_fr_xyz = sessionData.processedData_tr(trIdx).glasses.pos_fr_xyz;
GIW = sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec;  
ObjLoc = sessionData.processedData_tr(trIdx).obs.pos_xyz;
ObjH = sessionData.processedData_tr(trIdx).obs.height;
ObjL = obsLW(1);
ObjBoundaries = [-ObjL/2, ObjLoc(2), 0; -ObjL/2,  ObjLoc(2), ObjH; ObjL/2,  ObjLoc(2), 0; -ObjL/2,  ObjLoc(2), ObjH];

% Look at Figure to understand Trig. Project GV ray towards ground plane.
P = glasses_fr_xyz;
GIW_len = (ObjLoc(2) - P(:,2))./GIW(:,2);

loc = ObjLoc(:,2) - P(:,2) > 0;

Q = P + repmat(GIW_len,[1 3]).*GIW;
Q(~loc,:) = NaN;

sessionData.processedData_tr(trIdx).ETG.GVPosOnObj = Q;


end

