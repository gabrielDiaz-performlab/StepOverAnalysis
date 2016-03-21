
try
    
    gazedatastring = ['Data/GazeData/' sessionDataString '-gazedata.mat'];
    load(gazedatastring)
    display(sprintf('Gaze data for session imported from file'))
    
    if( rewriteEyeData == true)
        ThisNonsenseTextWillCauseAnErrorThatBringsYouToCatch
    end
    
catch
    
    display('Gaze data file not found.')
    findFix
    findPursuit
    
    gazedatastring = ['Data/GazeData/' sessionDataString '-gazedata.mat'];
    
    %save(gazedatastring,'fix', 'fixAllFr_idx_onOff', 'fixAllID_idx_onOff','pursAllFr_idx_onOff','pursAllID_idx_onOff','pursExclusionCode_fr');
    save(gazedatastring,'fix', 'fixAllFr_idx_onOff','pursAllFr_idx_onOff','pursExclusionCode_fr');
    
    display(sprintf('Preliminary gaze data saved to file - sub #%d (in importEyeData.m)',subNum))
    
end
