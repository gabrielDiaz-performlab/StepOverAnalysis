

trIdx = 5;
frIdx = bounceFrame_tr(trIdx);

tempEyeRotationList = -20:.1: -10;

eyeRotError_rotIdx = [];

for eyeRotIdx = 1:numel(tempEyeRotationList )
    
    tempEyeRotation = tempEyeRotationList(eyeRotIdx);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% EIH Ball angles from angle data
    
    rotateLeftEyeMat = [ cos(tempEyeRotation*(pi/180)) 0 -sin(tempEyeRotation*(pi/180)) 0; 0 1 0 0 ; sin(tempEyeRotation*(pi/180)) 0 cos(tempEyeRotation*(pi/180)) 0; 0 0 0 1];
    lEyeRotandOffsetMat_d1_d2 = squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat * lEyeOffsetMat;
        
    lEyePosRelToView_xyz =  squeeze(lEyeRotandOffsetMat_d1_d2 * [0 0  0 1]');
    leftEyeInWorld_xyz = lEyePosRelToView_xyz(1:3)' + viewPos_fr_xyz(frIdx,:);
    
    %ball_xyz = ballPos_fr_xyz(frIdx,:);
    %ballFromDegsVecNorm = (ball_xyz - leftEyeInWorld_xyz) ./ norm(ball_xyz - leftEyeInWorld_xyz);
    
    % Left eye forward
    lEyeForward = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 0 -1 0]';
    lEyeForwardVecNorm = lEyeForward(1:3)./ norm(lEyeForward(1:3));
    
    %% Head up
    
    headUpVec_xyz   = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 1  0 0]';
    headUpVecNorm = headUpVec_xyz(1:3) ./ norm(headUpVec_xyz(1:3));
    
    % Set Axes
    H = cross((lEyeForwardVecNorm(1:3)),headUpVecNorm(1:3)' ) ./ norm(cross((lEyeForwardVecNorm(1:3)),headUpVecNorm(1:3)' ));
    U = cross(H,lEyeForwardVecNorm(1:3));
    
    %ballFromDegsTheta=    atan2( dot(ballFromDegsVecNorm,H),dot(ballFromDegsVecNorm,lEyeForwardVecNorm(1:3))) * (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% EIH Ball angles from angle data
    
    %bsX= (ballPix_fr_xy(frIdx,1)./arrPixX - .5) .* nearW;
    %bsY= (ballPix_fr_xy(frIdx,2)./arrPixY - .5) .* nearH;
    %ballVectorNorm = [bsX bsY 1]./norm([bsX bsY 1]);
    %ballVectorNorm = [-bsX 1 bsY ]./norm([-bsX 1 bsY]);
    
    ballThetaFromPix =   atan2(ballVectorNorm(1),-ballVectorNorm(3)) * (180/pi);
    
    eyeRotError_rotIdx(eyeRotIdx) = abs(ballFromDegsTheta-ballThetaFromPix);
    
end
%%

[junk minIdx] =min(eyeRotError_rotIdx);

eyeRotation = tempEyeRotationList(minIdx) * (pi/180);
fprintf('\n**Eyerotation set to \n%1.1f degs**\n',eyeRotation .* (180/pi))

save(rawDataFileString,'eyeRotation', '-append');