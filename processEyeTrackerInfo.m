function sessionData = processEyeTrackerInfo(sessionData, trIdx)
%% Generate Cyclopean GV by vector addition
inHead_L_GV = sessionData.processedData_tr(trIdx).ETG.L_GVEC;
inHead_R_GV = sessionData.processedData_tr(trIdx).ETG.R_GVEC;

% Normalize the GV to a unit vector
cycEIH_fr_vec = inHead_L_GV + inHead_R_GV; cycEIH_fr_vec = normr(cycEIH_fr_vec);

%% Bring it into MATlab coordinates

% cycEIH_fr_vec(:,[1 2]) = 0; cycEIH_fr_vec(:,3) = 1;
cycEIH_fr_vec(:,[1 2 3]) = cycEIH_fr_vec(:,[1 3 2]);
cycEIH_fr_vec(:,1) = -cycEIH_fr_vec(:,1);
%cycEIH_fr_vec(:,2) = -cycEIH_fr_vec(:,2);

cycEIHx_fr_vec = cycEIH_fr_vec;
cycEIHx_fr_vec(:,[2 3]) = 0; cycEIHx_fr_vec(:,1) = 1;
cycEIHx_fr_vec(:,[1 2 3]) = cycEIHx_fr_vec(:,[1 2 3]);

cycEIHy_fr_vec = cycEIH_fr_vec;
cycEIHy_fr_vec(:,[1 3]) = 0; cycEIHy_fr_vec(:,2) = 1;
cycEIHy_fr_vec(:,[1 2 3]) = cycEIHy_fr_vec(:,[1 2 3]);

cycEIHz_fr_vec = cycEIH_fr_vec;
cycEIHz_fr_vec(:,[1 2]) = 0; cycEIHz_fr_vec(:,3) = 1;
cycEIHz_fr_vec(:,[1 2 3]) = cycEIHz_fr_vec(:,[1 2 3]);


sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec  = quatrotate(sessionData.processedData_tr(trIdx).glasses.quat_fr_wxyz,cycEIH_fr_vec);

sessionData.processedData_tr(trIdx).ETG.cycGIWx_fr_vec = quatrotate(sessionData.processedData_tr(trIdx).glasses.quat_fr_wxyz,cycEIHx_fr_vec);
sessionData.processedData_tr(trIdx).ETG.cycGIWy_fr_vec = quatrotate(sessionData.processedData_tr(trIdx).glasses.quat_fr_wxyz,cycEIHy_fr_vec);
sessionData.processedData_tr(trIdx).ETG.cycGIWz_fr_vec = quatrotate(sessionData.processedData_tr(trIdx).glasses.quat_fr_wxyz,cycEIHz_fr_vec);

%% Find Fixations

ETG_ts = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
timeStampMS_fr = ETG_ts * 1000;
GIW = sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec;

% Generate Gaze In World Azimuth
giwFiltDegsX_fr = atand(GIW(:,1)./GIW(:,2));
% giwFiltDegsY_fr = atand(GIW(:,2)./sqrt(GIW(:,1).^2 + GIW(:,3).^2));
giwFiltDegsY_fr = asind(GIW(:,3));

% % Generate Gaze velocity
% vel_diff = diff([0 0 ;[giwFiltDegsX_fr, giwFiltDegsY_fr]],1,1);
% vel_diff = sqrt(sum(vel_diff.^2, 2));
% ts_diff = diff([0;ETG_ts]);

Beta = acosd(GIW(:,2));
vel_diff = diff([0; Beta],1,1);
ts_diff = diff([0;ETG_ts]);
gazeVelDegsSec_fr = abs(vel_diff./ts_diff);

clump_space_thresh = 2;
clump_t_thresh = 50;
t_thresh = 20;
vel_thresh = 40;

[fix, fixAllFr_fixIdx_onOff] = fix_finder_vt( ... 
    timeStampMS_fr, ...
    [giwFiltDegsX_fr, giwFiltDegsY_fr],...
    gazeVelDegsSec_fr, ...
    clump_space_thresh, ...
    clump_t_thresh, ...
    t_thresh, ...
    vel_thresh);

sessionData.processedData_tr(trIdx).ETG.fix_ts_onOff = fix;
sessionData.processedData_tr(trIdx).ETG.fix_fr_onOff = fixAllFr_fixIdx_onOff;
end