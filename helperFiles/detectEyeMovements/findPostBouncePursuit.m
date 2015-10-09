
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set the cutoff frame - focus analysis from bounce to time of contact with racquet /
%%% backwall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Find pursuit

%%% Find pursuit that starts before fix ends.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Remove catchup saccades from the post-bounce portion of the trial and recalculate gain

gazeVelDegsSecSaccRem_fr = gazeVelDegsSec_fr;


frameCutoff_tr(trIdx) = bounceFrame_tr(trIdx)+round(( (ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,3)-1) ./ -ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,3)) /(1/60));

%bounceFrame_tr(trIdx) + round((ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,2)/-ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,2)) / (1/60));

pursFrames = bounceFrame_tr(trIdx):frameCutoff_tr(trIdx);

warning off
% search pursFrames for catchup saccades
[catchupPeakFr_sc catchupStartFr_sc catchupEndFr_sc gazeVelForTrial_fr ] = findCatchupSacc(pursFrames,convGazeVelDegsSec_fr,gazeVelDegsSec_fr);
warning on

% overwrite this portion of gazevel with new bit, in which catchup saccades have been removed
gazeVelDegsSecSaccRem_fr(pursFrames) = gazeVelForTrial_fr(pursFrames);
pursuitGain_fr = gazeVelDegsSecSaccRem_fr ./ rballDataFilter(e2bVelDegSec_fr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find pursuit in  velocity signal with catchup saccades removed

%display('* Identifying periods of tracking...')

pursAllFr_idx_onOff = zeros(1,numel(eiwFiltDegsX_fr));
pursExclusionCode_fr  = zeros(1,numel(eiwFiltDegsX_fr));

% Find portions within pursuit gain boundaries
% ..between end of fix and cutoff

%pursFrames = fixFrames_tr_cFr{trIdx}(end):frameCutoff_tr(trIdx);

% find pursuit gain within bounds
idx = intersect( -1+pursFrames(1)+find(  pursuitGain_fr(pursFrames) >= purs_e2bChangeThresh_Low), ...  % above lower thresh
    -1+pursFrames(1)+find(  pursuitGain_fr(pursFrames) <= purs_e2bChangeThresh_High));  % below upper thresh

% find frame cutoff
if( foundPredFix_tr(trIdx) )
    % after end of predictive fixation
    idx = intersect( idx,fixFrames_tr_cFr{trIdx}(end):frameCutoff_tr(trIdx));
else
    % or, after the bounce
    idx = intersect( idx,bounceFrame_tr(trIdx):frameCutoff_tr(trIdx));
end

% Used to keep track of reasons for labelling frames as "pursuit" or "not pursuit."
pursExclusionCode_fr( idx ) = 1;

%% Pursuit cannot occur during a fixation
for i = 1:size(fixAllFr_idx_onOff,1)
    pursExclusionCode_fr(fixAllFr_idx_onOff(i,1):fixAllFr_idx_onOff(i,2)) = 3;
end

%%% Clump pursuits within clump_t_thresh of one another
lastPur = find( pursExclusionCode_fr== 1,1,'first');

for idx = (lastPur+1):numel(pursExclusionCode_fr)
    
    if( pursExclusionCode_fr(idx) == 1)
        
        if( (sceneTime_fr(idx) - sceneTime_fr(lastPur)) <= (purs_clump_t_thresh/1000) )
            pursExclusionCode_fr(lastPur:idx) = 1;
        end
        
        lastPur = idx;
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pursuit must last for a duration of purs_durThresh.
if( numel(find(pursExclusionCode_fr==1))>1)
    
    pursAllFr_idx_onOff = zeros(numel(pursExclusionCode_fr),1);
    pursAllFr_idx_onOff( pursExclusionCode_fr  ~= 1 ) = 0;
    pursAllFr_idx_onOff( pursExclusionCode_fr == 1 ) = 1;
    
    pursAllFr_idx_onOff = contiguous(pursAllFr_idx_onOff,1); % This converts pursAllFr_idx_onOff into the format pursAllFr_idx_onOff(:,1) = start frames, and (:,2) = stop frames
    
    pursAllFr_idx_onOff = pursAllFr_idx_onOff{2};
    
    pursBelowDurThresIdx = find( 1000*(sceneTime_fr(pursAllFr_idx_onOff(:,2)) - sceneTime_fr(pursAllFr_idx_onOff(:,1))) < purs_durThresh );
    
    for xx= 1:numel(pursBelowDurThresIdx )
        pursExclusionCode_fr( pursAllFr_idx_onOff(pursBelowDurThresIdx(xx),1):pursAllFr_idx_onOff(pursBelowDurThresIdx(xx),2)) = 4;
    end
    
    pursAllFr_idx_onOff(pursBelowDurThresIdx,:)=[];
    
    clear tempExcCodeVec
    
    %%%%
    %% Organize data for eyedatabrowser
    
    clear pursAllID_idx_onOff
    pursAllID_idx_onOff(:,1) = sceneTime_fr(pursAllFr_idx_onOff(:,1)); %movieID_fr( pursAllFr_idx_onOff(:,1) );
    pursAllID_idx_onOff(:,2) = sceneTime_fr(pursAllFr_idx_onOff(:,2)); %movieID_fr( pursAllFr_idx_onOff(:,2) );
end

pursALLStartFr_idx = pursAllFr_idx_onOff(:,1);
pursALLEndFr_idx = pursAllFr_idx_onOff(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find pursuit statistics

%findpeaks([1 1 1 1 ]);
%[msg id] = lastwarn;

warning('off')

if(~isempty(pursALLStartFr_idx ))
    
    % Set pursuit search range
    if( foundPredFix_tr(trIdx) )
        % after fix
        purIdx = intersect( find( pursALLStartFr_idx >= fixFrames_tr_cFr{trIdx}(end),1,'first'), ...  % after fixation
            find( pursALLStartFr_idx < frameCutoff_tr(trIdx) ) );  % before end of trial
    else
        % or, if no fix, after bounce
        purIdx = intersect( find( pursALLStartFr_idx >= bounceFrame_tr(trIdx),1,'first'), ...  % after fixation
            find( pursALLStartFr_idx < frameCutoff_tr(trIdx) ) );  % before end of trial
    end
    
    if(~isempty(purIdx ))
        
        stopAtXMeters = 1; % stop searching x meters before the ball reaches the room's X axis
        
        %pursFr = fixFrames_tr_cFr{trIdx}(2):frameCutoff_tr(trIdx);
        if( foundPredFix_tr(trIdx) )
            pursFr = fixFrames_tr_cFr{trIdx}(end):frameCutoff_tr(trIdx);
        else
            pursFr = bounceFrame_tr(trIdx):frameCutoff_tr(trIdx);
        end
        
        [catchupPeakFr_sc catchupStartFr_sc catchupEndFr_sc gazeVelDegsSecSaccRem_fr ] = findCatchupSacc(pursFr,convGazeVelDegsSec_fr,gazeVelDegsSec_fr);
%         if( catchupPeakFr_sc > 0 )
%             keyboard
%         end
        numCatchUpSacc_tr(trIdx) = numel(catchupPeakFr_sc);
        
    end
    
    warning('on')
    
    
    if(~isempty(purIdx) )
        
        % Truncate start to after the saccade ends
        if( foundSacc_tr(trIdx) && pursALLStartFr_idx(purIdx) < saccEndFr_tr(trIdx))
            pursALLStartFr_idx(purIdx) =  saccEndFr_tr(trIdx)+1;
        end
        
        % Truncate start to after the fixation ends
        if( foundPredFix_tr(trIdx) && pursALLStartFr_idx(purIdx) < fixFrames_tr_cFr{trIdx}(end))
            pursALLStartFr_idx(purIdx) =  fixFrames_tr_cFr{trIdx}(end)+1;
        end
    end
    
    % After truncation, make sure the start is still before the end 
    if( ~isempty(purIdx) && pursALLStartFr_idx(purIdx) < pursALLEndFr_tr(purIdx) )
    
        foundPur_tr(trIdx) = 1;
            
        % Pursuit onset time
        pursStartMS_tr(trIdx) =  eyeDataTime_fr(pursALLStartFr_idx(purIdx)) - eyeDataTime_fr(trialStartFr_tr(trIdx));
        pursEndMS_tr(trIdx)   =  eyeDataTime_fr(pursALLEndFr_idx(purIdx)) - eyeDataTime_fr(trialStartFr_tr(trIdx));
        
        % Pursuit onset time rel to bounce
        pursStartS2B_tr(trIdx) = eyeDataTime_fr(pursALLStartFr_idx(purIdx)) - eyeDataTime_fr(bounceFrame_tr(trIdx));
        pursEndS2B_tr(trIdx) = eyeDataTime_fr(pursALLEndFr_idx(purIdx)) - eyeDataTime_fr(bounceFrame_tr(trIdx));
        
        pursDurSec_tr(trIdx) = pursEndS2B_tr(trIdx) - pursStartS2B_tr(trIdx);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Predictive pursuit?
        
%         ballFirstAppearsAtFr = bounceFrame_tr(trIdx)-1+find( drawBallBool_fr(bounceFrame_tr(trIdx):bounceFrame_tr(trIdx)+10),1,'first');
%         
%         if( pursStartS2B_tr(trIdx) < 0)
%             keyboard
%         end
%         
%         pursuitDelay_tr(trIdx) = 1000*( eyeDataTime_fr(pursALLStartFr_idx(purIdx))- sceneTime_fr(ballFirstAppearsAtFr)) ;
%         
%         if( pursuitDelay_tr(trIdx) <= predPursThresh )
%             foundPredPursuit_tr(trIdx) = 1;
%         end
        
        
        % Did pursuit start with a catchup saccade?
        if( ~isempty(catchupStartFr_sc) &&  ...
                (eyeDataTime_fr(catchupStartFr_sc(1))-eyeDataTime_fr(pursALLStartFr_idx(purIdx))) <= (1/60)*3)
            pursStartsWithCatchup_tr(trIdx) = 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Calculate gain during closed loop pursuit
        
        if( pursALLEndFr_idx(purIdx)-pursALLStartFr_idx(purIdx) >= 9)
            
            pStart = pursALLStartFr_idx(purIdx)+6;
            pStop = min([ pursALLStartFr_idx(purIdx)+9 pursALLEndFr_idx(purIdx)]);
            
            if( foundPredFix_tr(trIdx)  && sceneTime_fr( fix2BallMinFr_tr(trIdx))-sceneTime_fr( pStart) <= .1 )
                meanPursuitGain_tr(trIdx) = nanmean( pursuitGain_fr(pStart:pStop));
                gainWIndow_tr_onOff(trIdx,:) = [pStart  pStop];
            end
            
            ballVelDeg100AfterPursStart_tr(trIdx) = ballVectorVelDegs_fr(pStart);
            
        end
        
        
        %%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Duration of all stretches of pursuit b/t the bounce and ball arrival
        % postBouncePursuitIdx = idx of periods of pursuit
        % between bounce and frameCutoff_tr(trIdx)
        
        postBouncePursuitIdx = intersect( find(pursALLStartFr_idx >= bounceFrame_tr(trIdx)), find(pursALLStartFr_idx <= frameCutoff_tr(trIdx) ));
        
        if( ~isempty(postBouncePursuitIdx))
            
            postBouncePursuitStartTimes = eyeDataTime_fr(pursALLStartFr_idx(postBouncePursuitIdx));
            
            % Add dur of first pursuit to postFixALLPursDur_tr
            % If first pursuit began before the bounce, get the duration after the bounce
            if( pursStartS2B_tr(trIdx)  <= 0 )
                postFixALLPursDur_tr(trIdx) = eyeDataTime_fr( pursALLEndFr_idx(purIdx) ) - sceneTime_fr(bounceFrame_tr(trIdx)) ;
            end
            
            %posBouncePursuit_tr_ConOff
            % truncate end times at last fix at frameCutoff_tr(trIdx)
            postBouncePursuitEndTimes = eyeDataTime_fr(pursALLEndFr_idx(postBouncePursuitIdx));
            
            if(  ~isempty(postBouncePursuitEndTimes) && postBouncePursuitEndTimes(end) > sceneTime_fr(frameCutoff_tr(trIdx)))
                postBouncePursuitEndTimes(end) = sceneTime_fr(frameCutoff_tr(trIdx));
            end
            
            % Add duration of pursuits after first fix to postFixALLPursDur_tr
            if( ~isnan(postFixALLPursDur_tr(trIdx)) )
                postFixALLPursDur_tr(trIdx) = [ postFixALLPursDur_tr(trIdx) + sum( postBouncePursuitEndTimes - postBouncePursuitStartTimes )];
            else
                postFixALLPursDur_tr(trIdx) = sum( postBouncePursuitEndTimes - postBouncePursuitStartTimes );
            end
            
            %  Miscellaneous variables
            postFixALLPursDurNorm_tr(trIdx) = postFixALLPursDur_tr(trIdx) ./ (  sceneTime_fr(frameCutoff_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx)) );
            ballVelDegAtPursStart_tr(trIdx) = ballVectorVelDegs_fr(  find(sceneTime_fr >= ( sceneTime_fr( bounceFrame_tr(trIdx))+pursStartS2B_tr(trIdx)),1,'first' ));
            
            %%% Get first frame of pursuit and last frame of pursuit
            pursALLStartFr_tr(trIdx) = pursALLStartFr_idx(postBouncePursuitIdx(1));
            pursALLEndFr_tr(trIdx) =  min( pursALLEndFr_idx(  postBouncePursuitIdx(end) ), frameCutoff_tr(trIdx));
            
            posBouncePursuit_tr_ConOff{trIdx,1} = pursALLStartFr_idx(postBouncePursuitIdx(1));
            posBouncePursuit_tr_ConOff{trIdx,2} = pursALLEndFr_tr(trIdx);
            
            pursALLStartS2B_tr(trIdx) = sceneTime_fr(pursALLStartFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
            pursALLEndS2BFr_tr(trIdx) =  sceneTime_fr(pursALLEndFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
            
%             if( foundPredFix_tr(trIdx) )
%                 
%                 % Magnitude of post fixation, pre-pursuit correction
%                 corrSacMag_tr(trIdx) = g2BallDegs_fr(fixALLEndFr_idx(fixIdx)) - g2BallDegs_fr(pursALLStartFr_idx(purIdx));
%                 
%                 fixToPursDelaySec_tr(trIdx) = sceneTime_fr(pursALLStartFr_idx(purIdx))-sceneTime_fr(fixFrames_tr_cFr{trIdx}(end));
%                 minToPursDelaySec_tr(trIdx) = sceneTime_fr(pursALLStartFr_idx(purIdx))-sceneTime_fr(fix2BallMinFr_tr(trIdx));
%                 
%             end
            
        end
    end
end


%