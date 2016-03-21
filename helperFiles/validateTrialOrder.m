%% This file makes sure that no trial starts before the last one ends.  
%% Violations suggest that something went wrong during the recording
%% process.

for i = 1:numel(trialStartFr_tr)
    
    if( trialEndFr_tr(i) <= trialStartFr_tr(i)) 
        %keyboard
        fprintf('***Fixed***: Missing trial start at %1.0f\n',i')
        keyboard
        trialStartFr_tr = [trialStartFr_tr(1:i-1); trialEndFr_tr(i-1)+1; trialStartFr_tr(i:end)];
    elseif(  trialEndFr_tr(i) <= bounceFrame_tr(i) )
        
        keyboard
        
        %%
%         % plot(ballPos_fr_xyz(trialStartFr_tr(i):trialEndFr_tr(i),3))
%         artBounce = find(ballPos_fr_xyz(trialStartFr_tr(i):trialEndFr_tr(i),3) < ballDiameter * 1.5,1,'first');
%         newBounce = trialStartFr_tr(i) -1 + artBounce;
%         movieID_fr(newBounce)
        %%
    end
    
    if( i>1 && trialEndFr_tr(i-1) > trialStartFr_tr(i))
        
        fprintf('***Fixed***: Missing trial end at %1.0f\n',i')
        keyboard
        
        if( i == 2)
            trialEndFr_tr = [trialStartFr_tr(i)-1; trialEndFr_tr(1:end)];
        else
            trialEndFr_tr = [trialEndFr_tr(1:i-1); trialStartFr_tr(i)-1; trialEndFr_tr(i:end)];
        end
        
        
    end
    
end