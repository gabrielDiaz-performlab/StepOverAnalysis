
display('Processing data...')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Find experiment events

numFrames = numel(movieID_fr);
blockTransition =  find(eventFlag_fr==3);
%find(eventFlag_fr==5);

trialStartFr_tr = find(eventFlag_fr == 1);
trialEndFr_tr =   union( find(eventFlag_fr == 2), find(eventFlag_fr == 3));
blkTransition_bl = [trialStartFr_tr(1)-1; blockTransition];

%%

%%

clear blockTransition
numBlocks = numel(blkTransition_bl)-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find physical events

hitWallFrameList_idx = find(eventFlag_fr == 4);
bounceFrame_tr = find(eventFlag_fr == 5);
ballCaught_tr = find(eventFlag_fr == 6);

%display('***** NOT CHECKING STARTS AND ENDS *****')
fprintf('\n\n***** CHECKING STARTS AND ENDS *****\n')
validateTrialOrder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find end of trial / block

clear ballVelZ_blk_zdot_tr trByZdot_zdot_blk_x trInBlk_blk velZCount trialEndFr_blk_Ctr trialStartFr_blk_Ctr

for blkIdx = 1:numBlocks
    
    trialStartFr_blk_Ctr(blkIdx,:) = {intersect( trialStartFr_tr(trialStartFr_tr > blkTransition_bl(blkIdx)),...
        trialStartFr_tr (trialStartFr_tr < blkTransition_bl(blkIdx+1)))};
    
    trialEndFr_blk_Ctr(blkIdx,:) = {intersect( trialEndFr_tr(trialEndFr_tr > blkTransition_bl(blkIdx)),...
        trialEndFr_tr(trialEndFr_tr<= blkTransition_bl(blkIdx+1)))};
    
    trInBlk_blk(blkIdx,:) = (1 + numTrials_blk(blkIdx)*(blkIdx-1)) : numTrials_blk(blkIdx)*(blkIdx);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculate ball and gaze SX, SY

% SX AND SY denotes location on the screen.

% gazeSX_fr = (gazePixelNormX_fr - .5) .* nearW;
% gazeSY_fr = -(gazePixelNormY_fr - .5) .* nearH;

%ballSX_fr  = (ballPix_fr_xy(:,1)./arrPixX - .5) .* nearW;
%ballSY_fr  = (ballPix_fr_xy(:,2)./arrPixY - .5) .* nearH;

gazePixX_fr = gazePixelNormX_fr .* arrPixX;
gazePixY_fr = gazePixelNormY_fr .* arrPixY;

gazeSX_fr = (gazePixelNormX_fr - .5) .* nearW;
gazeSY_fr = -(gazePixelNormY_fr - .5) .* nearH;

ballSX_fr  = (ballPix_fr_xy(:,1)./arrPixX - .5) .* nearW;
ballSY_fr  = (ballPix_fr_xy(:,2)./arrPixY - .5) .* nearH;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Filter!
display('* Applying a median and lowpass Guassian filter to the gaze SX and SY')

if( rem(gaussFiltSize,2) ~= 1 || rem(medFiltSize,2) ~= 1)
    beep
    display('Error! s must be an odd number.')
    return
end


gazeFiltSX_fr= rballDataFilter(gazeSX_fr);
gazeFiltSY_fr= rballDataFilter(gazeSY_fr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Offset gaze data to compensate for misalignments

if(gazeFrameOffset > 0)
    display(sprintf('*** Gaze data is offset by %1.0f frames***',gazeFrameOffset));
    gazePixFiltX_fr = [zeros(gazeFrameOffset,1); gazePixFiltX_fr(1:end-gazeFrameOffset)];
    gazePixFiltY_fr = [zeros(gazeFrameOffset,1); gazePixFiltY_fr(1:end-gazeFrameOffset)];
elseif(gazeFrameOffset < 0)
    gazePixFiltX_fr = [gazePixFiltX_fr(gazeFrameOffset:end); zeros(gazeFrameOffset,1)];
    gazePixFiltY_fr = [gazePixFiltY_fr(gazeFrameOffset:end); zeros(gazeFrameOffset,1)];
    display(sprintf('*** Gaze data is offset by %1.0f frames***',gazeFrameOffset));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculating gaze location, ball location,

display('* Calculating object locations and offset from gaze in visual degrees')

clear eye2BallDist_fr

numFrames = size(viewRot_fr_d1_d2,1);

eiwRadsX_fr = zeros(numFrames,1);
eiwRadsY_fr = zeros(numFrames,1);
eye2ballDist_fr = zeros(numFrames,1);
e2bWorldRadsX_fr = zeros(numFrames,1);
e2bWorldRadsY_fr= zeros(numFrames,1);
g2BallDegs_fr = zeros(numFrames,1);
g2BounceDegs_fr = zeros(numFrames,1);
g2ballTheta_fr = zeros(numFrames,1);
g2ballPhi_fr = zeros(numFrames,1);

lEyeForwardDir_fr_xyz  = zeros(numFrames,3);
headUpDir_fr_xyz = zeros(numFrames,3);
gazeDir_fr_xyz = zeros(numFrames,3);
ballDir_fr_xyz = zeros(numFrames,3);
bptDir_fr_xyz = zeros(numFrames,3);

ball2BptBptCentThetaDegs_fr = zeros(numFrames,3);
ball2BptBptCentPhiDegs_fr= zeros(numFrames,3);
g2bptBptCentThetaDegs_fr= zeros(numFrames,3);
g2bptBptCentPhiDegs_fr= zeros(numFrames,3);

%lEyeRotandOffsetMat_fr_d1_d2 = zeros(numFrames,);
leftEyeInWorld_fr_xyz = zeros(numFrames,3);

gazeVecNorm = 0;
ballVecNorm = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Calculate eye rotation and offset matrices

% B/C the helmet's displays are not frontoparallel, there is a software
% rotation to prevent sheering. These matrices are used to unrotate the screen.

lEyeOffsetMat = eye(4,4);
lEyeOffsetMat(1,4) = - eyeOffset;

findEyeRot

rotateLeftEyeMat = [ cos(eyeRotation) 0 -sin(eyeRotation) 0; 0 1 0 0 ; sin(eyeRotation) 0 cos(eyeRotation) 0; 0 0 0 1];
lEyeRotandOffsetMat_fr_d1_d2 = zeros(numFrames,4,4);

clear prevballVecNorm prevGazeVectorNorm

keyboard

%%
parfor frIdx = 1:numFrames
    
    rotateLeftEyeMat = [ cos(eyeRotation) 0 -sin(eyeRotation) 0; 0 1 0 0 ; sin(eyeRotation) 0 cos(eyeRotation) 0; 0 0 0 1];
    lEyeRotandOffsetMat_d1_d2 = squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat * lEyeOffsetMat;
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Left eye forward
    
    lEyeForward = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 0 -1 0]';
    lEyeForwardVecNorm = (lEyeForward./ norm(lEyeForward ))';
    lEyeForwardVecNorm(4) = [];
    
    lEyeForwardDir_fr_xyz(frIdx,:) = lEyeForwardVecNorm;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Head up
    
    headUpVec_xyz   = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 1  0 0]';
    headUpVecNorm = (headUpVec_xyz ./ norm(headUpVec_xyz ))';
    headUpVecNorm(4) =[];
    
    headUpDir_fr_xyz(frIdx,:) = headUpVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gaze in world
    
    gazeWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [gazeFiltSX_fr(frIdx) gazeFiltSY_fr(frIdx) -1 0]';
    gazeVecNorm = gazeWorldDir_xyz ./ norm(gazeWorldDir_xyz );
    gazeVecNorm(4) = [];
    
    gazeDir_fr_xyz(frIdx,:) = gazeVecNorm;
    
    rawGazeWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [gazeSX_fr(frIdx) gazeSY_fr(frIdx) -1 0]';
    rawGazeVecNorm = rawGazeWorldDir_xyz ./ norm(rawGazeWorldDir_xyz );
    rawGazeVecNorm(4) = [];
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Eye in world coordinates
    
    eiwRadsX_fr(frIdx) =  atan2(gazeVecNorm(1),gazeVecNorm(2));
    eiwRadsY_fr(frIdx) =  asin(gazeVecNorm(3));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eye to ball
    
    ballWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [ballSX_fr(frIdx) ballSY_fr(frIdx) -1 0]';
    ballVecNorm = (ballWorldDir_xyz ./ norm(ballWorldDir_xyz) );
    ballVecNorm(4) = [];
    
    ballDir_fr_xyz(frIdx,:) = ballVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Ball in world coordinates
    
    e2bWorldRadX_fr(frIdx) =  atan2(ballVecNorm(1),ballVecNorm(2));
    e2bWorldRadY_fr(frIdx) =  asin(ballVecNorm(3)) ;
    
    e2bWorldDegsX_fr(frIdx) =  atan2(ballVecNorm(1),ballVecNorm(2)) .* (180/pi);
    e2bWorldDegsY_fr(frIdx) =  asin(ballVecNorm(3))  .* (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Bouncepoint
    
    lEyePosRelToView_xyz =  squeeze(lEyeRotandOffsetMat_d1_d2 * [0 0  0 1]');
    leftEyeInWorld_xyz = lEyePosRelToView_xyz(1:3)' + viewPos_fr_xyz(frIdx,:);
    leftEyeInWorld_fr_xyz(frIdx,:) = leftEyeInWorld_xyz ;
    
    trIdx = find( trialEndFr_tr > frIdx, 1, 'first');
    
    if(isempty(trIdx)) trIdx = sum( numTrials_blk); end
    
    bounce_xyz = [ballBounceX_tr(trIdx) ballBounceY_tr(trIdx) ballBounceZ_tr(trIdx)];
    bptVecNorm = (bounce_xyz - leftEyeInWorld_xyz) ./ norm(bounce_xyz - leftEyeInWorld_xyz);
    
    bptDir_fr_xyz(frIdx,:) = bptVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Gaze distance in one dimension along sphere
    
    g2BallDegs_fr(frIdx)   = acos( dot(ballVecNorm,gazeVecNorm) ) .* (180/pi);
    g2BounceDegs_fr(frIdx) = acos( dot(bptVecNorm,gazeVecNorm') ) .* (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Angular distance from gaze to the ball
    
    % H is a vector to teh right of the gaze vector - perp to worldUpNorm
    % U vector is "up" on the plane perpendicular to the point of gaze
    % [0 0 1]' is the world up norm
    
    H = cross(gazeVecNorm,[0 0 1]' ) ./ norm(cross(gazeVecNorm,[0 0 1]' ));
    U = cross(H,gazeVecNorm);
    
    g2ballTheta_fr(frIdx) =    atan2( dot(ballVecNorm,H),dot(ballVecNorm,gazeVecNorm)) * (180/pi);
    g2ballPhi_fr(frIdx)     =    atan2( dot(ballVecNorm,U),dot(ballVecNorm,gazeVecNorm)) * (180/pi);
    
    %%  Angular distance from gaze to the bouncepoint
    
    g2bounceTheta_fr(frIdx) =    atan2( dot(bptVecNorm,H),dot(bptVecNorm,gazeVecNorm)) * (180/pi);
    g2bouncePhi_fr(frIdx)     =    atan2( dot(bptVecNorm,U),dot(bptVecNorm,gazeVecNorm)) * (180/pi);
    
    %% angular distance from the ball to the bouncepoint
    
    H = cross(ballVecNorm,[0 0 1]' ) ./ norm(cross(ballVecNorm,[0 0 1]' ));
    U = cross(H,ballVecNorm);
    
    ball2bounceTheta_fr(frIdx) =    atan2( dot(bptVecNorm,H),dot(bptVecNorm,ballVecNorm)) * (180/pi);
    ball2bouncePhi_fr(frIdx)     =    atan2( dot(bptVecNorm,U),dot(bptVecNorm,ballVecNorm)) * (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Project to plane centered at and perpendicular to the bouncepoint
    
    H = cross((bptVecNorm),[0 0 1]' ) ./ norm(cross((bptVecNorm),[0 0 1]' ));
    U = cross(H,(bptVecNorm));
    
   %ball2BptBptCentThetaRads_fr(frIdx) =    dot(ballVecNorm,H);
    %ball2BptBptCentPhiRads_fr(frIdx) =    dot(ballVecNorm,U);
    
    ball2BptBptCentThetaDegs_fr(frIdx) = atan2( dot(ballVecNorm,H),dot(ballVecNorm,bptVecNorm)) * (180/pi);
    ball2BptBptCentPhiDegs_fr(frIdx) = atan2( dot(ballVecNorm,U),dot(ballVecNorm,bptVecNorm)) * (180/pi);
    
    g2bptBptCentThetaDegs_fr(frIdx) = atan2( dot(gazeVecNorm,H),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);
    g2bptBptCentPhiDegs_fr(frIdx) = atan2( dot(gazeVecNorm,U),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate pursuit gain.
    
    if( frIdx<=1+gazeFrameOffset)
        ballVectorVelDegs_fr(frIdx) = 0;
        prevballVecNorm = ballVecNorm;
        prevGazeVectorNorm = gazeVecNorm;
        prevRawGazeVectorNorm = rawGazeVecNorm;
    else
        
        if( prevballVecNorm == ballVecNorm)
            ballVecLengthOnUnitSph_fr(frIdx) = 0;
            gazeVecLengthParallelToBall_fr(frIdx) = 0; % ball is stationary.
            
            gazeVelDegsSec_fr(frIdx)   = 0;
            rawGazeVelDegsSec_fr(frIdx)   = 0;
        else
            
            d  =  (ballVecNorm - prevballVecNorm) ./ norm(ballVecNorm - prevballVecNorm);
            % the length of ball movement when projected onto a plane
            % orthogonal to the eye
            h = dot(gazeVecNorm - prevGazeVectorNorm,d)* d;
            
            % j - length of the component of the gaze vector parallel to the ball vector
            j = (prevGazeVectorNorm + h) ./ norm( prevGazeVectorNorm+h)';
            
            ballVecLengthOnUnitSph_fr(frIdx) = acos( dot(prevballVecNorm,ballVecNorm)) .* (180/pi);
            gazeVecLengthParallelToBall_fr(frIdx) = acos ( dot(prevGazeVectorNorm,j)) .* (180/pi);
            
            if(  dot(gazeVecNorm - prevGazeVectorNorm,d) < 0 )
                gazeVecLengthParallelToBall_fr(frIdx) = -gazeVecLengthParallelToBall_fr(frIdx);
            end
            
            
            %  Gaze velocity
            gazeVelDegsSec_fr(frIdx) = acos( dot(gazeVecNorm,prevGazeVectorNorm)) .* (180/pi);
            rawGazeVelDegsSec_fr(frIdx) = acos( dot(rawGazeVecNorm,prevRawGazeVectorNorm)) .* (180/pi);
            
            ballVecNormXYZ_fr(:,frIdx) = ballVecNorm;
            gazeVectorNormXYZ_fr(:,frIdx) = gazeVecNorm;
            
            prevballVecNorm = ballVecNorm;
            prevGazeVectorNorm = gazeVecNorm;
            prevRawGazeVectorNorm = rawGazeVecNorm;
            
        end
    end
    
    
end

%%
for frIdx = 1:numFrames
    
    clear ballScreenLoc_xyz gazeScreenLoc_xyz gazePoint_xyz
    clear headUpVec_xyz eye2ballDist_xyz ballVecNorm
    
    rotateLeftEyeMat = [ cos(eyeRotation) 0 -sin(eyeRotation) 0; 0 1 0 0 ; sin(eyeRotation) 0 cos(eyeRotation) 0; 0 0 0 1];
    lEyeRotandOffsetMat_d1_d2 = squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat * lEyeOffsetMat;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Left eye forward
    
    lEyeForward = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 0 -1 0]';
    lEyeForwardVecNorm = (lEyeForward./ norm(lEyeForward ))';
    lEyeForwardVecNorm(4) = [];
    
    lEyeForwardDir_fr_xyz(frIdx,:) = lEyeForwardVecNorm;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Head up
    
    headUpVec_xyz   = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 1  0 0]';
    headUpVecNorm = (headUpVec_xyz ./ norm(headUpVec_xyz ))';
    headUpVecNorm(4) =[];
    
    headUpDir_fr_xyz(frIdx,:) = headUpVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gaze in world
    
    gazeWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [gazeFiltSX_fr(frIdx) gazeFiltSY_fr(frIdx) -1 0]';
    gazeVecNorm = gazeWorldDir_xyz ./ norm(gazeWorldDir_xyz );
    gazeVecNorm(4) = [];
    
    gazeDir_fr_xyz(frIdx,:) = gazeVecNorm;
    
    rawGazeWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [gazeSX_fr(frIdx) gazeSY_fr(frIdx) -1 0]';
    rawGazeVecNorm = rawGazeWorldDir_xyz ./ norm(rawGazeWorldDir_xyz );
    rawGazeVecNorm(4) = [];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Eye in world coordinates
    
    eiwRadsX_fr(frIdx) =  atan2(gazeVecNorm(1),gazeVecNorm(2));
    eiwRadsY_fr(frIdx) =  asin(gazeVecNorm(3));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eye to ball
    
    ballWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [ballSX_fr(frIdx) ballSY_fr(frIdx) -1 0]';
    ballVecNorm = (ballWorldDir_xyz ./ norm(ballWorldDir_xyz) );
    ballVecNorm(4) = [];
    
    ballDir_fr_xyz(frIdx,:) = ballVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Ball in world coordinates
    
    e2bWorldRadX_fr(frIdx) =  atan2(ballVecNorm(1),ballVecNorm(2));
    e2bWorldRadY_fr(frIdx) =  asin(ballVecNorm(3)) ;
    
    e2bWorldDegsX_fr(frIdx) =  atan2(ballVecNorm(1),ballVecNorm(2)) .* (180/pi);
    e2bWorldDegsY_fr(frIdx) =  asin(ballVecNorm(3))  .* (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Bouncepoint
    
    lEyePosRelToView_xyz =  squeeze(lEyeRotandOffsetMat_d1_d2 * [0 0  0 1]');
    leftEyeInWorld_xyz = lEyePosRelToView_xyz(1:3)' + viewPos_fr_xyz(frIdx,:);
    leftEyeInWorld_fr_xyz(frIdx,:) = leftEyeInWorld_xyz ;
    
    trIdx = find( trialEndFr_tr > frIdx, 1, 'first');
    
    if(isempty(trIdx)) trIdx = sum( numTrials_blk); end
    
    bounce_xyz = [ballBounceX_tr(trIdx) ballBounceY_tr(trIdx) ballBounceZ_tr(trIdx)];
    bptVecNorm = (bounce_xyz - leftEyeInWorld_xyz) ./ norm(bounce_xyz - leftEyeInWorld_xyz);
    
    bptDir_fr_xyz(frIdx,:) = bptVecNorm;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Gaze distance in one dimension along sphere
    
    g2BallDegs_fr(frIdx)   = acos( dot(ballVecNorm,gazeVecNorm) ) .* (180/pi);
    g2BounceDegs_fr(frIdx) = acos( dot(bptVecNorm,gazeVecNorm') ) .* (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Angular distance from gaze to the ball
    
    % H is a vector to teh right of the gaze vector - perp to worldUpNorm
    % U vector is "up" on the plane perpendicular to the point of gaze
    % [0 0 1]' is the world up norm
    
    H = cross(gazeVecNorm,[0 0 1]' ) ./ norm(cross(gazeVecNorm,[0 0 1]' ));
    U = cross(H,gazeVecNorm);
    
    g2ballTheta_fr(frIdx) =    atan2( dot(ballVecNorm,H),dot(ballVecNorm,gazeVecNorm)) * (180/pi);
    g2ballPhi_fr(frIdx)     =    atan2( dot(ballVecNorm,U),dot(ballVecNorm,gazeVecNorm)) * (180/pi);
    
    %%  Angular distance from gaze to the bouncepoint
    
    g2bounceTheta_fr(frIdx) =    atan2( dot(bptVecNorm,H),dot(bptVecNorm,gazeVecNorm)) * (180/pi);
    g2bouncePhi_fr(frIdx)     =    atan2( dot(bptVecNorm,U),dot(bptVecNorm,gazeVecNorm)) * (180/pi);
    
    %% angular distance from the ball to the bouncepoint
    
    H = cross(ballVecNorm,[0 0 1]' ) ./ norm(cross(ballVecNorm,[0 0 1]' ));
    U = cross(H,ballVecNorm);
    
    ball2bounceTheta_fr(frIdx) =    atan2( dot(bptVecNorm,H),dot(bptVecNorm,ballVecNorm)) * (180/pi);
    ball2bouncePhi_fr(frIdx)     =    atan2( dot(bptVecNorm,U),dot(bptVecNorm,ballVecNorm)) * (180/pi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Project to plane centered at and perpendicular to the bouncepoint
    
    H = cross((bptVecNorm),[0 0 1]' ) ./ norm(cross((bptVecNorm),[0 0 1]' ));
    U = cross(H,(bptVecNorm));
    
   %ball2BptBptCentThetaRads_fr(frIdx) =    dot(ballVecNorm,H);
    %ball2BptBptCentPhiRads_fr(frIdx) =    dot(ballVecNorm,U);
    
    ball2BptBptCentThetaDegs_fr(frIdx) = atan2( dot(ballVecNorm,H),dot(ballVecNorm,bptVecNorm)) * (180/pi);
    ball2BptBptCentPhiDegs_fr(frIdx) = atan2( dot(ballVecNorm,U),dot(ballVecNorm,bptVecNorm)) * (180/pi);
    
    g2bptBptCentThetaDegs_fr(frIdx) = atan2( dot(gazeVecNorm,H),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);
    g2bptBptCentPhiDegs_fr(frIdx) = atan2( dot(gazeVecNorm,U),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate pursuit gain.
    
    clear h d j H U
    
    if( frIdx<=1+gazeFrameOffset)
        ballVectorVelDegs_fr(frIdx) = 0;
        prevballVecNorm = ballVecNorm;
        prevGazeVectorNorm = gazeVecNorm;
        prevRawGazeVectorNorm = rawGazeVecNorm;
    else
        
        if( prevballVecNorm == ballVecNorm)
            ballVecLengthOnUnitSph_fr(frIdx) = 0;
            gazeVecLengthParallelToBall_fr(frIdx) = 0; % ball is stationary.
            
            gazeVelDegsSec_fr(frIdx)   = 0;
            rawGazeVelDegsSec_fr(frIdx)   = 0;
        else
            
            % Define the vector between these points
            % Direction that the ball has moved as perceived by the eye
            d  =  (ballVecNorm - prevballVecNorm) ./ norm(ballVecNorm - prevballVecNorm);
            % the length of ball movement when projected onto a plane
            % orthogonal to the eye
            h = dot(gazeVecNorm - prevGazeVectorNorm,d)* d;
            
            % j - length of the component of the gaze vector parallel to the ball vector
            j = (prevGazeVectorNorm + h) ./ norm( prevGazeVectorNorm+h)';
            
            ballVecLengthOnUnitSph_fr(frIdx) = acos( dot(prevballVecNorm,ballVecNorm)) .* (180/pi);
            gazeVecLengthParallelToBall_fr(frIdx) = acos ( dot(prevGazeVectorNorm,j)) .* (180/pi);
            
            if(  dot(gazeVecNorm - prevGazeVectorNorm,d) < 0 )
                gazeVecLengthParallelToBall_fr(frIdx) = -gazeVecLengthParallelToBall_fr(frIdx);
            end
            
            
            %  Gaze velocity
            gazeVelDegsSec_fr(frIdx) = acos( dot(gazeVecNorm,prevGazeVectorNorm)) .* (180/pi);
            rawGazeVelDegsSec_fr(frIdx) = acos( dot(rawGazeVecNorm,prevRawGazeVectorNorm)) .* (180/pi);
            
            
            %unfilteredGazeScreenLoc_xyz (frIdx)  = acos( dot(gazeVecNorm,prevGazeVectorNorm)) .* (180/pi);
            
            ballVecNormXYZ_fr(:,frIdx) = ballVecNorm;
            gazeVectorNormXYZ_fr(:,frIdx) = gazeVecNorm;
            
            prevballVecNorm = ballVecNorm;
            prevGazeVectorNorm = gazeVecNorm;
            prevRawGazeVectorNorm = rawGazeVecNorm;
            
        end
    end
    
    clear h d j H U
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Convert from rads to degs

eiwDegsX_fr = eiwRadsX_fr * (180/pi);
eiwDegsY_fr = eiwRadsY_fr * (180/pi);

%e2bWorldDegsX_fr  = e2bWorldRadsX_fr * (180/pi);
%e2bWorldDegsY_fr  = e2bWorldRadsY_fr * (180/pi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Adjust gaze error measurements for optical ball size

eye2BallDist_fr = sqrt(sum( ((leftEyeInWorld_fr_xyz - ballPos_fr_xyz ).^2),2))';

ballRadiusRad_fr =  atan2( (.5*ballDiameter),eye2BallDist_fr )';
ballRadiusDeg_fr = (180/pi) .* ballRadiusRad_fr;

e2bWorldRadsY_fr(find( abs(e2bWorldRadsY_fr) <= ballRadiusRad_fr)) = 0;
e2bWorldRadsY_fr( find(e2bWorldRadsY_fr(frIdx)>0) ) = e2bWorldRadsY_fr( find(e2bWorldRadsY_fr(frIdx)>0) )- ballRadiusRad_fr( find(e2bWorldRadsY_fr(frIdx)>0) );
e2bWorldRadsY_fr( find(e2bWorldRadsY_fr(frIdx)<0) ) = e2bWorldRadsY_fr( find(e2bWorldRadsY_fr(frIdx)<0) )+ballRadiusRad_fr( find(e2bWorldRadsY_fr(frIdx)<0) );

e2bWorldRadsX_fr(find( abs(e2bWorldRadsX_fr) <= ballRadiusRad_fr)) = 0;
e2bWorldRadsX_fr( find(e2bWorldRadsX_fr(frIdx)>0) ) = e2bWorldRadsX_fr( find(e2bWorldRadsX_fr(frIdx)>0) ) - ballRadiusRad_fr( find(e2bWorldRadsX_fr(frIdx)>0) );
e2bWorldRadsX_fr( find(e2bWorldRadsX_fr(frIdx)<0) ) = e2bWorldRadsX_fr( find(e2bWorldRadsX_fr(frIdx)<0) ) + ballRadiusRad_fr( find(e2bWorldRadsX_fr(frIdx)<0) );

g2ballTheta_fr(find( abs(g2ballTheta_fr) <= ballRadiusDeg_fr)) = 0;
g2ballTheta_fr( find(g2ballTheta_fr>0) ) = g2ballTheta_fr( find(g2ballTheta_fr>0) ) - ballRadiusDeg_fr( find(g2ballTheta_fr>0) );
g2ballTheta_fr( find(g2ballTheta_fr<0) ) = g2ballTheta_fr( find(g2ballTheta_fr<0) ) + ballRadiusDeg_fr( find(g2ballTheta_fr<0) );

g2ballPhi_fr(find( abs(g2ballPhi_fr) <= ballRadiusDeg_fr)) = 0;
g2ballPhi_fr( find(g2ballPhi_fr>0) ) = g2ballPhi_fr( find(g2ballPhi_fr>0) ) - ballRadiusDeg_fr( find(g2ballPhi_fr>0) );
g2ballPhi_fr( find(g2ballPhi_fr<0) ) = g2ballPhi_fr( find(g2ballPhi_fr<0) ) + ballRadiusDeg_fr( find(g2ballPhi_fr<0) );

g2BallDegs_fr( find( g2BallDegs_fr <= ballRadiusDeg_fr)) = 0;
g2BallDegs_fr( find( g2BallDegs_fr>0) ) = g2BallDegs_fr( find(g2BallDegs_fr>0) ) - ballRadiusDeg_fr( find(g2BallDegs_fr>0) );

%%

g2BounceDegs_fr = g2BounceDegs_fr';
ballRadiusDeg_fr = ballRadiusDeg_fr';

%%

g2bounceTheta_fr(find( abs(g2bounceTheta_fr) <= ballRadiusDeg_fr)) = 0;
g2bounceTheta_fr( find(g2bounceTheta_fr>0) ) = g2bounceTheta_fr( find(g2bounceTheta_fr>0) ) - ballRadiusDeg_fr( find(g2bounceTheta_fr>0) );
g2bounceTheta_fr( find(g2bounceTheta_fr<0) ) = g2bounceTheta_fr( find(g2bounceTheta_fr<0) ) + ballRadiusDeg_fr( find(g2bounceTheta_fr<0) );

g2bouncePhi_fr(find( abs(g2bouncePhi_fr) <= ballRadiusDeg_fr)) = 0;
g2bouncePhi_fr( find(g2bouncePhi_fr>0) ) = g2bouncePhi_fr( find(g2bouncePhi_fr>0) ) - ballRadiusDeg_fr( find(g2bouncePhi_fr>0) );
g2bouncePhi_fr( find(g2bouncePhi_fr<0) ) = g2bouncePhi_fr( find(g2bouncePhi_fr<0) ) + ballRadiusDeg_fr( find(g2bouncePhi_fr<0) );

g2BounceDegs_fr(find( abs(g2BounceDegs_fr) <= ballRadiusDeg_fr)) = 0;
g2BounceDegs_fr( find(g2BounceDegs_fr>0) ) = g2BounceDegs_fr( find(g2BounceDegs_fr>0) ) - ballRadiusDeg_fr( find(g2BounceDegs_fr>0) );
g2BounceDegs_fr( find(g2BounceDegs_fr<0) ) = g2BounceDegs_fr( find(g2BounceDegs_fr<0) ) + ballRadiusDeg_fr( find(g2BounceDegs_fr<0) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Filter eiw data .
%%  At this point, data has been filtered twice.

%display('* Applying a median and lowpass Guassian filter to EIW data')
%eiwFiltDegsX_fr = rballDataFilter(eiwDegsX_fr);
%eiwFiltDegsY_fr = rballDataFilter(eiwDegsY_fr);

%display('* Applying a median and lowpass Guassian filter to E2B data')
%e2bWorldFiltDegsX_fr = rballDataFilter(e2bWorldDegsX_fr);
%e2bWorldFiltDegsY_fr = rballDataFilter(e2bWorldDegsY_fr);

eiwFiltDegsX_fr = (eiwDegsX_fr);
eiwFiltDegsY_fr = (eiwDegsY_fr);

e2bWorldFiltDegsX_fr = e2bWorldDegsX_fr;
e2bWorldFiltDegsY_fr = e2bWorldDegsY_fr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculate pursuit gain

e2bVelDegSec_fr = compute_vel(eyeDataTime_fr ,[e2bWorldDegsX_fr; e2bWorldDegsY_fr]');
pursuitGain_fr =  (rballDataFilter(gazeVecLengthParallelToBall_fr))./(rballDataFilter(ballVecLengthOnUnitSph_fr));

sceneDur_fr = [0; diff(sceneTime_fr)]';

% Filter velocity measures
% Convert from degs/frame to degs/second
ballVectorVelDegs_fr = rballDataFilter( ballVecLengthOnUnitSph_fr .* (1./sceneDur_fr));
gazeVelParToBallDegsSec_fr = rballDataFilter( gazeVecLengthParallelToBall_fr .* (1./sceneDur_fr));

gazeVelDegsSec_fr  = ( gazeVelDegsSec_fr .* (1./sceneDur_fr));
rawGazeVelDegsSec_fr = ( rawGazeVelDegsSec_fr .* (1./sceneDur_fr));

%  Convolve data with saccade kernel for saccade analysis
convGazeVelDegsSec_fr  = conv( gazeVelDegsSec_fr, (filterKernel./sum(filterKernel)),'same');

display('Done processing data!  Bleep bloop bloop.')

%%  Hand velocity

handVel_fr = sqrt( sum(racqVel_fr_xyz().^2,2) );
handPlanarVel_fr = sqrt( sum(racqVel_fr_xyz(:,[1 2]).^2,2) );

filter = fspecial('gaussian',[handFiltWidth 1], handFiltSD);  % gaussian kernel where s= size of contour
handVelFilt_fr  = conv(handVel_fr ,filter,'same');

handPlanarVelFilt_fr = conv(handPlanarVel_fr ,filter,'same');
handPlanarVelFilt_tr  = handPlanarVelFilt_fr(bounceFrame_tr);

%%

% close all
%
% framesAfterBounce = 60;
%
%
% figure(100);
% set(gcf,'WindowStyle','docked')
%
% for idx = 59
%
%     plotIdx = (hitFloorIdx_tr(idx)-60):hitFloorIdx_tr(idx)+framesAfterBounce;
%     plotID = movieID_fr( plotIdx);
%
%     subplot(2,2,1:2)
%     hold on
%     cla
%     axis([plotID(1) plotID(end) 0 200])
%     plot( plotID,ballVectorVelDegs_fr(plotIdx));
%     plot( plotID,gazeVelParToBallDegsSec_fr(plotIdx),'r');
%     %vline(hitFloorIdx_tr(idx)-2,'g')
%     %vline(hitFloorIdx_tr(idx)-1,'y')
%     vline(hitFloorID_tr(idx),'r')
%     x = get(gca,'XTick');
%
%     set(gca,'XTickLabel',sprintf('%3.0f|',x))
%     dcmObj = datacursormode(100);
%     set(dcmObj,'UpdateFcn',@dataTip_callback_racquetball)
%     datacursormode on
%
%     subplot(2,2,3:4)
%     hold on
%     axis([plotID(1) plotID(end) -2 2])
%     cla
%     plot(plotID,pursuitGain_fr(plotIdx))
%     hline(0)
%
%     hline( purs_e2bChangeThresh+(1-purs_e2bChangeThresh),'g',1,'-')
%     hline( purs_e2bChangeThresh-(1-purs_e2bChangeThresh),'g',1,'-')
%     vline(hitFloorID_tr(idx),'r')
%     x = get(gca,'XTick');
%     set(gca,'XTickLabel',sprintf('%3.0f|',x))
%
%     dcmObj = datacursormode(100);
%     set(dcmObj,'UpdateFcn',@dataTip_callback_racquetball)
%     datacursormode on
%
% %     figure(2)
% %     hold on
% %     plot(ballVecNormXYZ_fr(1,plotIdx),'r');
% %     plot(ballVecNormXYZ_fr(2,plotIdx),'g');
% %     plot(ballVecNormXYZ_fr(3,plotIdx),'b');
%
% end
