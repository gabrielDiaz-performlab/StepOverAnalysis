

for i = 1:numel(trialStartFr_tr)
    
    if( trialEndFr_tr(i) <= trialStartFr_tr(i)) 
        keyboard
    elseif(  trialEndFr_tr(i) <= bounceFrame_tr(i) )
        keyboard;
    end
    
    if( i>1 && trialEndFr_tr(i-1) > trialStartFr_tr(i))
        
        fprintf('***Fixed***: Missing trial end at %1.0f\n',i')
        
        if( i == 2)
            trialEndFr_tr = [trialStartFr_tr(i)-1; trialEndFr_tr(1:end)];
        else
            trialEndFr_tr = [trialEndFr_tr(1:i-1); trialStartFr_tr(i)-1; trialEndFr_tr(i:end)];
        end
        
        
    end
    
end