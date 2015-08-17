% This function iterates through trials and marks those that meet certain
% conditions for exclusion from certain analysis.

% - Conditions for exclusion:
% If a foot marker does not appear to move with the rest of markers attached to
% the same rigid body, then it is excluded because this interferes with
% later analysis.

%%

function [sessionData] = checkForExclusions(sessionData)

loadParameters
%
for trIdx = 1:sessionData.expInfo.numTrials
    
    rawData = sessionData.rawData_tr(trIdx);
    data_cFr_mkr_XYZ = [{rawData(trIdx).lFoot.mkrPos_mIdx_Cfr_xyz},{rawData(trIdx).rFoot.mkrPos_mIdx_Cfr_xyz}];
              
    for cIdx = 1:length(data_cFr_mkr_XYZ)
               
        % Get marker positions over time
        mYData_fr_mIdx = data_cFr_mkr_XYZ{cIdx};
       
        totalYDisp_cIdx = zeros(length(mYData_fr_mIdx),1);
        % Loop over each Marker
        for i = 1:length(mYData_fr_mIdx)
           temp = mYData_fr_mIdx{i};
           
           % Find the displacement
           temp = temp(end,:) - temp(1,:);
           
           %Total displacement along the Y axis
           totalYDisp_cIdx(i) = temp(2);
        end
               
        % Find markers 'left behind"
        % That is:  although other markers moved > .5*obstacle distance,
        % the markers 'left behind' did not
        distToObs = rawData.obstacle_XposYposHeight(2);
        leftBehind_cIdx= find( totalYDisp_cIdx < distToObs/2 ) ;
        
        numMarkersLeftBehind = sum(leftBehind_cIdx);
        
        % If > 2 markers are 'left behind' assume that the subject was left
        % behind
        
        if( numMarkersLeftBehind > 2 )
            
            % Omit trial
            sessionData.rawData_tr(trIdx).info.excludeTrial = 1;
            excludeMessage = sprintf('checkForExclusions: found >2 markers left behind');
            
            if( isempty( sessionData.rawData_tr(trIdx).info.excludeTrialExplanation) )
                sessionData.rawData_tr(trIdx).info.excludeTrialExplanation{1} = excludeMessage;
            else
                sessionData.rawData_tr(trIdx).excludeTrialExplanation{end+1} = excludeMessage;
            end
               
        elseif( numMarkersLeftBehind == 1 )
            
            % Replace session data with edited data
            
            mYData_fr_mIdx{find(leftBehind_cIdx)} = NaN;
            
            data_cFr_mkr_XYZ{cIdx} = mYData_fr_mIdx;
            
%             if( cIdx == 1 )
%                 sessionData.rawData_tr(trIdx).leftFoot_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
%             elseif( cIdx == 2)
%                 sessionData.rawData_tr(trIdx).rightFoot_fr_mkr_XYZ = data_cFr_mkr_XYZ{cIdx};
%             end
            
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
            
            
            modMessage = sprintf('checkForExclusions: Significant marker data missing and replaced. trIdx: %u foot: %s mIdx: %s .',trIdx,footStr,mat2str(leftBehind_cIdx));
            
            if( isempty( sessionData.expInfo.changeLog_cChangeIdx) )
                sessionData.expInfo.changeLog_cChangeIdx{1} = modMessage;
            else
                sessionData.expInfo.changeLog_cChangeIdx{end+1} = modMessage;
            end
            
        else
            display('No markers left behind')
        end

    end
    
    sessionData.rawData_tr(trIdx).lFoot.mkrPos_mIdx_Cfr_xyz = data_cFr_mkr_XYZ{1};
    sessionData.rawData_tr(trIdx).rFoot.mkrPos_mIdx_Cfr_xyz = data_cFr_mkr_XYZ{2};
end


