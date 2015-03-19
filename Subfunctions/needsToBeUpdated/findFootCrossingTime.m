function sessionData = findFootCrossingTime( sessionData, trIdx )
%Kamran Binaee
% Find when each foot breaks the plane of the obstacle first
% Identify which one crosses first


%FINDTOECLEARANCE Summary of this function goes here
%   Detailed explanation goes here
    
    loadParameters

    trialStruct = sessionData.rawData_tr(trIdx);
    
    %FIXME: Obstacle has no width
    
    obstacleFront_Y = trialStruct.obstacle_XposYposHeight(2) - obsLW(2)/2;
    
    rightFoot_fr_mkr_XYZ = trialStruct.rightFoot_fr_mkr_XYZ;
    rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,:,2));
    [ rightFootMaxY_frIdx,maxRightMkrIdx_fr] = max(rightFootY_frIdx_mIdx,[],2);
    
    leftFoot_fr_mkr_XYZ = trialStruct.leftFoot_fr_mkr_XYZ;
    leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,:,1));
    [ leftFootMaxY_frIdx, maxLeftMkrIdx_fr] = max(leftFootY_frIdx_mIdx,[],2);
    
    %%
    keyboard
    
    rightFootCrossingFr = find( rightFootMaxY_frIdx > obstacleFront_Y ,1,'first');
    leftFootCrossingFr = find( leftFootMaxY_frIdx > obstacleFront_Y ,1,'first');
    
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
        display 'FindToeClearance: No crossing found'!;
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

% %%
% if( showFigures == 1) 
%     figure1 = figure();
%     hold on
%     %subplot(3,1,1)
%     hold on 
%     axis equal
% 
%     % Create axes
%     axes1 = axes('Parent',figure1,'FontWeight','bold','FontSize',12,...
%         'FontName','Arial');
%     view(axes1,[45 14]);
%     grid(axes1,'on');
%     hold(axes1,'all');
%     %axis([-2, 3, -2.5, -0.5, 0,2])
%     axis equal
% 
%     % Create xlabel
%     xlabel('X (m)','FontWeight','bold','FontSize',12,'FontName','Arial');
% 
%     % Create ylabel
%     ylabel('Y (m)','FontWeight','bold','FontSize',12,'FontName','Arial');
% 
%     % Create zlabel
%     zlabel('Z (m)','FontWeight','bold','FontSize',12,'FontName','Arial');
% 
%     rightFootUntilPassage_fr_mkr_XYZ  = trialStruct.rightFoot_fr_mkr_XYZ( 1:rightFootCrossingFr, :,:);
% 
%     plot3(rightFootUntilPassage_fr_mkr_XYZ(:,:,1), rightFootUntilPassage_fr_mkr_XYZ(:,:,3), rightFootUntilPassage_fr_mkr_XYZ(:,:,2));%,'Foot Marker Position', Obstacle_XYZ);
% 
% 
% end
%     
%    
   
    


