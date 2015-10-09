
%%  Process movie data and save


try

    
    load(processedDataFileString)
    display(sprintf('Processed data imported from file - sub #%d',subNum))

catch
    
    display('Processed data file not found. Processing Movie...')
    
    processTextData
    %processMovieData;
    
    %% Don't save the parameters
    clear eyeScale arrDegsX arrDegsY arrPixX arrPixY aspectRatio nearH nearW targetHeight
    clear eyeDiameter eyeOffset  eyeInScreenPosX eyeInScreenPosY
    clear numSubs movieList includedSubs excludedSubs subIdx 
    clear vel_thresh t_thresh clump_space_thresh clump_t_thresh
    clear purs_e2bChangeThresh_Low purs_e2bChangeThresh_High purs_degThresh purs_durThresh purs_clump_t_thresh
    clear saccMaxFramesFromBounce filterKernel saccSearchWin saccMinHeight t_threshSaccToFix saccStartStopThresh
    clear medFiltSize gaussFiltSize gaussSdev eyeScale    
    close all
    
    savex(processedDataFileString,'subNum','subIdx','rawDataFileString','processedDataFileString','eyeRotation');
    display('Processed data saved to file. ')
    
    loadParameters
    
end