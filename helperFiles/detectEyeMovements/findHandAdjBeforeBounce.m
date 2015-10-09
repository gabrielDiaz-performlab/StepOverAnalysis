clear handVelTemp_fr_xyz

handVelTemp_fr_xyz(:,1) = diff( rballDataFilter(racqPos_fr_xyz(:,1)) ./ sceneDur_fr');
handVelTemp_fr_xyz(:,2) = diff( rballDataFilter(racqPos_fr_xyz(:,2)) ./ sceneDur_fr');
handVelTemp_fr_xyz(:,3) = diff( rballDataFilter(racqPos_fr_xyz(:,3)) ./ sceneDur_fr');

handVelTemp_fr = sqrt( sum(handVelTemp_fr_xyz .^2 ,2) );
handVelTempFilt_fr  = handVelTemp_fr ;

%filter = fspecial('gaussian',[5 1], 2);  % gaussian kernel where s= size of contour
%handVelTempFilt_fr  = conv(handVelTemp_fr ,filter,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find Saccade before bounce

adjPeakFr = [];

adjCount = 1;

foundHandAdjBeforeBounce = 0;

while( foundHandAdjBeforeBounce   == false )
    
    % FIRST, find a peak that occurs within adjSearchWin ms of the bounce
    % later, I check to make sure the saccade STARTS within 2 frames of the bounce.
    
    % cast a wide net - find a sacc that peaks 6 frames from bounce
    adjPeakCutoff = 6 + bounceFrame_tr(trIdx);
    
    %    Find the last saccade within adjSearchWin ms before t = 50 ms after bounce
    %temp = %handVelTempFilt_fr( adjPeakCutoff:-1:(bounceFrame_tr(trIdx)-adjSearchWin));
    temp = handVelTempFilt_fr( adjPeakCutoff:-1:(bounceFrame_tr(trIdx)-adjSearchWin));
    
    [ peakMax adjPeakFr] = findpeaks( ...
        real(temp),...
        'minpeakheight',adjMinHeight, 'npeaks',adjCount);

    if( isempty(adjPeakFr))
        % No saccade found
        break;
    else
        peakMax = peakMax(adjCount);
        adjPeakFr = adjPeakFr(adjCount);
    end
    
    % Identify peak, start, and end
    adjPeakFr = adjPeakCutoff+1 -  adjPeakFr;
    
    % Find sacc start 
    % search signal that has been convolved with saccade-like FIR filter
    
    diffVel = fliplr([diff( handVelTempFilt_fr( (adjPeakFr-20):adjPeakFr))]);
    
    accelPeakForStart  = 0;
    
    [ peakMax accelPeakForStart ] = findpeaks( real(diffVel),'npeaks',1);
    
    if( accelPeakForStart )
        adjStartFr_tr(trIdx) =  adjPeakFr - accelPeakForStart-1;
    end
    
    if( ~isreal(diff( handVelTempFilt_fr( adjPeakFr:adjPeakFr+20))) )
        display 'findSaccBeforeBounce: FIX.  Using only real comp of velocity'
        keyoard
    end
    
    diffVel = [0; real(-diff( handVelTempFilt_fr( adjPeakFr:adjPeakFr+20)))];
    [ peakMax accelPeakForStop] = findpeaks( diffVel,'npeaks',1);
    
    accelPeakForStop = 0;
    if( accelPeakForStop )
        adjEndFr_tr(trIdx) =  adjPeakFr + accelPeakForStop - 1;
    end
     
    if( ~accelPeakForStart && ~accelPeakForStop )
        %display('Couldn''t find sacc start or end')
        foundHandAdjBeforeBounce  = 0;
        
    elseif( ~accelPeakForStart && accelPeakForStop )
        foundHandAdjBeforeBounce  = 1;
        %display('Found sacc end, but not start.  Assuming symmetry')
        adjStartFr_tr(trIdx) = adjPeakFr-(adjEndFr_tr(trIdx)-adjPeakFr);
        adjustedHandAdj_tr(trIdx) = 1;
    elseif( accelPeakForStart && ~accelPeakForStop )
        foundHandAdjBeforeBounce  = 1;
        %display('Found sacc start, but not end.  Assuming symmetry')
        adjEndFr_tr(trIdx) = adjPeakFr + (adjPeakFr-adjStartFr_tr(trIdx));
        adjustedHandAdj_tr(trIdx) = 1;
    end
    
    
% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         %% Sacc cannot occur during a fixation
% %         
% %         % Find first fix AFTER the sacc.
% %         fixAfterSaccIdx = [];
% %         %fixAfterSaccIdx = find( fixAllID_idx_onOff(:,1) >= adjStartFr_tr(trIdx),1,'first');
% %         fixAfterSaccIdx = find( fixAllFr_idx_onOff(:,1) >=adjStartFr_tr(trIdx),1,'first');
% %         
% % %         if( adjEndFr_tr(trIdx) >= fixAllID_idx_onOff(fixAfterSaccIdx,1))
% % % 
% % %             adjEndFr_tr(trIdx)  =  fixAllID_idx_onOff(fixAfterSaccIdx,1);
% % %         end
% % %         
% % %         % Find last fix BEFORE the sacc.
% % %         fixBeforeSaccIdx =[];
% % %         fixBeforeSaccIdx = find( fixALLEndFr_idx <= adjEndFr_tr(trIdx),1,'last');
% % %         
% % %         if( adjStartFr_tr(trIdx) <= fixALLEndFr_idx(fixBeforeSaccIdx) )
% % %             % Sacc starts during a fixation.
% % %             adjStartFr_tr(trIdx)  = fixALLEndFr_idx(fixBeforeSaccIdx)+1;
% % %         end
        
        adjStartS2B_tr(trIdx) = sceneTime_fr(adjStartFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
        adjEndS2B_tr(trIdx) = sceneTime_fr(adjEndFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
        adjDuration_tr(trIdx) = sceneTime_fr(adjEndFr_tr(trIdx)) - sceneTime_fr(adjStartFr_tr(trIdx));
        
        adjEndPoint_tr_xyz(trIdx,:) = racqPos_fr_xyz(adjEndFr_tr(trIdx),:);
    
% if( sceneTime_fr( adjEndFr_tr(trIdx)) > sceneTime_fr( bounceFrame_tr(trIdx)) + (t_threshAdjMSAfterBounce/1000) )
%         %display( sprintf('Trial #%u.  Adj was not predictive',trIdx) )
%         
%         % Adj must end witihin 100 ms of bounce  
%         foundHandAdjBeforeBounce  = 0;
%     
%         adjStartS2B_tr(trIdx) = NaN;
%         adjEndS2B_tr(trIdx) = NaN;
%         adjDuration_tr(trIdx) = NaN;
    
    if( ~isempty(adjStartFr_tr(trIdx)) && ~isempty(adjEndFr_tr(trIdx)) )
        
        foundHandAdjBeforeBounce  = 1;
    
    end
    
    if( sceneTime_fr( adjEndFr_tr(trIdx)) < sceneTime_fr( bounceFrame_tr(trIdx)) + (t_threshAdjMSAfterBounce/1000) )
            
            display( sprintf('Trial #%u.  Adj was  predictive',trIdx) )
            
            % Predictive    
            foundPredHandAdj_tr(trIdx) = 1;
            %plotTrialHandVel
    end
    
end


