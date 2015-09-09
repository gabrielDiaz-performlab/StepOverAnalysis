function [sessionData, figH] = filterMocapData(sessionData, plotOn)

loadParameters

if(sum(strcmp(fieldnames(sessionData),'processedData_tr'))==0)
   fprintf('Must run interpolateMocapData.m prior to filterMocapData.m \n')
   return 
end

% findSamplingRate: estimates sampling rate from data for use in
% filter, necessary b/c of variable sampling rate for vizard log

samplingRate = 1 / mean(diff(sessionData.rawData_tr(1).frameTime_fr));

%% Filter marker data

% display 'filterMocapData: Erasing and recalculating sessionData.processedData_tr.'
% % If a processedData field exists, erase it.
% if( any( strcmp(fieldnames(sessionData), 'processedData_tr')) )
%     sessionData = rmfield(sessionData,'processedData_tr');
% end

for trIdx = 1:length(sessionData.rawData_tr)
    
    rawData = sessionData.rawData_tr(trIdx);
    processedData = struct;
    
    for mIdx = 1:size(rawData.spine_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            sessionData.processedData_tr(trIdx).spine_fr_mkr_XYZ(:,mIdx,xyzIdx) = butterLowZero(order,cutoff,samplingRate,rawData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx));
        end
    end
    
    for mIdx = 1:size(rawData.rightFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = butterLowZero(order,cutoff,samplingRate,rawData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx));
        end
    end
    
    for mIdx = 1:size(rawData.leftFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            sessionData.processedData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = butterLowZero(order,cutoff,samplingRate,rawData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx));
        end
    end
    
    for mIdx = 1:size(rawData.head_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            sessionData.processedData_tr(trIdx).head_fr_mkr_XYZ(:,mIdx,xyzIdx) = butterLowZero(order,cutoff,samplingRate,rawData.head_fr_mkr_XYZ(:,mIdx,xyzIdx));
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
