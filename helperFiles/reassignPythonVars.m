%%  Map text variables onto exp variables

% Match frameTime
sceneTime_fr = frameTime;
eventFlag_fr = eventFlag;
viewPos_fr_xyz = viewPos_XYZ;

%%
% Racquet velocities are derived
racqPos_fr_xyz = paddlePos_XYZ;
    
%racqAng_fr_xyz = paddleAngVel_XYZ;
%racqVel_fr_xyz = paddleVel_XYZ;
racqVel_fr_xyz = [[0 0 0]; diff(racqPos_fr_xyz)];


%%
ballPix_fr_xyDist = ballPix_XYDist;

ballPos_fr_xyz = ballPos_XYZ; % Must update ball position with nan when ball is not visible!
ballVel_fr_xyz = ballVel_XYZ;

ballBounceX_tr = ballBounceLoc_XYZ(:,1); % Not there!
ballBounceY_tr = ballBounceLoc_XYZ(:,3); % Not there!
ballBounceZ_tr = ballBounceLoc_XYZ(:,2); % Not there!

initBallX_tr = ballInitialPos_XYZ(:,1);
initBallY_tr = ballInitialPos_XYZ(:,2);
initBallZ_tr = ballInitialPos_XYZ(:,3);

initBallVelX_tr = initialVelocity_XYZ(:,1);
initBallVelY_tr = initialVelocity_XYZ(:,2);
initBallVelZ_tr = initialVelocity_XYZ(:,3);

racquHitLocList_xyz = ballOnPaddlePosLoc_XYZ;

elasticity_tr = ballElasticity;
distToBounce_tr = ballBounceDist ;
zDot_tr = ballBounceSpeed;
approachAngle_tr = ballApproachAngleDegs;

eyeDataTime_fr = eyeDataTime; % Bad values.

gazePixelNormX_fr = eyePos(:,1);
gazePixelNormY_fr = eyePos(:,2);

eyeQuality_Fr = eyeQuality;


elasticityList = unique(elasticity_tr);


display 'Processing quats'

viewRot_fr_d1_d2 = zeros(size(viewQUAT_WXYZ,2),4,4);
racqRot_fr_d1_d2 = zeros(size(paddleQUAT_WXYZ,2),4,4);

parfor frIdx = 1:length(viewQUAT_WXYZ)
    
    viewRot_fr_d1_d2(frIdx,:,:) = quaternion2matrix(viewQUAT_WXYZ(frIdx,:));
    racqRot_fr_d1_d2(frIdx,:,:) = quaternion2matrix(paddleQUAT_WXYZ(frIdx,:));
    %viewRot_fr_d1_d2(frIdx,:,:) = quaternion2matrix(racqQuat_fr_quat);
    
end


display 'Done processing quats'


%%
display('FIX: In processTextData - Eye data time is hacked! ')
eyeDataTime_fr = eyeDataTime_fr-eyeDataTime_fr(1);

eyeDataTime_fr = [sceneTime_fr(1); (repmat(sceneTime_fr(1),numel(eyeDataTime_fr),1) + eyeDataTime_fr)];
eyeDataTime_fr(end) = [];

[uniqueEyeTime uniqueEyeDataFr J] = unique(eyeDataTime_fr);

[gazePixelNormX_fr] = interp1( uniqueEyeTime, gazePixelNormX_fr(uniqueEyeDataFr),sceneTime_fr,'nearest');
[gazePixelNormY_fr] = interp1( uniqueEyeTime, gazePixelNormY_fr(uniqueEyeDataFr ),sceneTime_fr,'nearest');
[eyeQuality_Fr] = interp1( uniqueEyeTime, eyeQuality_Fr(uniqueEyeDataFr ),sceneTime_fr,'nearest');

[shiftedEyeTime_fr] = interp1( uniqueEyeTime, uniqueEyeTime,sceneTime_fr,'nearest');

eyeDataTime_fr = shiftedEyeTime_fr;


% 0 The user has selected to use the glint-pupil vector method and both features are successfully located.
% 1 The user has selected to use the pupil only method and the pupil was successfully located
% 2 The user has selected to use the glint-pupil vector method but the glint was not successfully located. Defaults to pupil only method for data recorded.
% 3 In either the pupil only or glint-pupil vector method, the pupil exceeded criteria limits set.
% 4 In either the pupil only or glint-pupil vector method, the pupil could not be fit with an ellipse.
% 5 In either the pupil only or glint-pupil vector method, the pupil scan threshold failed.


%%% QUATERNIONS 
% Reformat - Vizard exports in WXYZ
% Reformat - Matlab wants XYZW

%viewQuat_fr_quat = [viewQUAT_XYZW(:,4) viewQUAT_XYZW(:,1:3)];
%racqQuat_fr_quat = [paddleQUAT_XYZW(:,4) paddleQUAT_XYZW(:,1:3)];

%viewQUAT_WXYZ(:,1) = -viewQUAT_WXYZ(:,1);
%paddleQUAT_WXYZ(:,1) = -paddleQUAT_WXYZ(:,1);

% % No match in new
% inCalibrateBool
% initialVelocity_XYZ
% ballOnPaddlePos_XYZ;
% ballDiameter
% ballGravity
% ballPassingLoc
% ballLaunchDistance
% ballLaunchHeight
% 
% % No match in old
% % movieID_fr
% %ballQuat_fr_quat
% sceneClockTime_fr
% trialType_tr
% viewRot_fr_d1_d2
% racqVel_fr_xyz

% stackVarNames_var =  {'','ballPix_fr_xy','','ballQuat_fr_quat','','',...
%     'drawBallBool_fr','','','eyeDataTime_fr','eyeDuration_fr','eyePicTime_fr','gazePixelNormX_fr','gazePixelNormY_fr',,'numElasticities',
% 'numRepsType1_bl','numRepsType2_bl','numTrials_blk','numBlocks','';};

