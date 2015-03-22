function [sessionData figH] = interpolateMocapData(sessionData, plotOn)

loadParameters

%%
% findSamplingRate: estimates sampling rate from data for use in
% filter, necessary b/c of variable sampling rate for vizard log

samplingRate = 1 / mean(diff(sessionData.rawData_tr(1).frameTime_fr));

%% Interpolate marker data

display 'filterMocapData: Recalculating sessionData.processedData_tr.'

for trIdx = 1:length(sessionData.rawData_tr)
    
    rawData = sessionData.rawData_tr(trIdx);
    processedData  = sessionData.processedData_tr(trIdx);
    frameTime_fr = sessionData.rawData_tr(trIdx).frameTime_fr;
    
    for mIdx = 1:size(processedData.spine_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                frameTime_fr(goodIdx),...
                processedData.spine_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                frameTime_fr,...
                'spline');
        end
    end
    
    for mIdx = 1:size(rawData.rightFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(processedData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            processedData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                frameTime_fr(goodIdx),...
                processedData.rightFoot_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                frameTime_fr,...
                'spline');
        end
    end
    
    
    for mIdx = 1:size(rawData.leftFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(processedData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            processedData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                frameTime_fr(goodIdx),...
                processedData.leftFoot_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                frameTime_fr,...
                'spline');
        end
    end
    
    for mIdx = 1:size(rawData.head_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                frameTime_fr(goodIdx),...
                processedData.head_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                frameTime_fr,...
                'spline');
        end
    end
    
    
    %%
    if plotOn == 1
        
        figure(1)
        mIdx = 1;
        
        for xyzIdx = 1:3

            subplot(230+xyzIdx)
            if( xyzIdx == 2)
                title(sprintf('right foot, marker %u, XYZ subplots',mIdx))
            end
            hold on
            grid on
            plot(sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),'r')
            plot(sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
            
            
            subplot(233+xyzIdx)
            if( xyzIdx == 2)
                title(sprintf('left foot, marker %u , XYZ subplots',mIdx))
            end
            hold on
            grid on
            plot(sessionData.processedData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),'r')
            plot(sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
            
        end

        waitforbuttonpress
        clf
    end
    
end

