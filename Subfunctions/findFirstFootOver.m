function [ firstCrossingFr firstCrossingFoot footMkrIdx] = FindFirstFootOver( SessionData, trIdx )

%FINDTOECLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    
    trialStruct = SessionData.RawData_tr(trIdx);
    
    %FIXME: Assumes walking up X axis
    %FIXME: Obstacle has no width    
    
    Obstacle_X = trialStruct.Obstacle_XYZ(1);
    
    RightFoot_fr_mkr_XYZ = trialStruct.RightFoot_fr_mkr_XYZ;
    RightFootX_frIdx_mIdx = squeeze(RightFoot_fr_mkr_XYZ(:,:,1));
    [ RightFootMaxX_frIdx,maxRightMkrIdx_fr] = max(RightFootX_frIdx_mIdx,[],2);
    
    LeftFoot_fr_mkr_XYZ = trialStruct.LeftFoot_fr_mkr_XYZ;
    LeftFootX_frIdx_mIdx = squeeze(LeftFoot_fr_mkr_XYZ(:,:,1));
    [ LeftFootMaxX_frIdx, maxLeftMkrIdx_fr] = max(LeftFootX_frIdx_mIdx,[],2);
    
    %%
    
    firstRightCrossingFr = find( RightFootMaxX_frIdx > Obstacle_X ,1,'first');
    firstLeftCrossingFr = find( LeftFootMaxX_frIdx > Obstacle_X ,1,'first');
    
    if( firstRightCrossingFr >= firstLeftCrossingFr )
        firstCrossingFr = firstRightCrossingFr;
        firstCrossingFoot = 'Right';
        footMkrIdx = maxRightMkrIdx_fr(firstRightCrossingFr);
        
    elseif( firstLeftCrossingFr > firstRightCrossingFr )
        firstCrossingFr = firstLeftCrossingFr;
        firstCrossingFoot = 'Left';
        footMkrIdx = maxLeftMkrIdx_fr(firstLeftCrossingFr);
    else
        %FIXME: Will this crash if it can't find anyhing > obstacle_X??
        % e.g. if they did not cross obstacle in time
        print 'FindTOeClearance: No crossing found'!;
        firstCrossingFr = -1;
        firstCrossingFoot = 'None';
    end
        
end
    
   
   
    


