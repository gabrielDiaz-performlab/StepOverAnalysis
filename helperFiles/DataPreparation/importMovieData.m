
    
%% Get raw data and save
try
    load(rawDataFileString)
    display(sprintf('Raw data imported from file - sub #%d',subNum))
    
catch
    
    display('Raw data file not found. Processing Movie...')
    
    try
        try
            movieString = ['/Volumes/data/Gabriel/RaquetballMovies/' expTitle '/' movieName '.mov'];
            parseMovieFile;
            
        catch
            movieString = ['/Users/diaz/Desktop/' expTitle '/' movieName '.mov'];
            
            parseMovieFile;
        end
    catch
        movieString = ['/Volumes/gDrive/' movieName '.mov'];
        parseMovieFile;
    end

    
    %%
    % Don't save the parameters
    clear eyeScale arrDegsX arrDegsY arrPixX arrPixY aspectRatio nearH nearW targetHeight
    clear eyeDiameter eyeOffset eyeInScreenPosX eyeInScreenPosY
    clear numSubs movieList includedSubs excludedSubs subIdx
    clear vel_thresh t_thresh clump_space_thresh clump_t_thresh
    clear purs_e2bChangeThresh_Low purs_e2bChangeThresh_High purs_degThresh purs_durThresh purs_clump_t_thresh
    clear saccMaxFramesFromBounce filterKernel saccSearchWin saccStartStopThresh
    clear saccMinHeight saccMinFramesBeforeBounce saccMaxFramesBeforeBounce t_threshSaccToFix t_threshBeforeFix
    clear medFiltSize gaussFiltSize gaussSdev eyeScale 
    
    
    savex(rawDataFileString,'subNum','subIdx','rawDataFileString','processedDataFileString','sessionDataString','sessionData_ssn_var');
    display('Raw data saved to file. (in importMovieData.m) ')
    
    loadParameters
    
end




