%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find Saccade before bounce

saccPeakFr = [];

% Sacc count will increase to move incrementally through saccades
% until we find thie predictive saccade (or none that are predictive)
saccCount = 1;

while( foundSacc_tr(trIdx)  == false )
    
    % FIRST, find a peak that occurs within saccSearchWin ms of the bounce
    % later, I check to make sure the saccade STARTS within 2 frames of the bounce.
    
    % cast a wide net - find a sacc that peaks 6 frames before the bounce
    saccPeakCutoff = 6 + bounceFrame_tr(trIdx);
    
    % Search backwards from saccPeakCutoff to saccSearchWin frames 
    % before the  bounce..
    reverseVelAroundBounce = convGazeVelDegsSec_fr( saccPeakCutoff:-1:(bounceFrame_tr(trIdx)-saccSearchWin));
    
    [ peakMax saccPeakFr] = findpeaks( ...
        real(reverseVelAroundBounce),...
        'minpeakheight',saccMinHeight, 'npeaks',saccCount);

    if( isempty(saccPeakFr))
        % No saccade found
        break;
    else
        peakMax = peakMax(saccCount);
        saccPeakFr = saccPeakFr(saccCount);
    end
    
    % Identify peak, start, and end
    saccPeakFr = saccPeakCutoff+1 -  saccPeakFr;
    
    % Find sacc start 
    % search signal that has been convolved with saccade-like FIR filter
    % this conv. emphasizes the start/end of saccades with valleys
    
    
    %diffVel = fliplr([diff( convGazeVelDegsSec_fr( (saccPeakFr-20):saccPeakFr))]);
    
    % Take the portion of the signal leading up to the peak.
    % Flip it l/r, so time deceases with each frame
    convAccel = diff(convGazeVelDegsSec_fr);
    reverseAccelAroundBounce = convAccel ( saccPeakFr:-1:saccPeakFr-20);
    
    accelPeakForStart  = 0;
    
    % The first peak in the flipped signal is the first peak before the
    % zero-crossing
    [ peakMax accelPeakForStart ] = findpeaks( real(reverseAccelAroundBounce),'npeaks',1);
    
    if( accelPeakForStart )
        saccStartFr_tr(trIdx) =  saccPeakFr - accelPeakForStart;%-1;
    end
    
    if( ~isreal(diff( convGazeVelDegsSec_fr( saccPeakFr:saccPeakFr+20))) )
        display 'findSaccBeforeBounce: FIX.  Using only real comp of velocity'
        keyoard
    end
    
    reverseAccelAroundBounce = convAccel ( saccPeakFr:saccPeakFr+20);
    %diffVel = [0; real(-diff( convGazeVelDegsSec_fr( saccPeakFr:saccPeakFr+20)))];
    
    [ peakMax accelPeakForStop] = findpeaks( reverseAccelAroundBounce,'npeaks',1);
    
    accelPeakForStop = 0;
    if( accelPeakForStop )
        saccEndFr_tr(trIdx) =  saccPeakFr + accelPeakForStop;% -1;
    end
     
    if( ~accelPeakForStart && ~accelPeakForStop )
        %display('Couldn''t find sacc start or end')
        foundSacc_tr(trIdx) = 0;
    elseif( ~accelPeakForStart && accelPeakForStop )
        
        %display('Found sacc end, but not start.  Assuming symmetry')
        saccStartFr_tr(trIdx) = saccPeakFr-(saccEndFr_tr(trIdx)-saccPeakFr);
        adjustedSacc_tr(trIdx) = 1;
    elseif( accelPeakForStart && ~accelPeakForStop )
        %display('Found sacc start, but not end.  Assuming symmetry')
        saccEndFr_tr(trIdx) = saccPeakFr + (saccPeakFr-saccStartFr_tr(trIdx));
        adjustedSacc_tr(trIdx) = 1;
    end
    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Sacc cannot occur during a fixation
        
        %Find first fix AFTER the sacc.
        fixAfterSaccIdx = [];
        %fixAfterSaccIdx = find( fixAllID_idx_onOff(:,1) >= saccStartFr_tr(trIdx),1,'first');
        fixAfterSaccIdx = find( fixAllFr_idx_onOff(:,1) >=saccStartFr_tr(trIdx),1,'first');
        
        % if sacc end overlaps with the following fix's start
        if( saccEndFr_tr(trIdx) >= fixAllFr_idx_onOff(fixAfterSaccIdx,1))
            % set sacc end to fix start -1
            saccEndFr_tr(trIdx)  =  fixAllFr_idx_onOff(fixAfterSaccIdx,1)-1;
        end
        
        % Find last fix BEFORE the sacc.
        fixBeforeSaccIdx =[];
        fixBeforeSaccIdx = find( fixAllFr_idx_onOff(:,1) <= saccEndFr_tr(trIdx),1,'last');
        
        % if sacc end overlaps with the following fix's start
        if( saccStartFr_tr(trIdx) <= fixAllFr_idx_onOff(fixBeforeSaccIdx,:) )
            % Sacc starts during a fixation.
            saccStartFr_tr(trIdx)  = fixAllFr_idx_onOff(fixBeforeSaccIdx,1)+1;
        end
        
        %%
        saccStartS2B_tr(trIdx) = eyeDataTime_fr(saccStartFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
        saccEndS2B_tr(trIdx) = eyeDataTime_fr(saccEndFr_tr(trIdx)) - sceneTime_fr(bounceFrame_tr(trIdx));
        
        saccDuration_tr(trIdx) = eyeDataTime_fr(saccEndFr_tr(trIdx)) - eyeDataTime_fr(saccStartFr_tr(trIdx));
        
    if( ~isempty(saccStartFr_tr(trIdx)) && ~isempty(saccEndFr_tr(trIdx)) )
        
        foundSacc_tr(trIdx) = 1;
        
    end
    
end


