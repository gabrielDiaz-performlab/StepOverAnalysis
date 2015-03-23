function [sessionData figH] = findSteps(sessionData, trialNum, plotOn)

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
% Simplified syntax.
% Added a height threshold saved in through to loadParameters



%% Calculate mean of rigid body positions

spine_fr_xyz = squeeze(nanmean(sessionData.processedData_tr(trialNum).spine_fr_mkr_XYZ,2));
rightFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).rightFoot_fr_mkr_XYZ(:,[1 4],:),2));
leftFoot_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).leftFoot_fr_mkr_XYZ(:,[1 4],:),2));
head_fr_XYZ = squeeze(nanmean(sessionData.processedData_tr(trialNum).head_fr_mkr_XYZ(:,[4 5],:),2));

sessionData.processedData_tr(trialNum).spine_fr_xyz = spine_fr_xyz;
sessionData.processedData_tr(trialNum).rightFoot_fr_XYZ = rightFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).leftFoot_fr_XYZ = leftFoot_fr_XYZ;
sessionData.processedData_tr(trialNum).head_fr_XYZ = head_fr_XYZ;



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


%% Find frames when foot is under a height threshold 

rFootHeight_fr =  rightFoot_fr_XYZ(:,3);
lFootHeight_fr =  leftFoot_fr_XYZ(:,3);

lFootUnderHeightThresh_idx = find( lFootHeight_fr < footHeightThresh );
lFootAboveHeightThresh_idx = find( lFootHeight_fr >= footHeightThresh);

rFootUnderHeightThresh_idx = find( rFootHeight_fr < footHeightThresh);
rFootAboveHeightThresh_idx = find( rFootHeight_fr >= footHeightThresh);

%% Find zero crossings of foot velocity, with direction (e.g. neg to pos)

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



% Vectors for toe-offs and heel-strikes
rTO = [];
rHS = [];

lTO = [];
lHS = [];

% The for loop is state-dependent. 
rightlookingfor = 2; %if == 1, looking for a step start. If == 2, looking for a toe off
leftlookingfor = 2;

maxIndex = max([ lAnkVelY_upIdx lAnkVelY_downIdx rAnkVelY_upIdx rAnkVelY_downIdx]);
for i = 1:maxIndex
    
    % Find a right toe off 
    % 1: TO finding algorithm: find a zero crossing in velocity (- to +)
    % 2: Find the LAST of previous frames when foot was under threshold
    if rightlookingfor == 2 && rUpIter <= numel(rAnkVelY_upIdx)
        
        nextRTO = rFootUnderHeightThresh_idx( find( rFootUnderHeightThresh_idx <= rAnkVelY_upIdx(rUpIter),1,'last')) -1;
        rTO = [ rTO nextRTO ];
        
        rUpIter = rUpIter + 1;
        rightlookingfor = 1;
        
    end
    
    % Find a left TO
    if leftlookingfor == 2 && lUpIter <= numel(lAnkVelY_upIdx)
        
        nextLTO = lFootUnderHeightThresh_idx( find( lFootUnderHeightThresh_idx <= lAnkVelY_upIdx(lUpIter),1,'last')) -1;
        
        lTO = [ lTO nextLTO];
        lUpIter = lUpIter  + 1;
        leftlookingfor = 1;
        
    end
    
    % Find a right HS
    % 1: HS finding algorithm: find a zero crossing in velocity (+ to -)
    % 2: Find the FIRST of following frames that foot is under threshold
    if rightlookingfor == 1 && rDownIter <= numel(rAnkVelY_downIdx)
        
        nextRHS = rFootUnderHeightThresh_idx( find(rFootUnderHeightThresh_idx >= rAnkVelY_downIdx(rDownIter),1,'first')) -1 ;
        
        rHS = [ rHS nextRHS];
        rDownIter = rDownIter + 1;
        rightlookingfor = 2;
        
    end
    
    % Find a left HS
    if leftlookingfor == 1 && lDownIter <= numel(lAnkVelY_downIdx)
        
        nextLHS = lFootUnderHeightThresh_idx(find( lFootUnderHeightThresh_idx >= lAnkVelY_downIdx(lDownIter),1,'first')) -1;
        lHS = [ lHS nextLHS];
        lDownIter = lDownIter + 1;
        leftlookingfor = 2;
        
    end
end

%% Some cleanup
% Make sure the first event is a toe off, and last is a heel strike

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
    
    waitforbuttonpress
end

sessionData.dependentMeasures_tr(trialNum).rightToeOff_idx = rTO;
sessionData.dependentMeasures_tr(trialNum).rightHeelStrike_idx = rHS;

sessionData.dependentMeasures_tr(trialNum).leftToeOff_idx = lTO;
sessionData.dependentMeasures_tr(trialNum).leftHeelStrike_idx = lHS;

end
