function [sessionData figH] = interpolateMocapData(sessionData, plotOn)

loadParameters

%%
% findSamplingRate: estimates sampling rate from data for use in
% filter, necessary b/c of variable sampling rate for vizard log

samplingRate = 1 / mean(diff(sessionData.rawData_tr(1).frameTime_fr));

%% Interpolate marker data

display 'interpolateMocapData: Recalculating sessionData.processedData_tr.'

numTrials = length(sessionData.rawData_tr);


for trIdx = 1:numTrials
    
    rawData = sessionData.rawData_tr(trIdx);
    processedData  = sessionData.processedData_tr(trIdx);
    frameTime_fr = sessionData.rawData_tr(trIdx).frameTime_fr;
    
    headInterpFrames_mkr_XYZ_cFr = nan(size(processedData.spine_fr_mkr_XYZ,2),3);
    rFootInterpFrames_mkr_XYZ_cFr = nan(size(processedData.rightFoot_fr_mkr_XYZ,2),3);
    lFootInterpFrames_mkr_XYZ_cFr = nan(size(processedData.leftFoot_fr_mkr_XYZ,2),3);
    spineInterpFrames_mkr_XYZ_cFr = nan(size(processedData.head_fr_mkr_XYZ,2),3);
        
    sessionData.processedData_tr(trIdx).headInterpFrames_mkr_XYZ_cFr = headInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).rFootInterpFrames_mkr_XYZ_cFr = rFootInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).lFootInterpFrames_mkr_XYZ_cFr = lFootInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).spineInterpFrames_mkr_XYZ_cFr = spineInterpFrames_mkr_XYZ_cFr;
    
    for mIdx = 1:size(processedData.spine_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            
            if( numel(goodIdx) < size(processedData.spine_fr_mkr_XYZ,1) )
                numFrames = 1:size(processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                spineInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(goodIdx,1:numFrames)};
            end
 
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
            
            if( numel(goodIdx) < size(processedData.rightFoot_fr_mkr_XYZ,1) )
                numFrames = 1:size(processedData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                rFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(goodIdx,1:numFrames)};
            end
            
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
            
            if( numel(goodIdx) < size(processedData.leftFoot_fr_mkr_XYZ,1) )
                
                numFrames = 1:size(processedData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                lFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(goodIdx,1:numFrames)};
            end
            
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
            
            if( numel(goodIdx) < size(processedData.head_fr_mkr_XYZ,1) )
                
                numFrames = 1:size(processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                headInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(goodIdx,1:numFrames)};
            end
            
            processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                frameTime_fr(goodIdx),...
                processedData.head_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                frameTime_fr,...
                'spline');
        end
    end
     
    
    sessionData.processedData_tr(trIdx).headInterpFrames_mkr_XYZ_cFr = headInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).lFootInterpFrames_mkr_XYZ_cFr = lFootInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).rFootInterpFrames_mkr_XYZ_cFr = rFootInterpFrames_mkr_XYZ_cFr;
    sessionData.processedData_tr(trIdx).spineInterpFrames_mkr_XYZ_cFr = spineInterpFrames_mkr_XYZ_cFr;
    
    %%
    if plotOn == 1
        
        figure(1)
        hold on
        
        for mIdx = 1:size(rawData.rightFoot_fr_mkr_XYZ,2)
            for xyzIdx = 1:3
                
                if( rFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) > 0 )
                    cla
                    XYZstring = 'XYZ';
                    title(sprintf('Trial %u, RFoot, Marker %u, %s data',trIidx,mIdx,XYZstring(xyzIdx)))
                    
                    interpFr = rFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx);
                    
                    plot(sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
                    plot(sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),'r:')
                    plot(interpFr,sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(interpFr,mIdx,xyzIdx),'rx')
                    
                end
                
            end
        end

        
    end
end
%         
%             if( headInterpFrames_tr_mkr_XYZ_cFr(trIdx,:,mIdx)
%                 
%             subplot(230+xyzIdx)
%             if( xyzIdx == 2)
%                 title(sprintf('right foot, marker %u, XYZ subplots',mIdx))
%             end
%             hold on
%             grid on
%             plot(sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),'r')
%             plot(sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
%             
%             
%             subplot(233+xyzIdx)
%             if( xyzIdx == 2)
%                 title(sprintf('left foot, marker %u , XYZ subplots',mIdx))
%             end
%             hold on
%             grid on
%             plot(sessionData.processedData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),'r')
%             plot(sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
%             
%         end
% 
%         waitforbuttonpress
%         clf
%     end
%     
% end

