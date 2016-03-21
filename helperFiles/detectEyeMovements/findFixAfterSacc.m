
%%%%%%  Find a predictive fixation on this trial
%%% A fixation can be predictive if it begins within t_threshBeforeFix seconds after the bounce
%%% ... or if a saccade begins before t_threshBeforeFix secs after the bounce and is immediately followed by a fixaiton

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Fix after sacc

fixAfterBounceStartFr = [];
fixAfterSaccStartFr = [];
firstFixAfterSaccIdx   = [];

foundPredFix_tr(trIdx) = 0;

if( foundSacc_tr(trIdx) )
    
    % find(trialEndFr_tr > fixALLStartFr_idx(end), 1, 'first')
    firstFixAfterSaccIdx  = find( fixAllFr_idx_onOff(:,1) > saccPeakFr ,1,'first');
    fixAfterSaccStartFr = fixAllFr_idx_onOff(firstFixAfterSaccIdx,1 );
    fixAfterSaccEndFr = fixAllFr_idx_onOff(firstFixAfterSaccIdx ,2);
end

%%

if( ~isempty(firstFixAfterSaccIdx ) )
    
    % Check to make sure fixation ends after the bounce.
    if( fixAfterSaccEndFr <= bounceFrame_tr(trIdx) )
        
        % Fixation ends before bounce
        fixEndsBeforeBounce_tr(trIdx) = 1;
        
        % duration between sacc and fix is too large
        % a large delay might allow subs to program a new eye movement
        aboveTthreshBeforeFix_tr(trIdx) = 1;
    else
        
       
        % Does fix end within t_threshBeforeFix of the saccade end?
        if( foundSacc_tr(trIdx) && eyeDataTime_fr(fixAfterSaccStartFr) <=  (eyeDataTime_fr(saccEndFr_tr(trIdx)) + t_threshBeforeFix/1000) )
            foundPredFix_tr(trIdx) = 1;
        end
    end
end

%%

if(foundPredFix_tr(trIdx) == false)
    fixAfterSaccStartFr = [];
    fixAfterSaccEndFr = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Fix after bounce

% Find fix that starts within t_threshBeforeFix MS after bounce
fixAfterBounceIdx  = [];
% first fix that starts before (bounce + t_threshBeforeFix)
fixAfterBounceIdx = find( eyeDataTime_fr(fixAllFr_idx_onOff(:,1)) <= (sceneTime_fr(bounceFrame_tr(trIdx)) + t_threshBeforeFix/1000),1,'last');

% If we found a pre-bounce saccade, make sure the fix starts after.
if ( foundSacc_tr(trIdx) )
    fixAfterBounceIdx  = intersect( fixAfterBounceIdx, find(fixAllFr_idx_onOff(:,1)>saccStartFr_tr(trIdx)));
end

% fix must end after bounce
fixAfterBounceIdx = intersect( fixAfterBounceIdx, find(fixAllFr_idx_onOff(:,2)>= bounceFrame_tr(trIdx) ));


%%

if( ~isempty(fixAfterBounceIdx) )
    foundPredFix_tr(trIdx) = 1;
    
    fixAfterBounceStartFr = fixAllFr_idx_onOff(fixAfterBounceIdx,1 );
    fixAfterBounceEndFr = fixAllFr_idx_onOff(fixAfterBounceIdx,2 );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fixIdx = [];
fixStartFr = [];
fixEndFr = [];

%%

if( foundPredFix_tr(trIdx) )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Choose latest fixation of fixaftersacc & fixafterbounce

    if(isempty(fixAfterSaccStartFr)) fixAfterSaccStartFr = NaN; end
    if(isempty(fixAfterBounceStartFr)) fixAfterBounceStartFr = NaN; end

    if(  isnan(fixAfterSaccStartFr) || fixAfterBounceStartFr > fixAfterSaccStartFr )
        %%% 
        fixIdx = fixAfterBounceIdx;
        fixStartFr=fixAfterBounceStartFr;
        fixEndFr=fixAfterBounceEndFr;
        foundFixAfterBounce_tr(trIdx)= 1;
    elseif( isnan(fixAfterBounceStartFr) ||  fixAfterSaccStartFr >= fixAfterBounceStartFr )
        fixIdx = firstFixAfterSaccIdx ;
        fixStartFr=fixAfterSaccStartFr;
        fixEndFr=fixAfterSaccEndFr;
        foundFixAfterSacc_tr(trIdx)= 1;
    end
    
    fixFrames_tr_cFr{trIdx} = fixStartFr:fixEndFr;
    
    %% Find minimum gaze to ball during fixation, but AFTER THE BOUNCE!
    
    % Start searching for min at fix start, or bounce.
    % Whichever is last.
    [startFixAnalysisTime eye1scene2] = max([ fixStartFr' bounceFrame_tr(trIdx)]);
    
    if(eye1scene2==1)
        startFixAnalysisFr = fixStartFr;
    else
        startFixAnalysisFr = bounceFrame_tr(trIdx);
    end
    
%     %%  Mean head position and gaze vector during fixation
%     
%     meanEyePosDuringFix_xyz = mean(leftEyeInWorld_fr_xyz(fixFrames_tr_cFr{trIdx},:),3);
%     meanGazeDirDuringFix_xyz = mean(gazeDir_fr_xyz(fixFrames_tr_cFr{trIdx},:));
%     meanGazeDirDuringFix_xyz = meanGazeDirDuringFix_xyz ./ norm(meanGazeDirDuringFix_xyz);
%     meanGaze2BDegs_fixFr = acos( dot(ballVecNormXYZ_fr(:,fixFrames_tr_cFr{trIdx}),repmat(meanGazeDirDuringFix_xyz,numel(fixFrames_tr_cFr{trIdx}),1)')) %* (180/pi);
%     
%     [minDegs minIdx] = min(meanGaze2BDegs_fixFr );
%     meanGaze2BallDegs_tr(trIdx) = minDegs;
%     meanGaze2BallFr_tr(trIdx) = fixFrames_tr_cFr{trIdx}(minIdx);
%     
%     meanEyePosDuringFix_fr_xyz(frIdx,:) = meanEyePosDuringFix_xyz(minIdx);
%     meanGazeDirDuringFix_fr_xyz(frIdx,:) = meanGazeDirDuringFix_xyz;
     
    %%
    
    %%% Find min distance from gaze to ball during fixation, but after bounce
    
    [fix2BallMinDegs_tr(trIdx) fix2BallMinIdx] = min(g2BallDegs_fr(startFixAnalysisFr:fixEndFr));
    fix2BallMinFr = fix2BallMinIdx + startFixAnalysisFr -1;
    fix2BallMinFr_tr(trIdx) = fix2BallMinFr;
    
    
    
    fix2BallMinFr2B_tr(trIdx) = fix2BallMinFr - bounceFrame_tr(trIdx);
    
%     if(fix2BallMinFr2B_tr(trIdx)> 50)
%         keyboard
%     end
    
    fix2BallMinFr_tr(trIdx) = fix2BallMinFr;
    
    % Find when ball passes within a threshold distance of the fix point
    fix2BallMinThreshIdx = find(g2BallDegs_fr(startFixAnalysisFr:fixEndFr) <= minThreshDist,1,'first');
    
    if( ~isempty( fix2BallMinThreshIdx ))
        foundFixThresh_tr(trIdx) = 1;
        fixMinThreshFr2B_tr(trIdx) = (fix2BallMinThreshIdx  + startFixAnalysisFr -1) - bounceFrame_tr(trIdx);
        fixMinThreshS2B_tr(trIdx) = sceneTime_fr(bounceFrame_tr(trIdx)+fixMinThreshFr2B_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
    end
    %%
    %%% Mean sigma: the angle between the horizontal and a vector from bouncept to gaze
    %%% location
    %meanG2BptSigma_tr(trIdx) = mean(g2BptSigmaDegs_fr(fixStartFr:fixEndFr));
    %meanBall2BptSigma_tr(trIdx) = ball2BounceSigmaDegs_fr(fix2BallMinFr);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Convert absolute times into times relative to bounce
    fixStartS2B_tr(trIdx) = eyeDataTime_fr(fixStartFr) - sceneTime_fr(bounceFrame_tr(trIdx));
    fixEndS2B_tr(trIdx)   = eyeDataTime_fr(fixEndFr) - sceneTime_fr(bounceFrame_tr(trIdx));
    fixMinS2B_tr(trIdx)   = eyeDataTime_fr(fix2BallMinFr) - sceneTime_fr(bounceFrame_tr(trIdx));
    
    
    % Times relative to beginning of the trial
    fixStartSec_tr(trIdx) = eyeDataTime_fr(fixStartFr) -sceneTime_fr(trialStartFr_tr(trIdx));
    fixEndSec_tr(trIdx)   = eyeDataTime_fr(fixEndFr)  - sceneTime_fr(trialStartFr_tr(trIdx));
    fixMinSec_tr(trIdx)   = eyeDataTime_fr(fix2BallMinFr)   - sceneTime_fr(trialStartFr_tr(trIdx));
    
    fixDurationSec_tr(trIdx) =  eyeDataTime_fr(fixEndFr)  -  eyeDataTime_fr(fixStartFr);
    
    %saccToFixMinSec_tr(trIdx) = eyeDataTime_fr(fix2BallMinFr) - eyeDataTime_fr(saccStartFr_tr(trIdx));

    %% Direction of gaze error to ball
    % Theta = yaw
    % Phi = pitch
    
    fix2BallMinTheta_tr(trIdx) = g2ballTheta_fr(fix2BallMinFr);
    fix2BallMinPhi_tr(trIdx) = g2ballPhi_fr(fix2BallMinFr);
    
    giwAtFixTheta_tr(trIdx) = nanmean(eiwFiltDegsX_fr(fix2BallMinFr));
    giwAtFixPhi_tr(trIdx) = nanmean(eiwFiltDegsY_fr(fix2BallMinFr));
    
    g2BDegsAtFixEnd_tr(trIdx)  = atan2( g2ballPhi_fr(fixEndFr), g2ballTheta_fr(fixEndFr));
    
    %%% Direction of gaze error to bounce.
    %%% The bounce-point is considered to be the size of a racquetball.
    
    fix2BounceDegs_tr(trIdx) = mean(g2BounceDegs_fr(fixStartFr:fixEndFr));
    
    % Gaze-to-bounce during fixation
    % Eye-centric, world coordinates
    fix2BounceTheta_tr(trIdx) = mean(g2bounceTheta_fr(fixStartFr:fixEndFr));
    fix2BouncePhi_tr(trIdx) = mean(g2bouncePhi_fr(fixStartFr:fixEndFr));
    
    %%% Weedout those fixations that are WAY off target
    if( fix2BallMinDegs_tr(trIdx) > 30 && fix2BounceDegs_tr(trIdx)  > 30 )
        
        display( 'G2B error over 30 degrees.  They were looking at the stars!')
        g2bErrOverThresh_tr(trIdx) = 1;
        
        fix2BallMinDegs_tr(trIdx) = NaN;
        fix2BallMinTheta_tr(trIdx) = NaN;
        fix2BallMinPhi_tr(trIdx) = NaN;
        
        fixStartS2B_tr(trIdx) = NaN;
        fixEndS2B_tr(trIdx) = NaN;
        fixMinS2B_tr(trIdx) = NaN;
        fixStartSec_tr(trIdx) = NaN;
        fixEndSec_tr(trIdx) = NaN;
        fixMinSec_tr(trIdx) = NaN;
        
        foundPredFix_tr(trIdx) = 0;
        
    end
    
end

%%
%fixALLStartFr_idx = fixAllID_idx_onOff(:,1);
%ixALLEndFr_idx = fixAllID_idx_onOff(:,2);

