function sessionData = findFootOverPattern( sessionData, trIdx )
%Kamran Binaee
% Find when each foot breaks the plane of the obstacle
% Identify which one crosses first


%FINDTOECLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    
    trialStruct = sessionData.rawData_tr(trIdx);
    
    %FIXME: Assumes walking up X axis
    %FIXME: Obstacle has no width    
    
    Obstacle_X = trialStruct.obstacle_XYZ(1);
    
    rightFoot_fr_mkr_XYZ = trialStruct.rightFoot_fr_mkr_XYZ;
    rightFootX_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,:,1));
    [ rightFootMaxX_frIdx,maxRightMkrIdx_fr] = max(rightFootX_frIdx_mIdx,[],2);
    
    leftFoot_fr_mkr_XYZ = trialStruct.leftFoot_fr_mkr_XYZ;
    leftFootX_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,:,1));
    [ leftFootMaxX_frIdx, maxLeftMkrIdx_fr] = max(leftFootX_frIdx_mIdx,[],2);
    
    %%
    
    rightFootCrossingFr = find( rightFootMaxX_frIdx > Obstacle_X ,1,'first');
    leftFootCrossingFr = find( leftFootMaxX_frIdx > Obstacle_X ,1,'first');
    
    rightFootMkrIdx = maxRightMkrIdx_fr(rightFootCrossingFr);
    leftFootMkrIdx = maxLeftMkrIdx_fr(leftFootCrossingFr);
    
    if( rightFootCrossingFr <= leftFootCrossingFr )
        firstCrossingFr = rightFootCrossingFr;
        firstCrossingFoot = 'Right';
        
    elseif( leftFootCrossingFr < rightFootCrossingFr )
        firstCrossingFr = leftFootCrossingFr;
        firstCrossingFoot = 'Left';
    else
        %FIXME: Will this crash if it can't find anyhing > obstacle_X??
        % e.g. if they did not cross obstacle in time
        print 'FindToeClearance: No crossing found'!;
        firstCrossingFr = -1;
        firstCrossingFoot = 'None';
    end
        
%% Here is where variables are saved out to sessionData.
% This should happen in one place, for simplicity.

sessionData.processedData_tr(trIdx).rightFootCrossingFr = rightFootCrossingFr;
sessionData.processedData_tr(trIdx).leftFootCrossingFr = leftFootCrossingFr;
sessionData.processedData_tr(trIdx).rightFootMkrIdx = rightFootMkrIdx;
sessionData.processedData_tr(trIdx).leftFootMkrIdx = leftFootMkrIdx;
sessionData.processedData_tr(trIdx).firstCrossingFoot = firstCrossingFoot;

display 'findFootOverPattern: [rightFootCrossingFr, leftFootCrossingFr, rightFootMkrIdx, leftFootMkrIdx, firstCrossingFoot]'

end
    
   
   
    


