%COMPUTE_CLUMPED_FIX clumps fixations
%   [newFixMS_idx_onOff, newFixFr_idx_onOff] = COMPUTE_CLUMPED_FIX(FIX_IN, T, X, T_THRESH, SPACE_THRESH)
%   returns in fixMS_idx_onOff the fixations clumped from FIX_IN according to
%   the following guide:


function [newFixMS_idx_onOff, newFixFr_idx_onOff] =  compute_clumped_fix(fixMS_idx_onOff, fixFr_idx_onOff, t, x, space_thresh, t_thresh)
% clumps fixations according to time and space params

% compute centroids of fixations
[centroidDegs_idx_xy, centroidFr_idx_onOff] = compute_centroid(fixMS_idx_onOff, fixFr_idx_onOff, t, x);

numFix = size(fixMS_idx_onOff, 1);

newFixMS_idx_onOff = [];

buildingNewFix = 0;

newFixIdx = 1;
fixIdx = 1;

while( fixIdx < numFix)
    
    % buildingNewFix makes sure to retain the starting time of a fix
    % that is being constructed
    
    if( buildingNewFix == 0 )
        % Record fix data in newFix
        newFixMS_idx_onOff(newFixIdx,:) = fixMS_idx_onOff(fixIdx,:);
        newFixFr_idx_onOff(newFixIdx,:) = fixFr_idx_onOff(fixIdx,:);
        buildingNewFix = 1;
    end
        
    % Recalc centroid each round so it reflects fixation as it expands during building
    fixFrList = newFixFr_idx_onOff(newFixIdx,1):newFixFr_idx_onOff(newFixIdx,2);
    fix1Centroid_xy = mean(x(fixFrList,:), 1);
    
    % Get info of next fixation 
    fix2MS_onOff = fixMS_idx_onOff(fixIdx+1,:);
    fix2Fr_onOff = fixFr_idx_onOff(fixIdx+1,:);
    fix2Centroid_xy = centroidDegs_idx_xy(fixIdx+1,:);
    
    % check space and time
    if(  norm( fix1Centroid_xy - fix2Centroid_xy) <= space_thresh && ...
            fix2MS_onOff(1) - newFixMS_idx_onOff(newFixIdx,2) <= t_thresh)
       
        % Clump by extending end of fix 1 to end of fix2
        newFixMS_idx_onOff(newFixIdx,2) = fixMS_idx_onOff(fixIdx+1,2);
        newFixFr_idx_onOff(newFixIdx,2) = fixFr_idx_onOff(fixIdx+1,2);
       
        %display('Clumped')
        fixIdx = fixIdx+1; % Check next fix after fix1
        
    else
        
        % Gap too long, or centroids too far away to clump
        
        fixIdx = fixIdx+1; % Check next fix after fix1
        buildingNewFix = 0; % Start new entry in newFix 
        newFixIdx = newFixIdx+1;
        
    end
end



