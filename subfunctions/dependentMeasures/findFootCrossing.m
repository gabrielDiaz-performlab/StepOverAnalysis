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

%trialStruct = sessionData.rawData_tr(trIdx);
procData = sessionData.processedData_tr(trIdx);
rawData = sessionData.rawData_tr(trIdx);

%FIXME: Obstacle has no width

obstacleFront_Y = rawData.obstacle_XposYposHeight(2) - obsLW(2)/2;

% Get marker data for all markers on the feet
rightFoot_fr_mkr_XYZ = procData.rightFoot_fr_mkr_XYZ;
leftFoot_fr_mkr_XYZ = procData.leftFoot_fr_mkr_XYZ;

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

if( isempty(rightFootCrossingFr) )
    rightFootCrossingStepIdx  = NaN;
else
    rightFootCrossingStepIdx = intersect(find( rTO_sIdx < rightFootCrossingFr,1,'last'), find( rHS_sIdx > rightFootCrossingFr,1,'first'));
end

lTO_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;
lHS_sIdx = sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx;

if( isempty(rightFootCrossingFr) )
    leftFootCrossingStepIdx= NaN;
else
    leftFootCrossingStepIdx = intersect(find( lTO_sIdx < leftFootCrossingFr,1,'last'), find( lHS_sIdx > leftFootCrossingFr,1,'first'));
end

%%
% % These vectors are the sorted combination of left and right tO / HS
% % Equal to sort( [sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx ...
% % sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx])
% 
% bothTO_sIdx = sessionData.dependentMeasures_tr(trIdx).bothFeet.toeOff_idx;
% bothHS_sIdx = sessionData.dependentMeasures_tr(trIdx).bothFeet.heelStrike_idx;
% 
% firstCrossingFrame = min( [rightFootCrossingFr leftFootCrossingFr]);
% 
% if( isempty(firstCrossingFrame ) )
%     bothFeetCrossingStepIdx= NaN;
% else
%     % intersect the last toe-off before the cross with the
%     % first heel strike after the cross
%     bothFeetCrossingStepIdx = intersect( find( bothTO_sIdx < firstCrossingFrame ,1,'last'), find( bothHS_sIdx > firstCrossingFrame  ,1,'first'));
%     
%     if( isempty( bothFeetCrossingStepIdx ) )
%         keyboard
%     end
% end


%% Here is where variables are saved out to sessionData.
% This should happen in one place, for simplicity.

sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr = rightFootCrossingFr;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr = leftFootCrossingFr;

sessionData.dependentMeasures_tr(trIdx).rFoot.firstCrossingMkrIdx = rightFootMkrIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.firstCrossingMkrIdx = leftFootMkrIdx;

sessionData.dependentMeasures_tr(trIdx).rFoot.crossingStepIdx = rightFootCrossingStepIdx;
sessionData.dependentMeasures_tr(trIdx).lFoot.crossingStepIdx  = leftFootCrossingStepIdx;

sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot = firstCrossingFoot;
% sessionData.dependentMeasures_tr(trIdx).bothFeet.crossingStepIdx = bothFeetCrossingStepIdx;

%%

% display 'In findFootOverPattern: rightFootCrossingFr, leftFootCrossingFr, rightFootMkrIdx, leftFootMkrIdx, firstCrossingFoot'
% 
% if( plotData == 1)
%    
%     figH = plotTrialMarkers(sessionData,trIdx); 
%     
%     procData = sessionData.processedData_tr(trIdx);
%     scatter3( procData.leftFoot_fr_XYZ(:,1), procData.leftFoot_fr_XYZ(:,2),procData.leftFoot_fr_XYZ(:,3),100,'g','*','filled')
%     
%     footPos_XYZ = squeeze(mean(trialData.rightFoot_fr_mkr_XYZ(frIdx,[ 1 3], :)));
%     footSize_LWH = [.25 .1 .07];
%     rotMat_d1_d2 = squeeze(trialData.rightFootRot_fr_d1_d2(frIdx,:,:));
%     rFootBox = plotBox(figure1,footPos_XYZ,footSize_LWH,rotMat_d1_d2,'r');
% 
%     if( strcmp(firstCrossingFoot,'right') )
%         
%         title('The right crossed first')
%     
%     elseif( strcmp(firstCrossingFoot,'left') )
%     
%         title('The left crossed first')
%     
%     else
%         title('First foot = error.  Check code')
%     end
%     
% end

% %%
% if( plotData == 1)
%     
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




