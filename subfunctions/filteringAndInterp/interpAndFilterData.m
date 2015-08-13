function [sessionData figH] = interpAndFilterData(sessionData, plotOn)

% It seems that data is already subject to some filling in.
% Evidence?  A rigid body marker data may start with NaNs , but once the
% markers have been seen they are never again NaNs.

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
    
    data_cFr_mkr_XYZ = [{rawData.leftFoot_fr_mkr_XYZ},...
    {rawData.rightFoot_fr_mkr_XYZ},...
    {rawData.spine_fr_mkr_XYZ},...
    {rawData.head_fr_mkr_XYZ}];

    frameTime_fr = sessionData.rawData_tr(trIdx).frameTime_fr;
    
    processedData = struct;
    
    % Get data from cell
    for cIdx = 1:length(data_cFr_mkr_XYZ);
        
        data_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
        interpData_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
        
        for mIdx = 1:size(data_cFr_mkr_XYZ,2)
            for xyzIdx = 1:3
                
                % Find number that are not equal to NaN
                goodIdx = find( ~isnan(data_fr_mkr_XYZ(:,mIdx,xyzIdx) ));
                
                % Note that if the marker was not seen during capture, it could be
                % set to NAN for the entire trial in checkForExclusions.m
                % This would mean that numel(goodIdx) == 0 (all are NaN)
                
                if( numel(goodIdx)  > 0 && numel(goodIdx) < size(data_fr_mkr_XYZ,1) )
                    
                    numFrames = size(data_fr_mkr_XYZ(:,mIdx,xyzIdx),1);
                    
                    %spineInterpFrames_mkr_XYZ_cFr(mIdx,xyzIdx) = ...
                    %    {setdiff(1:numFrames,goodIdx)};
                    
                    try
                        display('Interpolated!')
                        %processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) =
                        interpData_fr_mkr_XYZ(:,mIdx,xyzIdx) = interp1(...
                            frameTime_fr(goodIdx),...
                            data_fr_mkr_XYZ(goodIdx,mIdx,xyzIdx),...
                            frameTime_fr,...
                            'spline','extrap');
                    catch
                        keyboard
                        %processedData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx) = rawData.spine_fr_mkr_XYZ(:,mIdx,xyzIdx);
                        %fprintf('Unable to interpolate spine data\n')
                    end
                    
                    %foundNanSpine_mkr_XYZ(mIdx,xyzIdx) = 1;
                    
                    fprintf('Found NANS in trial %u\n',trIdx)
                end
                
            end
        end
        
        if( cIdx == 1)
            processedData.leftFoot_fr_mkr_XYZ  = interpData_fr_mkr_XYZ;
        elseif(cIdx == 2)
            processedData.rightFoot_fr_mkr_XYZ  = interpData_fr_mkr_XYZ;
        elseif(cIdx == 3)
            processedData.spine_fr_mkr_XYZ  = interpData_fr_mkr_XYZ;
        elseif(cIdx == 4)
            processedData.head_fr_mkr_XYZ  = interpData_fr_mkr_XYZ;
        end
        
    end
    
    sessionData.processedData_tr(trIdx) = processedData;
    
end


sessionData = filterMocapData(sessionData, 0);


