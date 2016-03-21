

% Misc variables

%numTrials_blk = (numRepsType1_bl +numRepsType2_bl) * numElasticities;
numTrials = sum(numTrials_blk);

ballVelDegAtPursStart_tr = NaN(numTrials ,1);
ballVelDeg100AfterPursStart_tr = NaN(numTrials ,1);
numCatchUpSacc_tr = zeros(numTrials,1);

meanPursuitGain_tr= NaN(numTrials,1);  % gd: why so rare?
gainWIndow_tr_onOff = NaN(numTrials,2);

apexTimeSec_tr = NaN(numTrials,3);
apexFr_tr =  NaN(numTrials,1);
ballheightAtApex_tr =  NaN(numTrials,1);
ballElevationAtApex_tr =  NaN(numTrials,1);
passFrame_tr= NaN(numTrials ,1);

% Distance measures
hitErr_tr = NaN(numTrials ,1);
hitErrX_tr = NaN(numTrials ,1);
hitErrZ_tr = NaN(numTrials ,1);
corrSacMag_tr = NaN(numTrials ,1);
handAtBncToBallDistZ_tr = NaN(numTrials ,1);

fix2BallMinDegs_tr = NaN(numTrials ,1);
fix2BallMinTheta_tr = NaN(numTrials ,1);
fix2BallMinPhi_tr = NaN(numTrials ,1);

fix2BounceDegs_tr = NaN(numTrials ,1);
fix2BounceTheta_tr = NaN(numTrials ,1);
fix2BouncePhi_tr = NaN(numTrials ,1);

gazePitchAtMeanMin_tr = NaN(numTrials ,1);
gazePitchDuringFix_tr = NaN(numTrials ,1);

foundSacc_tr = zeros(numTrials ,1);
foundPredFix_tr = zeros(numTrials ,1);
foundSaccAndFix_tr= zeros(numTrials ,1);
foundPur_tr = zeros(numTrials ,1);
foundPredHandAdj_tr = zeros(numTrials ,1);;

successfulCatch_tr = zeros(numTrials ,1);
catchFrame_tr = NaN(numTrials ,1);
fixEndsBeforeBounce_tr = NaN(numTrials ,1);
foundFixAfterBounce_tr = NaN(numTrials ,1);
foundFixAfterSacc_tr= NaN(numTrials ,1);
foundFixThresh_tr = zeros(numTrials ,1);

aboveTthreshBeforeFix_tr = zeros(numTrials ,1);
adjustedSacc_tr = zeros(numTrials ,1);
foundPredPursuit_tr = zeros(numTrials ,1);
hitTargets_tr= zeros(numTrials ,1);
pursStartsWithCatchup_tr = zeros(numTrials ,1);

% Timing variables

saccStartS2B_tr = NaN(numTrials ,1);
%saccEndS2B_tr = NaN(numTrials ,1);

fix2BallMinFr2B_tr =  NaN(numTrials ,1);
fixMinThreshS2B_tr = NaN(numTrials ,1);

fixStartS2B_tr = NaN(numTrials ,1);
fixEndS2B_tr = NaN(numTrials ,1);
fixMinS2B_tr = NaN(numTrials ,1);

meanG2BptSigma_tr = NaN(numTrials ,1);

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

fixMinThreshFr2B_tr = NaN(numTrials ,1);
%fix2BallMinFr_tr = NaN(numTrials ,1);
approxArrivalS2B_tr = NaN(numTrials ,1);
pursALLStartFr_tr= NaN(numTrials ,1);
pursALLEndFr_tr= NaN(numTrials ,1);
pursuitDelay_tr= NaN(numTrials ,1);

% Durations

durBounceToArrivalSec_tr = NaN(numTrials ,1);

fixDurationSec_tr = NaN(numTrials ,1);
totalFoveaDurMS_tr= zeros(numTrials ,1);

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
pursALLStartS2B_tr= NaN(numTrials ,1);
pursALLEndS2BFr_tr= NaN(numTrials ,1);
minToPursDelaySec_tr= NaN(numTrials ,1);
fixFrames_tr_cFr = cell(1,numTrials);

% Event frames

hitRacquFr_tr = NaN(numTrials ,1);
hitWall_tr = NaN(numTrials ,1);
ballHitFrontFr_tr = NaN(numTrials ,1);
fix2BallMinFr_tr= NaN(numTrials ,1);

%% Ball position etc

ballHeightAtArrival_tr = NaN(numTrials ,1);
handHeightAtBounce_tr = NaN(numTrials ,1);
finalHandPos_tr = NaN(numTrials ,1);
catchFrame_tr= NaN(numTrials ,1);


% Predictive hand adjustment
adjStartFr_tr  = NaN(numTrials ,1);
adjEndFr_tr = NaN(numTrials ,1);
adjustedHandAdj_tr  = NaN(numTrials ,1);
adjStartS2B_tr   = NaN(numTrials ,1);
adjEndS2B_tr  = NaN(numTrials ,1);
adjDuration_tr  = NaN(numTrials ,1);
adjEndPoint_tr_xyz = NaN(numTrials ,3);

%
% meanGaze2BallDegs_tr  = NaN(numTrials ,1);
% meanGaze2BallFr_tr = NaN(numTrials ,1);
% meanGazeDirDuringFix_fr_xyz = NaN(numTrials ,3);
% meanEyePosDuringFix_fr_xyz = NaN(numTrials ,3);

%skipTrials = [139 158 172 181 227 254 259 271 317 321 332  333 338 339 341 343 351];

elasticityList = unique(elasticity_tr);

trE1 = find(elasticity_tr == elasticityList(1));
trE2 = find(elasticity_tr == elasticityList(2));

trialList = setdiff( 1:numTrials,excludeTrialList);

if( ~isempty(focusOnBlocks))
    trialList = intersect(trialList ,reshape(cell2mat(trInBlk_Cblk(focusOnBlocks)),1,[]))
    %trialList  = trInBlk_Cblk{focusOnBlocks}
    display(sprintf('*** Analysis for block(s) [%s] only**',mat2str(focusOnBlocks)));
end

%trialList = setDiff( [300:400],excludeTrialList);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trIdx = trialList 
    
   
    trFrList = trialStartFr_tr(trIdx):trialEndFr_tr(trIdx);
        
        handHeightAtBounce_tr(trIdx) = racqPos_fr_xyz(bounceFrame_tr(trIdx),3);
        
        durBounceToArrivalSec_tr(trIdx) = -ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,2) / ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,2);
        
        passFrame_tr(trIdx) = bounceFrame_tr(trIdx)+round(durBounceToArrivalSec_tr(trIdx) / (1/60)) -1 ;
        
        ballHitPaddleIdx = intersect( find( ballHitPaddle_tr  > trialStartFr_tr(trIdx)), find( ballHitPaddle_tr  < trialEndFr_tr(trIdx) ));

        if( ballHitPaddleIdx )
            catchFrame_tr(trIdx) = ballHitPaddle_tr(ballHitPaddleIdx);
            successfulCatch_tr(trIdx) = 1;
            finalHandPos_tr(trIdx) = racqPos_fr_xyz(catchFrame_tr(trIdx),3);
        else
            catchFrame_tr(trIdx) = NaN;
            finalHandPos_tr(trIdx) = racqPos_fr_xyz(passFrame_tr(trIdx),3);
        end
    
%         if( ~isempty(catchFrame) )
%             catchFr_tr(trIdx) = catchFrame;
%             successfulCatch_tr(trIdx) = 1;
%             finalHandPos_tr(trIdx) = racqPos_fr_xyz(catchFrame_tr(trIdx),3);
%         else
%             finalHandPos_tr(trIdx) = racqPos_fr_xyz(passFrame_tr(trIdx),3);
%         end
        
        ballHeightAtArrival_tr(trIdx)  = ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,3) + durBounceToArrivalSec_tr(trIdx) *ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,3) + .5*-9.8*durBounceToArrivalSec_tr(trIdx)^2;
        handAtBncToBallDistZ_tr(trIdx) = abs(ballHeightAtArrival_tr(trIdx)-handHeightAtBounce_tr(trIdx));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%  Find apex
        % Involves some complicated interpolation.
        
        apexSearchList = trialStartFr_tr(trIdx):bounceFrame_tr(trIdx)-10;
        
        % BUMMER.  Interp only accepts unique values.
        % Here, I find find unique vals (similar to unique()) without sorting
        
        clear tempBallVelZInclList
        
        tempBallVelZ = smooth(diff(ballPos_fr_xyz(apexSearchList,3)));
        [tempBallVelZSorted, sortVec] = sort(tempBallVelZ);
        tempBallVelZInclList(sortVec) = ([1; diff(tempBallVelZSorted)] ~= 0);
        
        tempBallVelZUnique = tempBallVelZ(tempBallVelZInclList);
        tempBallVelZUniqueIdx = find(tempBallVelZInclList==1);
        
        tempBallVelZUniqueTimeVals = sceneTime_fr(apexSearchList(1) + tempBallVelZUniqueIdx);
 
        apexTimeSec_tr(trIdx) = interp1( tempBallVelZUnique, tempBallVelZUniqueTimeVals,0);
        [junk apexFr_tr(trIdx)] = min( abs(sceneTime_fr - apexTimeSec_tr(trIdx)) );
        
        ballheightAtApex_tr(trIdx) = interp1( tempBallVelZUnique, ballPos_fr_xyz(tempBallVelZUniqueIdx+trialStartFr_tr(trIdx)-1,3),0);
        ballElevationAtApex_tr(trIdx) = interp1( tempBallVelZUnique, e2bWorldFiltDegsY_fr(tempBallVelZUniqueIdx+trialStartFr_tr(trIdx)-1),0);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%
        
        %findHandMovements
        
        findSaccBeforeBounce
       
        findFixAfterSacc
        
        findPostBouncePursuit
        
        findHandAdjBeforeBounce
        
%         if( foundPredHandAdj_tr(trIdx) == 1)
%             plotTrialHandVel
%         end
        
        if( foundPredFix_tr(trIdx) )
            totalFoveaDurMS_tr(trIdx) = totalFoveaDurMS_tr(trIdx) + 1000 * fixDurationSec_tr(trIdx);
        end
        
        if( foundPur_tr(trIdx) )
            totalFoveaDurMS_tr(trIdx) = totalFoveaDurMS_tr(trIdx) + 1000* pursDurSec_tr(trIdx);
        end        
        
        if( showTrialDataAfter > 0 && trIdx >= showTrialDataAfter && successfulCatch_tr(trIdx)) 
            %plotTrialData; 
            plotTrialHandVelBTime
            keyboard; 
        end
        
        %if( showTrialDataAfter > 0 && trIdx >= showTrialDataAfter ) 
            %plotTrialData; 
        %end
        
        %if( foundPredFix_tr(trIdx) == 1)
        %   if( showTrialDataAfter > 0 && trIdx >= showTrialDataAfter ) plotTrialData; keyboard; end
        %end 
        
    %end
end

%%

%handHeightAtBounce_tr = removeOutliers(handHeightAtBounce_tr,2.5);
%handAtBncToBallDistZ_tr = removeOutliers(handAtBncToBallDistZ_tr ,2.5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Temporary additions - to be moved to processData

handVel_fr = sqrt( sum(racqVel_fr_xyz().^2,2) );
handPlanarVel_fr = sqrt( sum(racqVel_fr_xyz(:,[1 2]).^2,2) );
 
filter = fspecial('gaussian',[handFiltWidth 1], handFiltSD);  % gaussian kernel where s= size of contour
handVelFilt_fr  = conv(handVel_fr ,filter,'same');

handPlanarVelFilt_fr = conv(handPlanarVel_fr ,filter,'same');
handPlanarVelFilt_tr  = handPlanarVelFilt_fr(bounceFrame_tr);

%%  Adjust error to account for size of racquet 
%% NOT DONE CORRECTLY - DOESN'T ACOUNT FOR RACQUET TILTING

%racRotMatTemp_d1_d2 = quaternion2matrix(racqQuat_fr_quat(passFrame_tr(trIdx),:));
%racRotMatTemp_d1_d2 = racRotMatTemp_d1_d2(1:3,1:3);

%racCircle = [cos(piData); sin(piData); zeros(1,numel(piData)) ] * racquetSize_whd(1);
%racquetHeightAlongZUponArrival = 

%racquTop =  racqPos_fr_xyz(passFrame_tr(trIdx),:) + (racRotMatTemp_d1_d2 * [])

% withinRaquRadiusIdx = find(handAtBncToBallDistZ_tr  <= racquetSize_whd(1));
% outsideRacquRadiusIdx = setdiff(withinRaquRadiusIdx,1:numel(handAtBncToBallDistZ_tr));
% handAtBncToBallDistZ_tr(withinRaquRadiusIdx) =0;
%handAtBncToBallDistZ_tr(outsideRacquRadiusIdx) = handAtBncToBallDistZ_tr(outsideRacquRadiusIdx) - racquetSize_whd(1);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate gaze position at avg time of min fix-to-ball distance

clear finalBallHeight_rep_el

for trIdx = trialList 
    
    gazePitchAtMeanMin_tr(trIdx) = eiwDegsY_fr(bounceFrame_tr(trIdx) + round(nanmean(fixMinS2B_tr(elasticity_tr == elasticity_tr(trIdx))) / (1/60))  );
    %gazePitchAtMeanMin_tr(trIdx) = eiwDegsY_fr(bounceFrame_tr(trIdx) + round(nanmean(fixMinS2B_tr(find(elasticity_tr == elasticity_tr(trIdx)))) / (1/60))  );
    gazePitchDuringFix_tr(trIdx) = mean(eiwFiltDegsY_fr(fixFrames_tr_cFr{trIdx}));
    
end

gazePitchDuringFix_tr = removeOutliers(gazePitchDuringFix_tr,2.5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Organize by rep and elasticity

clear finalBallHeight_rep_el handPlanarVelFilt_rep_el handPlanarVelFilt_rep_el handVelFilt_rep_el finalHandPos_rep_el handPosAtBounce_rep_el
clear fixPitch_el_cRep
clear fixElev2Bounce_el_cRep
clear fixDist2Bounce_el_cRep
clear balLocationAtMeanMin_el_cRep 

fixMinS2B_el_cRep = [];
fix2BallMinDegs_el_cRep = [];

%numRepsPerSession = numel(find(elasticity_tr == elasticityList(1)))

%sum(numRepsType1_bl(focusOnBlocks) + numRepsType2_bl(focusOnBlocks));

% fixPitch_el_cRep = {eIdx}(count); %numElasticities
% finalBallHeight_rep_el = {eIdx}(count) 
% handPosAtBounce_rep_el
% finalHandPos_rep_el
% handVelFilt_rep_el
% handPlanarVelFilt_rep_el
%%
%a = cell(fixMinS2B_el_cRep

for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    
    finalBallHeight_rep_el(:,eIdx) = ballHeightAtArrival_tr(idx);
    handPosAtBounce_rep_el(:,eIdx) = handHeightAtBounce_tr(idx);
    finalHandPos_rep_el(:,eIdx) = finalHandPos_tr(idx);
    handVelFilt_rep_el(:,eIdx) = handVelFilt_fr(bounceFrame_tr(idx));
    handPlanarVelFilt_rep_el(:,eIdx) = handPlanarVelFilt_fr(bounceFrame_tr(idx)); 
    
    predHandHeight_rep_el(:,eIdx) = adjEndPoint_tr_xyz(idx,3);
    
    finalBallHeight_rep_el(:,eIdx) = ballHeightAtArrival_tr(idx);
    gazePitch_rep_el(:,eIdx) = gazePitchAtMeanMin_tr(idx);
    
    % Information related to predictive fixation
    idx = intersect( idx, find(foundPredFix_tr));
    
    count = 1;
    for tempIdx = 1:numel(idx)
        
        trIdx = idx(count);
        
        fixPitch_el_cRep{eIdx}(count) = mean(eiwFiltDegsY_fr(fixFrames_tr_cFr{trIdx} ));
        fixElev2Bounce_el_cRep{eIdx}(count) = fix2BouncePhi_tr(trIdx);
        fixDist2Bounce_el_cRep{eIdx}(count) = fix2BounceDegs_tr(trIdx);
        %balLocationAtMeanMin_el_cRep{eIdx}(count) = e2bWorldDegsY_fr( bounceFrame_tr(trIdx) + meanMinFrFromBounce_el(eIdx) -1 );
        
        fixMinS2B_el_cRep{eIdx}(count) = fixMinS2B_tr(trIdx);
        fix2BallMinDegs_el_cRep{eIdx}(count) = fix2BallMinDegs_tr(trIdx);
        
        count = count+1;
    end
    
end


%%  Calculate mean time of min, and get info about eye movements at this time
clear meanMinFrFromBounce_el ball2BounceDegsAtMeanMin_el_cRep

meanMinFrFromBounce_el(1) = round(mean(fixMinS2B_el_cRep{1}) ./ (1/60));
meanMinFrFromBounce_el(2) = round(mean(fixMinS2B_el_cRep{2}) ./ (1/60));

for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(foundPredFix_tr));
    
    count = 1;
    for trIdx = idx' % tempIdx = 1:numel(idx)
        
        
        meanFr = bounceFrame_tr(trIdx) + meanMinFrFromBounce_el(eIdx) -1;
        
        ball2BounceDegsAtMeanMin_el_cRep{eIdx}(count) = sqrt( ball2bouncePhi_fr(meanFr).^2 + ball2bounceTheta_fr(meanFr).^2);
        
        ballLocationAtMeanMin_el_cRep{eIdx}(count) = e2bWorldDegsY_fr( bounceFrame_tr(trIdx) + meanMinFrFromBounce_el(eIdx) -1 );
        ballLocationAtMeanMin_tr(trIdx) = e2bWorldDegsY_fr( bounceFrame_tr(trIdx) + meanMinFrFromBounce_el(eIdx) -1 );
        count = count+1;
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Remove outliers in hand velocity
%

% % figure(243)
% % hold on
% % cla
% % width = 120;
% % a = (bounceFrame_tr(10)-width):(bounceFrame_tr(10)+width);
% % plot(handVel_fr (a),'r')
% % plot(handVelFilt_fr  (a),'g')
% 
% % figure(1022)
% % clf
% % handDispAfterBounceM_tr = sqrt(sum((racqPos_fr_xyz(passFrame_tr,:)-racqPos_fr_xyz(bounceFrame_tr,:)).^2,2));
% % hist(handDispAfterBounceM_tr,30)
% 


%fixMinThreshS2B_rep_el = nan(sum(numRepsType1_bl+numRepsType2_bl),numElasticities);
%fix2BallMinDegs_rep_el = nan(sum(numRepsType1_bl+numRepsType2_bl),numElasticities);



