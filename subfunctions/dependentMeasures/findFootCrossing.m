function sessionData = findFootCrossing( sessionData, trIdx , plotData )

% Kamran Binaee
% Find when each foot breaks the plane of the obstacle first
% Identify which one crosses first
%FIXME:  Add plotting functionality to validate process

if(sum(strcmp(fieldnames(sessionData),'dependentMeasures_tr'))==0)
    fprintf('Must run findSteps.m prior to findFootCrossing.m \n')
    return
end

%FINDTOECLEARANCE Summary of this function goes here
%   Detailed explanation goes here

loadParameters

trialStruct = sessionData.rawData_tr(trIdx);

%FIXME: Obstacle has no width

obstacleFront_Y = trialStruct.obstacle_XposYposHeight(2) - obsLW(2)/2;

% Get marker data for all markers on the feet
rightFoot_fr_mkr_XYZ = trialStruct.rightFoot_fr_mkr_XYZ;
leftFoot_fr_mkr_XYZ = trialStruct.leftFoot_fr_mkr_XYZ;

% Grab the position on Y axis
rightFootY_frIdx_mIdx = squeeze(rightFoot_fr_mkr_XYZ(:,:,2));
leftFootY_frIdx_mIdx = squeeze(leftFoot_fr_mkr_XYZ(:,:,2));

% Find the Y data of the foot marker that is furthest up the Y axis
[ rightFootMaxY_frIdx,maxRightMkrIdx_fr] = max(rightFootY_frIdx_mIdx,[],2);
[ leftFootMaxY_frIdx, maxLeftMkrIdx_fr] = max(leftFootY_frIdx_mIdx,[],2);

%%  Find frames and markerIDX of first crossing

rightFootCrossingFr = find( rightFootMaxY_frIdx > obstacleFront_Y ,1,'first');
leftFootCrossingFr = find( leftFootMaxY_frIdx > obstacleFront_Y ,1,'first');

rightFootMkrIdx = maxRightMkrIdx_fr(rightFootCrossingFr);
leftFootMkrIdx = maxLeftMkrIdx_fr(leftFootCrossingFr);


%%  Record which foot crossed first
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

%%  Find step in which crossing ocurred


rTO_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx;
rHS_sIdx = sessionData.dependentMeasures_tr(trIdx).rFoot.heelStrike_idx;

rightFootCrossingStepIdx = intersect(find( rTO_sIdx < rightFootCrossingFr,1,'last'), find( rHS_sIdx > rightFootCrossingFr,1,'first'));

lTO_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;
lHS_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx;

leftFootCrossingStepIdx = intersect(find( lTO_sIdx < leftFootCrossingFr,1,'last'), find( lHS_sIdx > leftFootCrossingFr,1,'first'));

bothTO_sIdx = sessionData.dependentMeasures_tr(trIdx).bothFeet.toeOff_idx;
bothHS_sIdx = sessionData.dependentMeasures_tr(trIdx).bothFeet.heelStrike_idx;
firstCrossingFrame = min( [rightFootCrossingFr leftFootCrossingFr]);

bothFeetCrossingStepIdx = intersect(find( bothTO_sIdx < firstCrossingFrame ,1,'last'), find( bothHS_sIdx > firstCrossingFrame  ,1,'first'));

%% Here is where variables are saved out to sessionData.
% This should happen in one place, for simplicity.



sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr = rightFootCrossingFr;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr = leftFootCrossingFr;

sessionData.dependentMeasures_tr(trIdx).rFoot.firstCrossingMkrIdx = rightFootMkrIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.firstCrossingMkrIdx = leftFootMkrIdx;

sessionData.dependentMeasures_tr(trIdx).rFoot.crossingStepIdx = rightFootCrossingStepIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingStepIdx  = leftFootCrossingStepIdx;


sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot = firstCrossingFoot;


%%
%sessionData.dependentMeasures_tr(trIdx).bothFeet.crossingStepIdx =

%%

%display 'In findFootOverPattern: rightFootCrossingFr, leftFootCrossingFr, rightFootMkrIdx, leftFootMkrIdx, firstCrossingFoot'

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



