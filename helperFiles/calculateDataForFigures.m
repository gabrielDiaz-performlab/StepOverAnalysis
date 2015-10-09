

clear unrotatedBallPos_xyz
loadParameters


% Misc variables
numTrials = sum(numTrials_blk);
ballVelDegAtPursStart_tr = NaN(numTrials ,1);
hitLoc_tr_RaquXYZ = NaN(numTrials,3);
extrapHitTime_tr = NaN(numTrials,2);
racquAccRating_tr= NaN(numTrials,1);
racquAccRatingNorm_tr= NaN(numTrials,1);

% Distance measures
hitErr_tr = NaN(numTrials ,1);
hitErrX_tr = NaN(numTrials ,1);
hitErrZ_tr = NaN(numTrials ,1);
corrSacMag_tr = NaN(numTrials ,1);

fix2BallMinDegs_tr = NaN(numTrials ,1);
fix2BallMinTheta_tr = NaN(numTrials ,1);
fix2BallMinPhi_tr = NaN(numTrials ,1);
g2BDegsAtFixEnd_tr = NaN(numTrials ,1);
fix2BounceDegs_tr = NaN(numTrials ,1);
fix2BounceTheta_tr = NaN(numTrials ,1);
fix2BouncePhi_tr = NaN(numTrials ,1);
racquAcc_tr = NaN(numTrials ,1);
racquAccNorm_tr_xy = NaN(numTrials ,1);
fix2BallAt100_tr = NaN(numTrials ,1);

giwAtFixTheta_tr= NaN(numTrials ,1);
giwAtFixPhi_tr= NaN(numTrials ,1);

% Binary variables
hitBall_tr= zeros(numTrials ,1);

foundSacc_tr = zeros(numTrials ,1); % if there was a sacc detected around the time of bounce
foundPur_tr = zeros(numTrials ,1); % if there was ANY pursuit after the bounce

foundPredFix_tr = zeros(numTrials ,1);
foundFixAfterSacc_tr = zeros(numTrials ,1);
foundFixAfterBounce_tr = zeros(numTrials ,1);

foundPredPursuit_tr = zeros(numTrials ,1);
foundPursAfterSacc_tr = zeros(numTrials ,1);
foundPursAfterBounce_tr = zeros(numTrials ,1);


foundFixThresh_tr = zeros(numTrials ,1);
aboveTthreshBeforeFix_tr = zeros(numTrials ,1);
adjustedSacc_tr = zeros(numTrials ,1);
foundPredPursuit_tr = zeros(numTrials ,1);

% Timing variables
saccStartS2B_tr = NaN(numTrials ,1);
saccEndS2B_tr = NaN(numTrials ,1);
fixStartS2B_tr = NaN(numTrials ,1);
fixEndS2B_tr = NaN(numTrials ,1);
fixMinS2B_tr = NaN(numTrials ,1);
fixMinThreshS2B_tr = NaN(numTrials ,1);
fixStartSec_tr = NaN(numTrials ,1);
fixEndSec_tr = NaN(numTrials ,1);
fixMinSec_tr = NaN(numTrials ,1);
bounceTimeMS_tr = NaN(numTrials ,1);
pursStartMS_tr = NaN(numTrials ,1);
pursEndMS_tr = NaN(numTrials ,1);
pursStartS2B_tr = NaN(numTrials ,1);
pursEndS2B_tr = NaN(numTrials ,1);
saccEndS2B_tr = NaN(numTrials ,1);
hitRacquS2B_tr= NaN(numTrials ,1);
saccStartFr_tr = NaN(numTrials ,1);
saccEndFr_tr = NaN(numTrials ,1);
fix2BallMinFr2B_tr =  NaN(numTrials ,1);
fixMinThreshFr2B_tr = NaN(numTrials ,1);
fix2BallMinFr_tr = NaN(numTrials ,1);
approxArrivalS2B_tr = NaN(numTrials ,1);
predPursStartS2B_tr = NaN(numTrials ,1);
predPursEndS2B_tr = NaN(numTrials ,1);


% Durations
saccDuration_tr = NaN(numTrials ,1);
saccToFixMinSec_tr = NaN(numTrials ,1);
fixToPursDelaySec_tr = NaN(numTrials ,1);
visInfoDuringFixSec_tr= NaN(numTrials ,1);
visInfoFixAndPurs_tr = zeros(numTrials ,1);

pursDurSec_tr = NaN(numTrials ,1);
postFixPursDur_tr = NaN(numTrials ,1);
combinedPursuitDur_tr = NaN(numTrials ,1);
postFixALLPursDur_tr = NaN(numTrials ,1);
postFixALLPursDurNorm_tr = NaN(numTrials ,1);
predPursDurSec_tr= NaN(numTrials ,1);
bounceToPredPursDelay_tr= NaN(numTrials ,1);

fixFrames_tr_cFr = cell(1,numTrials);

% Event frames
hitRacquFr_tr = NaN(numTrials ,1);
hitWall_tr = NaN(numTrials ,1);
ballHitFrontFr_tr = NaN(numTrials ,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the start / end frames

fixALLStartFr_idx = fixAllFr_idx_onOff(:,1);
fixALLEndFr_idx = fixAllFr_idx_onOff(:,2);

pursALLStartFr_idx = pursAllFr_idx_onOff(:,1);
pursALLEndFr_idx = pursAllFr_idx_onOff(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  This code can be used to restrict analysis to a subset of trials

%display('** Note:  looking at only a subset of trials **')
%trialsOfType = find( abs(approachAngle_tr) > std(approachAngle_tr));
%trialsOfType = trInBlkIdx_blk(:,floor(size(trInBlkIdx_blk,2)/3):end);
%numTrialsOfType = numel(trialsOfType);

%for idx = 1:numTrialsOfType %1:numTrials

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trIdx = 1:numTrials
    
    %%
    %trIdx = trialsOfType(idx);
    %display('NOTE:  Analysis is considering a SUBSET OF ALL TRIALS.  See generate figures.m.')
    %%%Ball speed 150ms after the bounce
    %pursuitVel150_tr(trIdx) = ballVectorVelDegs_fr(find( sceneTime_fr >= sceneTime_fr(bounceFrame_tr(trIdx)) + .15,1,'first'));
    %%
    
    % Find saccade before bounce    
    findSaccBeforeBounce
    findFixAfterSacc % and bounce
    findPostBouncePursuit
    findPredPurs
    
    %findFixAfterBounce
    %findPursuitAfterBounce
    
    % Was the predictive movement after bounce fixation, or pursuit?
    
    % IDX = The index of the last fixation that occurs before 50 ms after the time of bounce
    %if( foundSacc_tr(trIdx) )
    %end
    
%     % IDX = The index of the last fixation that occurs before 50 ms after the time of bounce
%     if( foundSacc_tr(trIdx) )
%         findFixAfterSacc    
%     end
    
    %findFixAt100
    
    findStrikeInfo
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Find when the ball hits the floor
    
    bounceTimeMS_tr(trIdx)   = sceneTime_fr(bounceFrame_tr(trIdx)) - sceneTime_fr(trialStartFr_tr(trIdx));
    
    % if Y velocity is suddenly negative before the ball has reached the
    % back wall, then the ball has been hit by the racket
   
    if( foundPredFix_tr(trIdx))
        visInfoFixAndPurs_tr(trIdx) = visInfoFixAndPurs_tr(trIdx) + visInfoDuringFixSec_tr(trIdx); 
    end
    
    if( foundPur_tr(trIdx) )
        visInfoFixAndPurs_tr(trIdx) = visInfoFixAndPurs_tr(trIdx) + postFixALLPursDur_tr(trIdx);
    end
    
    %if( foundSaccAndFix_tr(trIdx) )%&& foundPur_tr(trIdx))
    
    if( showTrialData == true && trIdx >= startShowingAtTrial)        
        plotTrialData
        keyboard
        figure(100)
        clf
    end
    
    %end
    
    
    
end

%%

saccAllID_idx_onOff = [movieID_fr(saccStartFr_tr) movieID_fr(saccEndFr_tr)];

% [meanS2BallEndSecsToBounce_el_zdot stdS2BallEndSecsToBounce_el_zdot] = orgBy_el_zdot(s2BallEndS2B_tr .* 1000);
% [meanSwingStart_el_zdot stdSwingStart_el_zdot] = orgBy_el_zdot(swingStart_tr .* 1000);
% [meanSwingStartSecsToBounce_el_zdot stdSwingStartSecsToBounce_el_zdot] = orgBy_el_zdot(swingStartS2B_tr .* 1000);
% [meanSaccStartSecsToBounce_el_zdot stdSaccStartSecsToBounce_el_zdot] = orgBy_el_zdot(saccStartS2B_tr .* 1000);
% [meanS2BallStartSecsToBounce_el_zdot stdS2BallStartSecsToBounce_el_zdot] = orgBy_el_zdot(s2BallStartS2B_tr .* 1000);
% [meanS2BallStartMS_el_zdot stdS2BallStartMS_el_zdot] = orgBy_el_zdot(s2BallStartMS_tr .* 1000);
% [meanS2BallMinMS_el_zdot stdS2BallMinMS_el_zdot] = orgBy_el_zdot(s2BallMinMS_tr .* 1000);


%%

%display('* Gaze to bounce error at time of bounce on any trial limited to
%those within 25 degrees of the bouncepoint');
%G2BAtFixEnd_tr(find(G2BAtFixEnd_tr==0)) = NaN;

%%
%display(sprintf('\nFound predictive saccades on %d of %d trials.',sum(foundS2_tr),sum(sum(numTrials_blk))));
%display(sprintf('%d of fixations were neither near the ball nor the bouncepoint were excluded from the analysis',sum(g2bErrOverThresh_tr)));
%display(sprintf('%d of the saccades ended before the ball bounce and were excluded from the analysis',sum(s2EndsBeforeBounce_tr)));
%display(sprintf('Found pursuits on %d of those %d trials.\n',sum(foundPur_tr),sum(foundS2_tr)))

%display(sprintf('The subject hit the ball on %d trials.\n',(numel(hitRacquFr_tr) - sum(isnan(hitRacquFr_tr)))))
%display(sprintf('The ball hit the front wall on %d trials, and the targets on %d trials.\n',sum(hitWall_tr),sum(hitTargets_tr)));


