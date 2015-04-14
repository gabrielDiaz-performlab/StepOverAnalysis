function [sessionData] = checkForExclusions(sessionData)

loadParameters

%
for trIdx = 1:sessionData.expInfo.numTrials
    
    %trIdx = 101
    
    rawData = sessionData.rawData_tr(trIdx);
    data_cFr_mkr_XYZ = [{rawData.leftFoot_fr_mkr_XYZ},{rawData.rightFoot_fr_mkr_XYZ}];
            
    %% Left foot
    for cIdx = 1:length(data_cFr_mkr_XYZ)
        
        %%
        % Get marker position over time
        mYData_fr_mIdx = squeeze(data_cFr_mkr_XYZ{cIdx}(:,:,2));
        
        % Calculate marker displacement over time along Y dimension
        mYData_fr_mIdx = mYData_fr_mIdx - repmat(mYData_fr_mIdx(1,:),size(mYData_fr_mIdx,1),1);
        
        % Calc total displacement along Y axis
        totalYDisp_mIdx = mYData_fr_mIdx(end,:);
        
        % Find markers 'left behind"
        % That is:  although other markers moved > .5*obstacle distance,
        % the markers 'left behind' did not
        distToObs = rawData.obstacle_XposYposHeight(2);
        [numMarkersLeftBehind leftBehind_mIdx]= find( totalYDisp_mIdx < distToObs/2 ) ;
        
        % If > 2 markers are 'left behind' assuem that the subject did
        if( numMarkersLeftBehind > 3 )
            
            %display('1')
            %keyboard
            
            % Omit trial
            sessionData.rawData_tr.excludeTrial = 1;
            sessionData.rawData_tr.excludeTrialExplanation = 'checkForExclusions: found >2 markers left behind';
            %sessionData.rawData_tr(trIdx) = rawData;
            
        elseif( numMarkersLeftBehind > 0 )
            
            %% Replace session data with edited data
            
            data_cFr_mkr_XYZ{cIdx}(:,leftBehind_mIdx,:) = NaN;
            
            if( cIdx == 1 )
                sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
            elseif( cIdx == 2)
                sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%  Log changes!
            
            %%% Append changes to trial log
            modMessage = sprintf('checkForExclusions: Marker data missing for a single marker in a rigid body.  To correct, values were set to NAN.');
            
            if( isempty( sessionData.rawData_tr(trIdx).trialModifications_cModIdx) )
                sessionData.rawData_tr(trIdx).trialModifications_cModIdx{1} = modMessage;
            else
                sessionData.rawData_tr(trIdx).trialModifications_cModIdx{end+1} = modMessage;
            end
             
            %%% Append changes to experiment log
            if( cIdx == 1 )
                footStr = 'leftFoot';
            elseif( cIdx == 2)
                footStr = 'rightFoot';
            end
            
            
            modMessage = sprintf('checkForExclusions: Significant marker data missing and replaced. trIdx: %u foot: %s mIdx: %s .',trIdx,footStr,mat2str(leftBehind_mIdx));
            
            if( isempty( sessionData.expInfo.changeLog_cChangeIdx) )
                sessionData.expInfo.changeLog_cChangeIdx{1} = modMessage;
            else
                sessionData.expInfo.changeLog_cChangeIdx{end+1} = modMessage;
            end
            
            
            
            %fprintf('Trial num %u >> %s \n', trIdx,modMessage)
            
          
            %sessionData.rawData_tr(trIdx) = rawData;
            
        end

    end
    
end

