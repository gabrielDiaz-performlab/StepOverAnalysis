function [sessionData figH] = findStepsMod(sessionData, trialNum, plotOn)

if( plotOn)
    figH = figure(3);
    clf
else
    figH = []
end

loadParameters

if nargin < 3
    
    plotOn = 0;
    
end

%% 26 June 2012 - Jonathan Matthis
%
% This function finds steps from kinematic data based on a algorthm
% presented in Zeni et al 2008 in Gait and Posture.
%
% The basic idea is to first situate the data by subtracting the x & y
% coordinates of the Root marker from each marker position at each frame,
% essentially setting the origin to the subject's root.
%
% The velocity of each foot in the X direction is then calculated. Zero
% crossings (within a band from Zero) are either toe-offs or heel strikes.
% Positive to Negative denotes heel strike, Negative to Positive denotes
% Toe off.
%
% (Description written before code, UPDATE WHEN CODE FINISHED)
%
%% 3 February 2015 - Melissa Parade
%
% Modified for data logged in through vizard for VR Obstacle Crossing Exp

% Slightly different strategy than findStepsZeni:
% look for each pos-to-neg or neg-to-pos velocity crossing in the data,
% run through a series of checks afterwards to remove false TO/HSs.

% Assume: unfiltered/unprocessed data
% Assume: marker data in individual structs within a, rather than in matrix

%% 20 March - Gabriel Diaz
% Simplified code dramatically, likely at a cost.
% Added a height threshold saved in through to loadParameters
% 
% trialData = sessionData.rawData_tr(trialNum);
% 
% spine_fr_mkr_XYZ = trialData.spine_fr_mkr_XYZ;
% 
% % Set average spine position over time
% spine_fr_xyz = squeeze(nanmean(spine_fr_mkr_XYZ,2));
% 
% startXY = spine_fr_xyz(1,1:2);
% endXY = spine_fr_xyz(end,1:2);
% 
% % Calculate average foot position over time
% rightFoot_fr_XYZ = squeeze(nanmean(trialData.rightFoot_fr_mkr_XYZ(:,[1 4],:),2));
% leftFoot_fr_XYZ = squeeze(nanmean(trialData.leftFoot_fr_mkr_XYZ(:,[1 4],:),2));
% 
% 
% sessionData.rawData_tr(trialNum).spine_fr_xyz = spine_fr_xyz;
% sessionData.rawData_tr(trialNum).rightFoot_fr_XYZ = rightFoot_fr_XYZ;
% sessionData.rawData_tr(trialNum).leftFoot_fr_XYZ = leftFoot_fr_XYZ;

% %%
% 
% %%
% % findSamplingRate: estimates sampling rate from data for use in
% % filter, necessary b/c of variable sampling rate for vizard log
% 
% samplingRate = 1 / mean(diff(trialData.frameTime_fr));
% 
% %function [smoothedData] = butterLowZero( order, cutoff, sampleRate, x)
% 
% rightFoot_fr_XYZ = butterLowZero(order,cutoff,samplingRate, rightFoot_fr_XYZ);
% sessionData.filtData_tr(trialNum).rightFoot_fr_XYZ = rightFoot_fr_XYZ ;
% 
% leftFoot_fr_XYZ = butterLowZero(order,cutoff,samplingRate, leftFoot_fr_XYZ);
% sessionData.filtData_tr(trialNum).leftFoot_fr_XYZ = leftFoot_fr_XYZ ;
% 
% spine_fr_xyz  = butterLowZero(order,cutoff,samplingRate, spine_fr_xyz );
% sessionData.filtData_tr(trialNum).spine_fr_xyz  = spine_fr_xyz  ;
% 
% %rAnkX = rightFoot_fr_XYZ(:,1);
%lAnkX = leftFoot_fr_XYZ(:,1);

%loopLength = min ([length(rightFoot_fr_XYZ), length(leftFoot_fr_XYZ), length(spine_fr_xyz)]);

%%

spine_fr_xyz = squeeze(nanmean(sessionData.processedData_tr(trialNum).spine_fr_mkr_XYZ,2));
rightFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).rightFoot_fr_mkr_XYZ(:,[1 4],:),2));
leftFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).leftFoot_fr_mkr_XYZ(:,[1 4],:),2));
head_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).head_fr_mkr_XYZ(:,[4 5],:),2));

sessionData.processedData_tr(trialNum).spine_fr_xyz = spine_fr_xyz;
sessionData.processedData_tr(trialNum).rightFoot_fr_XYZ = rightFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).leftFoot_fr_XYZ = leftFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).head_fr_XYZ = head_fr_XYZ;

%%

rFootHeight_fr =  rightFoot_fr_XYZ(:,3);
lFootHeight_fr =  leftFoot_fr_XYZ(:,3);

% Cast foot data into a spine-centered frame of reference
rightFoot_fr_XYZ = rightFoot_fr_XYZ - spine_fr_xyz;
leftFoot_fr_XYZ = leftFoot_fr_XYZ - spine_fr_xyz;

% Calculate velocities along the Y axis
spineVelY = diff(spine_fr_xyz(:,2)) ./ diff( spine_fr_xyz(:,1));

%%
%find frame wherein feet are moving
%timeElapsed_fr = [1/60 diff(trialData.frameTime_fr)];

samplingRate = 1 / mean(diff(sessionData.rawData_tr(1).frameTime_fr));

rAnkVelY = [0 diff(rightFoot_fr_XYZ(:,2))'] ./ samplingRate;
lAnkVelY = [0 diff(leftFoot_fr_XYZ(:,2))'] ./ samplingRate;

%%
% Vectors for toe-offs and heel-strikes
rTO = [];
rHS = [];

lTO = [];
lHS = [];

rightlookingfor = 2; %if == 1, looking for a step start. If == 2, looking for a toe off
leftlookingfor = 2;



%%
% Find where x  is crossing zero in thepositive and negative direction
x = diff(sign(rAnkVelY));
rAnkVelY_upIdx = find(x >0) +1;
rAnkVelY_downIdx= find(x <0) +1;
rUpIter = 1;
rDownIter = 1;

x = diff(sign(lAnkVelY));
lAnkVelY_upIdx = find(x >0) +1;
lAnkVelY_downIdx= find(x <0) +1;

lUpIter = 1;
lDownIter = 1;

lFootUnderHeightThresh_idx = find( lFootHeight_fr < footHeightThresh );
lFootAboveHeightThresh_idx = find( lFootHeight_fr >= footHeightThresh);

rFootUnderHeightThresh_idx = find( rFootHeight_fr < footHeightThresh);
rFootAboveHeightThresh_idx = find( rFootHeight_fr >= footHeightThresh);

% That will give you the crossing points and their direction.
% In your loop where you add samples, just test x for the current point
% and the last point. If it's zero, keep going. If it's positive, add on your
% 8000 points and go back to testing. If it's negative, stop.

% find a zero crossing of velocity in the positive direction

maxIndex = sum([ lAnkVelY_upIdx lAnkVelY_downIdx rAnkVelY_upIdx rAnkVelY_downIdx]);
%min([ length(rAnkVelY), length(lAnkVelY), length(spine_fr_xyz) ]);

for i = 1:maxIndex
    
    % looking for right TO
    if rightlookingfor == 2 && rUpIter <= numel(rAnkVelY_upIdx)
        
        nextRTO = rFootUnderHeightThresh_idx( find( rFootUnderHeightThresh_idx <= rAnkVelY_upIdx(rUpIter),1,'last')) -1;
        %nextRTO = rAnkVelY_upIdx(rUpIter);
        rTO = [ rTO nextRTO ];
        
        rUpIter = rUpIter + 1;
        rightlookingfor = 1;
        
    end
    
    if leftlookingfor == 2 && lUpIter <= numel(lAnkVelY_upIdx)
        
        
        nextLTO = lFootUnderHeightThresh_idx( find( lFootUnderHeightThresh_idx <= lAnkVelY_upIdx(lUpIter),1,'last')) -1;
        
        lTO = [ lTO nextLTO];
        lUpIter = lUpIter  + 1;
        leftlookingfor = 1;
        
    end
    
    
    if rightlookingfor == 1 && rDownIter <= numel(rAnkVelY_downIdx)
        
        nextRHS = rFootUnderHeightThresh_idx( find(rFootUnderHeightThresh_idx >= rAnkVelY_downIdx(rDownIter),1,'first')) -1 ;
        
        rHS = [ rHS nextRHS];
        rDownIter = rDownIter + 1;
        rightlookingfor = 2;
        
    end
    
    
    if leftlookingfor == 1 && lDownIter <= numel(lAnkVelY_downIdx)
        
        nextLHS = lFootUnderHeightThresh_idx(find( lFootUnderHeightThresh_idx >= lAnkVelY_downIdx(lDownIter),1,'first')) -1;
        lHS = [ lHS nextLHS];
        lDownIter = lDownIter + 1;
        leftlookingfor = 2;
        
    end
    
end

%
% % Make sure the first event is a toe off, and last is a heel strike

while( lTO(1) > lHS(1) )
    lHS(1) = [];
end

while( rTO(1) > rHS(1) )
    rHS(1) = [];
end

while( lTO(end) > lHS(end)  )
    lTO(end) = [];
end

while( rTO(end) > rHS(end) )
    rTO(end) = [];
end


if plotOn == 1
    
    %%
    figure(3)
    
    subplot(211)
    hold on
    grid on
    ylim([-.7, 1])
    title('Normalized foot velocity in spine-based FOR')
    xlabel('Frame')
    ylabel('normalized velocity')
    
    plot((rAnkVelY*samplingRate)./ max(abs(rAnkVelY*samplingRate)),'c')
    plot((lAnkVelY*samplingRate)./ max(abs(lAnkVelY*samplingRate)),':m')
    legend('right','left','location','Best')
    
    hline(0,'k')
    
    
    for idx = 1:numel(rTO)
        vline(rTO(idx),'g',2,'-')
    end
    
    for idx = 1:numel(rHS)
        vline(rHS(idx),'r',2,'-')
    end
    
    for idx = 1:numel(lTO)
        vline(lTO(idx),'g',2,':')
    end
    
    for idx = 1:numel(lHS)
        vline(lHS(idx),'r',2,':')
    end
    
    subplot(212)
    hold on
    grid on
    ylim([0, .7])
    title('Vertial foot position')
    xlabel('Frame')
    ylabel('m')
    
    plot(rFootHeight_fr,'c');
    plot(lFootHeight_fr,'m:');
    
    hline(footHeightThresh,'y')
    legend('right','left','threshold height','location','Best')
    
    for idx = 1:numel(rTO)
        vline(rTO(idx),'g',2,'-')
    end
    
    for idx = 1:numel(rHS)
        vline(rHS(idx),'r',2,'-')
    end
    
    for idx = 1:numel(lTO)
        vline(lTO(idx),'g',2,':')
    end
    
    for idx = 1:numel(lHS)
        vline(lHS(idx),'r',2,':')
    end
    
    figDir = sprintf('outputFigures/StepFigs/%s/',sessionData.fileID);
    [junk junk] = mkdir(figDir );
    set(3,'Units','Normalized','Position',[0.0923611111111111 0.211111111111111 0.838888888888889 0.673333333333333]);
    saveas(figH,sprintf('%s%u.png',figDir,trialNum));
    
end

sessionData.dependentMeasures_tr(trialNum).rightToeOff_idx = rTO;
sessionData.dependentMeasures_tr(trialNum).rightHeelStrike_idx = rHS;

sessionData.dependentMeasures_tr(trialNum).leftToeOff_idx = lTO;
sessionData.dependentMeasures_tr(trialNum).leftHeelStrike_idx = lHS;

end

%% unite or remove orphan toe offs and heel stikes

% Remove steps that are shorter than 100 ms (12 frames)
% Remove steps with Negative duration (rDur > 0)


% %% Clean up found steps
%
% try
%
%     %% unite or remove orphan toe offs and heel stikes
%
%     if numel(rTO) > numel(rHS)
%         found = 0;
%         % look for a HS that was not caught
%
%         for i = rTO(end):length(rAnkVelX)
%             if rAnkVelX(i-1) > 0 && rAnkVelX(i) < 0 && found == 0
%                 rHS(end+1) = i;
%                 found = 1;
%             end
%         end
%
%         if found == 0
%
%             [val1 ind1] = max( rAnkVelX( rTO(end): end));
%             if ind1+rTO < length(rAnkVelX)
%
%
%
%                 [val2 ind2] = min( abs( rAnkVelX( ind1+rTO(end): end)));
%
%                 rHS(end+1) = ind2+ind1+rTO(end);
%             end
%         end
%
%     end
%
%     if numel(lTO) > numel(lHS)
%
%         found = 0;
%         % look for a HS that was not caught
%
%         for i = lTO(end):length(lAnkVelX)
%             if lAnkVelX(i-1) > 0 && lAnkVelX(i) < 0 && found == 0
%                 lHS(end+1) = i;
%                 found = 1;
%             end
%         end
%
%         if found == 0
%
%             [val1 ind1] = max( lAnkVelX( lTO(end): end));
%             if ind1 +lTO < length(lAnkVelX)
%                 [val2 ind2] = min( abs( lAnkVelX( ind1+lTO(end): end)));
%
%
%                 lHS(end+1) = ind2+ind1+lTO(end);
%             end
%
%         end
%
%     end
%
%     if numel(rTO) > numel(rHS)
%         if numel(rTO) ~= numel(rHS)+1
%             keyboard
%         else
%             rTO(end) = [];
%         end
%     end
%
%     if numel(lTO) > numel(lHS)
%         if numel(lTO) ~= numel(lHS)+1
%             keyboard
%         else
%             lTO(end) = [];
%         end
%     end
%
%
%     rTOtemp = rTO(1:2);
%     rHStemp = rHS(1:2);
%     lTOtemp = lTO(1:2);
%     lHStemp = lHS(1:2);
%
%
%
%     for i = 3:numel(rTO)
%
%
%         if ( rTO(i) - rHS(i-1) ) < ( rHS(i-1) - rTO(i-1) )
%             %&& ( rTO(i) - rHS(i-1) ) < ( rHS(i) - rTO(i) )
%
%             rHStemp(end) = rHS(i);
%
%         else
%
%             rTOtemp(end+1) = rTO(i);
%             rHStemp(end+1) = rHS(i);
%
%         end
%
%     end
%
%
%     for i = 3:numel(lTO)
%
%
%         if ( lTO(i) - lHS(i-1) ) < ( lHS(i-1) - lTO(i-1) )
%             %&& ( lTO(i) - lHS(i-1) ) < ( lHS(i) - lTO(i) )
%
%             lHStemp(end) = lHS(i);
%
%         else
%
%             lTOtemp(end+1) = lTO(i);
%             lHStemp(end+1) = lHS(i);
%
%         end
%
%     end
%
%     rTO = rTOtemp;
%     rHS = rHStemp;
%     lTO = lTOtemp;
%     lHS = lHStemp;
%
%     %% JSM checks -- replaced by MSP checks?
%     % %     if rHS(1)< rTO(1)
%     % %         keyboard
%     % %         rHS(1) = [];
%     % %     end
%     % %
%     % %     if rTO(end) > rHS(end)
%     % %         keyboard
%     % %         rTO(end) = [];
%     % %     end
%     % %
%     % %     if lHS(1)< lTO(1)
%     % %         keyboard
%     % %         lHS(1) = [];
%     % %     end
%     % %
%     % %     if lTO(end) > lHS(end)
%     % %         keyboard
%     % %         lTO(end) = [];
%     % %     end
%     % %
%     % %     if numel(rTO) > numel(rHS)
%     % %         keyboard
%     % %         if rHS(1) - rTO(1) > rTO(2) - rTO(1) %if the time between rTO(1) and rHS(1) is larger than rTO(1) and rTO(2), remove rTO(1)
%     % %             rTO(1) = [];
%     % %         else rTO(end) = []; %otherwise, the rTO(end) is the problem
%     % %         end
%     % %     end
%     % %
%     % %     if numel(lTO) > numel(lHS)
%     % %         keyboard
%     % %         if lHS(1) - lTO(1) > lTO(2) - lTO(1) %if the time between lTO(1) and lHS(1) is larger than lTO(1) and lTO(2), remove lTO(1)
%     % %             lTO(1) = [];
%     % %         else lTO(end) = [];
%     % %         end
%     % %     end
%     % %
%     % %
%     % %     if numel(rHS) > numel(rTO)
%     % %         keyboard
%     % %         if rHS(1) < rTO(1)
%     % %             rHS(1) = [];
%     % %         else    rHS(end) = [];
%     % %         end
%     % %     end
%     % %
%     % %     if numel(lHS) > numel(lTO)
%     % %         keyboard
%     % %         if lHS(1) < lTO(1)
%     % %             lHS(1) = [];
%     % %         else lHS(end) = [];
%     % %         end
%     % %     end
%     % %
%     % %
%     % %     while numel(rHS) ~= numel(rTO)
%     % %         keyboard
%     % %
%     % %         if (rHS(1) < rTO(1))
%     % %             rHS(1) =[];
%     % %         end
%     % %
%     % %         if (rTO(end) > rHS(end))
%     % %             rTO(end) =[];
%     % %         end
%     % %
%     % %         if numel(rHS) > numel(rTO)
%     % %             rHS(end) = [];
%     % %         end
%     % %
%     % %         if numel(rTO) > numel(rHS)
%     % %             rTO(end) = [];
%     % %         end
%     % %
%     % %     end
%     % %
%     % %
%     % %     while numel(lHS) ~= numel(lTO)
%     % %         keyboard
%     % %
%     % %         if (lHS(1) < lTO(1))
%     % %             lHS(1) =[];
%     % %         end
%     % %
%     % %
%     % %         if (lTO(end) > lHS(end))
%     % %             lTO(end) =[];
%     % %         end
%     % %
%     % %         if numel(lHS) > numel(lTO)
%     % %             lHS(end) = [];
%     % %         end
%     % %
%     % %         if numel(lTO) > numel(lHS)
%     % %             lTO(end) = [];
%     % %         end
%     % %
%     % %     end
%
%
%
%     rightTO_HS(:,1) = rTO;
%     rightTO_HS(:,2) = rHS;
%
%     leftTO_HS(:,1) = lTO;
%     leftTO_HS(:,2) = lHS;
%
%
%     %remove steps that are shorter than 100 ms (12 frames), steps with Negative
%     %duration (rDur > 0)
%
%     rDur = rightTO_HS(:,1)-rightTO_HS(:,2);
%     rightTO_HS(rDur > 0 ,:) = [];
%
%     lDur = leftTO_HS(:,1)-leftTO_HS(:,2);
%     leftTO_HS(lDur > 0,:) = [];
%
%
%     if plotOn == 1
%         keyboard
%         figure(4)
%
%         subplot(211)
%         hold on
%         plot(rAnkVelX,'r')
%         plot(RANKt(:,3),'r')
%         hold on
%         plot(rightTO_HS(:,1),0,'ko')
%         plot(rightTO_HS(:,2),0,'kx')
%         grid on
%
%
%         subplot(212)
%         hold on
%         plot(lAnkVelX, 'b')
%         plot(LANKt(:,3),'b')
%         hold on
%         plot(leftTO_HS(:,1),0,'ko')
%         plot(leftTO_HS(:,2),0,'kx')
%         grid on
%         % %
%         % % waitforbuttonpress
%         % % close all
%
%     end
%
%
%
%     sessionData.(trialNum).rightTO_HS = rightTO_HS;
%     sessionData.(trialNum).leftTO_HS = leftTO_HS;
%
% catch ME
%
%     ME
%
%     disp('In findStepsMod')
%     sessionData.(trialNum).rightTO_HS = [];
%     sessionData.(trialNum).leftTO_HS = [];
%
% end
%
% end
%end