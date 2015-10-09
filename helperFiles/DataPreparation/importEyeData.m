
try
    
    gazedatastring = ['Data/GazeData/' movieName '-gazedata.mat'];
    load(gazedatastring)
    display(sprintf('Gaze data imported from file - sub #%d.',subNum))
    
    if( rewriteEyeData == true)
        ThisWillCauseAnErrorThatBringsYouToCatch
    end
catch
    
    display('Gaze data file not found.')
    findFix
    findPursuit
    
    gazedatastring = ['Data/GazeData/' movieName '-gazedata.mat'];
    
    save(gazedatastring,'fix', 'fixAllFr_idx_onOff','pursAllFr_idx_onOff','pursExclusionCode_fr');
    
    display(sprintf('Preliminary gaze data saved to file - sub #%d (in importEyeData.m)',subNum))
    
end
