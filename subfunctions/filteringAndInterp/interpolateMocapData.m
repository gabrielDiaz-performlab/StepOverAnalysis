function [sessionData figH] = interpolateMocapData(sessionData, plotOn)

loadParameters

%%
% findSamplingRate: estimates sampling rate from data for use in
% filter, necessary b/c of variable sampling rate for vizard log

samplingRate = sessionData.expInfo.meanFrameRate;
%1 / mean(diff(sessionData.rawData_tr(1).frameTime_fr));

%% Interpolate marker data

display 'interpolateMocapData: Recalculating sessionData.rawData_tr.'

numTrials = length(sessionData.rawData_tr);


display 'interpMocapData: Erasing and recalculating sessionData.processedData_tr.'
% If a rawData field exists, erase it.
if( any( strcmp(fieldnames(sessionData), 'processedData_tr')) )
    sessionData = rmfield(sessionData,'processedData_tr');
end

for trIdx = 1:numTrials
    
    rawData = sessionData.rawData_tr(trIdx);
    %sessionData.rawData_tr(trIdx) = struct;
    processedData  = struct;
    frameTime_fr = sessionData.rawData_tr(trIdx).frameTime_fr;
    
    headInterpFrames_mkr_XYZ_cFr = cell(size(rawData.spine_fr_mkr_XYZ,2),3);
    rFootInterpFrames_mkr_XYZ_cFr = cell(size(rawData.rightFoot_fr_mkr_XYZ,2),3);
    lFootInterpFrames_mkr_XYZ_cFr = cell(size(rawData.leftFoot_fr_mkr_XYZ,2),3);
    spineInterpFrames_mkr_XYZ_cFr = cell(size(rawData.head_fr_mkr_XYZ,2),3);
    
    
    foundNanLFoot_mkr_XYZ = zeros(10,3);
    foundNanHead_mkr_XYZ = zeros(10,3);
    foundNanRFoot_mkr_XYZ = zeros(10,3);
    foundNanSpine_mkr_XYZ = zeros(10,3);
    
    %     headInterpFrames_mkr_XYZ_cFr = nan(size(rawData.spine_fr_mkr_XYZ,2),3);
    %     rFootInterpFrames_mkr_XYZ_cFr = nan(size(rawData.rightFoot_fr_mkr_XYZ,2),3);
    %     lFootInterpFrames_mkr_XYZ_cFr = nan(size(rawData.leftFoot_fr_mkr_XYZ,2),3);
    %     spineInterpFrames_mkr_XYZ_cFr = nan(size(rawData.head_fr_mkr_XYZ,2),3);
    %
    %     sessionData.processedData(trIdx).headInterpFrames_mkr_XYZ_cFr = headInterpFrames_mkr_XYZ_cFr;
    %     sessionData.processedData(trIdx).rFootInterpFrames_mkr_XYZ_cFr = rFootInterpFrames_mkr_XYZ_cFr;
    %     sessionData.processedData(trIdx).lFootInterpFrames_mkr_XYZ_cFr = lFootInterpFrames_mkr_XYZ_cFr;
    %     sessionData.processedData(trIdx).spineInterpFrames_mkr_XYZ_cFr = spineInterpFrames_mkr_XYZ_cFr;
    
    for mIdx = 1:size(rawData.spine_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(rawData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            
            if( numel(goodIdx) < size(rawData.spine_fr_mkr_XYZ,1) )
                
                numFrames = size(rawData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                spineInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(1:numFrames,goodIdx)};
                
                processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                    frameTime_fr(goodIdx),...
                    rawData.spine_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                    frameTime_fr,...
                    'spline','extrap');
                
                foundNanSpine_mkr_XYZ(mIdx,xyzIdx) = 1;
                
                fprintf('Found NANS in trial %u\n',trIdx)
                
            else
                processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) = rawData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx);
            end
        end
    end
    
    for mIdx = 1:size(rawData.rightFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(rawData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            
            if( numel(goodIdx) < size(rawData.rightFoot_fr_mkr_XYZ,1) )
                
                numFrames = size(rawData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                rFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(1:numFrames,goodIdx)};
                
                foundNanRFoot_mkr_XYZ(mIdx,xyzIdx) = 1;
                
                
                processedData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                    frameTime_fr(goodIdx),...
                    rawData.rightFoot_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                    frameTime_fr,...
                    'spline','extrap');
                
                fprintf('Found NANS in trial %u\n',trIdx)
                
            else
                processedData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = rawData.rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx);
            end
            
            
        end
    end
    
    
    for mIdx = 1:size(rawData.leftFoot_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(rawData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            
            if( numel(goodIdx) < size(rawData.leftFoot_fr_mkr_XYZ,1) )
                
                numFrames = size(rawData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                lFootInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(1:numFrames,goodIdx)};
                
                foundNanLFoot_mkr_XYZ(mIdx,xyzIdx)= 1;
                
                
                processedData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                    frameTime_fr(goodIdx),...
                    rawData.leftFoot_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                    frameTime_fr,...
                    'spline','extrap');
                
                fprintf('Found NANS in trial %u\n',trIdx)
                
            else
                processedData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx) = rawData.leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx);
            end
            
            
            
        end
    end
    
    for mIdx = 1:size(rawData.head_fr_mkr_XYZ,2)
        for xyzIdx = 1:3
            
            goodIdx = find( ~isnan(rawData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
            
            if( numel(goodIdx) < size(rawData.head_fr_mkr_XYZ,1) )
                
                numFrames = size(rawData.head_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                
                headInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    {setdiff(1:numFrames,goodIdx)};
                
                foundNanHead_mkr_XYZ(mIdx,xyzIdx) = 1;
                
                processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                    frameTime_fr(goodIdx),...
                    rawData.head_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                    frameTime_fr,...
                    'spline','extrap');
                
                fprintf('Found NANS in trial %u\n',trIdx)
                
            else
                
                processedData.head_fr_mkr_XYZ(:,mIdx,xyzIdx) = rawData.head_fr_mkr_XYZ(:,mIdx,xyzIdx);
            end
            
        end
    end
    
    sessionData.processedData_tr(trIdx) = processedData;
    
    %     sessionData.rawData_tr(trIdx).headInterpFrames_mkr_XYZ_cFr = headInterpFrames_mkr_XYZ_cFr;
    %     sessionData.rawData_tr(trIdx).lFootInterpFrames_mkr_XYZ_cFr = lFootInterpFrames_mkr_XYZ_cFr;
    %     sessionData.rawData_tr(trIdx).rFootInterpFrames_mkr_XYZ_cFr = rFootInterpFrames_mkr_XYZ_cFr;
    %     sessionData.rawData_tr(trIdx).spineInterpFrames_mkr_XYZ_cFr = spineInterpFrames_mkr_XYZ_cFr;
    
    %%
    if plotOn == 1
        
        figure(1)
        hold on
        clf
        
        for mIdx = 1:size(rawData.rightFoot_fr_mkr_XYZ,2)
            for xyzIdx = 1:3
                if(  foundNanLFoot_mkr_XYZ(mIdx,xyzIdx)|| foundNanHead_mkr_XYZ(mIdx,xyzIdx) || foundNanRFoot_mkr_XYZ(mIdx,xyzIdx) || foundNanSpine_mkr_XYZ(mIdx,xyzIdx) )
                    
                    %                 if( numel(spineInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx}) > 0 ||...
                    %                         numel(headInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx}) > 0 ||...
                    %                         numel(lFootInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx}) > 0 ||...
                    %                         numel(rFootInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx}) > 0 )
                    
                    subplot(1,3,1)
                    cla
                    hold on
                    XYZstring = 'XYZ';
                    title(sprintf('Trial %u, RFoot, Marker %u, %s data',trIdx,mIdx,XYZstring(xyzIdx)))
                    
                    interpFr = rFootInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx};
                    
                    plot(sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
                    plot(sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),'r:')
                    plot(interpFr,sessionData.processedData_tr(trIdx).rightFoot_fr_mkr_XYZ(interpFr,mIdx,xyzIdx),'rx')
                    
                    
                    subplot(1,3,2)
                    hold on
                    cla
                    %ylim([-.3,2])
                    XYZstring = 'XYZ';
                    title(sprintf('Trial %u, LFoot, Marker %u, %s data',trIdx,mIdx,XYZstring(xyzIdx)))
                    
                    interpFr = lFootInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx};
                    
                    plot(sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
                    plot(sessionData.processedData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx,xyzIdx),'r:')
                    plot(interpFr,sessionData.processedData_tr(trIdx).leftFoot_fr_mkr_XYZ(interpFr,mIdx,xyzIdx),'rx')
                    
                    
                    
                    
                    
                    subplot(1,3,3)
                    cla
                    hold on
                    %ylim([-.3,2])
                    XYZstring = 'XYZ';
                    title(sprintf('Trial %u, Head, Marker %u, %s data',trIdx,mIdx,XYZstring(xyzIdx)))
                    
                    interpFr = headInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx};
                    
                    plot(sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
                    plot(sessionData.processedData_tr(trIdx).head_fr_mkr_XYZ(:,mIdx,xyzIdx),'r:')
                    plot(interpFr,sessionData.processedData_tr(trIdx).head_fr_mkr_XYZ(interpFr,mIdx,xyzIdx),'rx')
                    
                    
                    figure(1)
                    cla
                    hold on
                    %ylim([-.3,2])
                    XYZstring = 'XYZ';
                    title(sprintf('Trial %u, Spine, Marker %u, %s data',trIdx,mIdx,XYZstring(xyzIdx)))
                    
                    interpFr = spineInterpFrames_mkr_XYZ_cFr{mIdx,xyzIdx};
                    
                    plot(sessionData.rawData_tr(trIdx).spine_fr_mkr_XYZ(:,mIdx ,xyzIdx),':b')
                    plot(sessionData.processedData_tr(trIdx).spine_fr_mkr_XYZ(:,mIdx,xyzIdx),'r:')
                    plot(interpFr,sessionData.processedData_tr(trIdx).spine_fr_mkr_XYZ(interpFr,mIdx,xyzIdx),'rx')
                    
                    keyboard
                    clf
                end
                
                
            end
        end
    end
end


