%%
% I think that, sometimes a collision is the cause of a tracked
% marker teleporting to (0,0,0).  To deal with this, make sure
% collisions only occur on those trials

function [sessionData] = checkForCollision(sessionData,trIdx)


loadParameters

rawData = sessionData.rawData_tr(trIdx);
procData = sessionData.processedData_tr(trIdx);

%% Now, exclude collision trials from analysis
if( numel(sessionData.rawData_tr(trIdx).rightFootCollisions_idx) > 0 || ...
        numel(sessionData.rawData_tr(trIdx).leftFootCollisions_idx ) > 0 )
    
    sessionData.rawData_tr(trIdx).hasCollision  = 1;
    sessionData.rawData_tr(trIdx).excludeTrial = 1;
    sessionData.rawData_tr(trIdx).excludeTrialExplanation = 'checkForCollisions: Collision detected.';
    
else
    
    sessionData.rawData_tr(trIdx).hasCollision = 0;
end

