function  [catchupPeakFr_sc catchupStartFr_sc catchupEndFr_sc gazeVelDegsSecSaccRem_fr ] = findSaccs(frList,convGazeVelDegsSec_fr,gazeVelDegsSec_fr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FInd the peaks

loadParameters

%    Find saccades in range
convGazeVelTemp = real( convGazeVelDegsSec_fr( frList ) );
conGazeAccelTemp =  real([0; diff( convGazeVelDegsSec_fr( frList+1))]);
conGazeJerkTemp = [0; real(diff(conGazeAccelTemp))];

gazeVelDegsSecSaccRem_fr = gazeVelDegsSec_fr;

catchupPeakFr_sc = [];
catchupStartFr_sc= [];
catchupEndFr_sc= [];


sFr = 1;

%iterate sFR through all frames
while( sFr < numel(frList)-3 )
    
    saccCrossFr = [];
    
    % Find when acceleration indicates the start of a saccade
    [ peakMax_sc saccCrossFr] = findpeaks( ...
        conGazeAccelTemp(sFr:end),...
        'minpeakheight',catchupSaccMinAccel,'nPeaks',1);
    
    if( isempty(saccCrossFr) ) break; end
    
    saccCrossFr = sFr + saccCrossFr - 2;
    if(saccCrossFr<2) saccCrossFr = 2; end
    
    saccPeakFr = [];
    
    temp = convGazeVelTemp(saccCrossFr:end)-convGazeVelTemp(saccCrossFr);
    
    % Find when velocity increases by 5
    [ peakMax_sc saccPeakFr] = findpeaks( ...
        temp,'minpeakheight',5,'nPeaks',1);
    
    if( saccPeakFr )

        saccPeakFr = saccCrossFr + saccPeakFr - 1;
        
        % Find sacc end frame
        % (zero crossing in jerk in pos dir)
        endFr =[];
        thresh = 0;
        while( isempty(endFr) )
            
            searchXFrames = min( [6 numel(conGazeAccelTemp)-saccPeakFr-1]);
            
            
            for i = saccPeakFr:saccPeakFr+searchXFrames
                if (conGazeAccelTemp(i)<=0 && conGazeAccelTemp(i+1)>0)
                    endFr  = i+1;
                end
            end

            thresh = thresh-1;
            
            if(thresh<-5 )
                %display('Thresh too low')
                break;
            end;
            
        end
        
        %%
        
        if( isempty(endFr) )
            endFr = saccPeakFr+(saccPeakFr-saccCrossFr);
            catchupEndFr_sc = [catchupEndFr_sc  frList(1)+saccPeakFr+(catchupStartFr_sc -catchupPeakFr_sc)];
            %display('Symmetry')
            
        end
        
        %%  Interpolate gaze velocity across catchup saccade
        
        if( endFr <= numel(frList))
            
            catchupEndFr_sc =  [catchupEndFr_sc    frList(endFr)];
            catchupStartFr_sc = [catchupStartFr_sc  frList(saccCrossFr)];
            catchupPeakFr_sc = [catchupPeakFr_sc  frList(saccPeakFr)];
            
            try
                startVel = gazeVelDegsSec_fr(frList(saccCrossFr-1));
                stopVel = gazeVelDegsSec_fr(frList(endFr));
            catch
                keyboard
            end
            
            changeInVel = stopVel-startVel;
            
            saccDurInFrames = numel( frList(saccCrossFr): frList(endFr));
            
            slope = changeInVel / saccDurInFrames;
            
            saccInterpFrames = [frList(saccCrossFr-1): frList(endFr)];

            try
                gazeVelDegsSecSaccRem_fr(saccInterpFrames ) = startVel:slope:stopVel;
            catch
                keyboard
            end
        end
        
%         
%         %gazeVelDegsSecSaccRem_fr(saccInterpFrames ) = gazeVelDegsSec_fr(
%         %frList(saccCrossFr)) + (slope .* [1:saccDurInFrames-1]);
%         %%
%         figure(10)
%         set(10,'Units','Normalized','Position',[0 0.498054474708171 0.333333333333333 0.408560311284047]);
%         hold on
%         cla
% 
%         plot( gazeVelDegsSecSaccRem_fr(frList)','c')
% 
%         %plot(conGazeAccelTemp,'g')
%         %plot(conGazeJerkTemp,'b')
% 
%         %hline(catchupSaccMinAccel)
%         %hline(-catchupSaccMinAccel)
%         %hline(0,'y')
% 
%         vline(saccCrossFr-1,'g')
%         vline(saccPeakFr,'m')
%         vline(endFr,'r')
%         %%
%         
%         
    end
    
    
    
    if( saccCrossFr)
        sFr = saccPeakFr+1;
    else
        return
    end
    
end
