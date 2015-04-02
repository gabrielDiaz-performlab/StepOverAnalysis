
%FIXME:  Python variable sugests quat form of WXYZ, but it is in XYZW
%FIXME:  Python obstacle_XYZ is actually Xpos, Ypos, Height

%%%%%%%%%%%%
%FIXME:  Python output needs:
%FIXME:  Rigid body posiion should be passed in from vizard (start of trial)
%FIXME:  Rigid body sizes should be passed in from vizard (start of trial)
%FIXME:  Block index and numBlocks
%FIXME:  numTrialTypes
%FIXME:  marker condition
%FIXME:  leg length ratios
%%%%%%%%%%%

clc
clear all
close all

loadParameters

% You just need to pass the .mat file name and the experiment Data structure will be generated
sessionNumber = 1;

parseTextFileToMat(sessionNumber)

dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

textFileName = dataFileList{sessionNumber};
structFilePath  = [ structFileDir textFileName '-struct.mat'];

%%

sessionFilePath = [ sessionFileDir textFileName '.mat'];
sessionData = generateRawData(sessionFilePath );

%%

sessionData.expInfo.fileID = dataFileList{sessionNumber};

sessionData.expInfo.numConditions = numConditions ;
sessionData.expInfo.numObsHeights = numObsHeights ;

sessionData.expInfo

save(sessionFilePath,'sessionData')


%% Interpolate and filter

% It seems that data is already interpolated.
% Evidence?  THe NaNs are in the start of the first trial.
% I should probably try and turn this off and see what happens,
% Or import marker condition

sessionData = calculateSamplingRate(sessionData);
sessionData = interpolateMocapData(sessionData, 0);
sessionData = filterMocapData(sessionData, 0);

%%

sessionData = avgTrialDuration(sessionData);
sessionData.expInfo.meanTrialDuration

% (40 * 60 ) / 10

%% Some per-trial functions

for trIdx = 1:numel(sessionData.rawData_tr)
    [ sessionData ] = calcMeanRigidBodyPos(sessionData, trIdx);
%     [ sessionData ] = findSteps(sessionData, trIdx, 0);
%     [ sessionData ] = findFootCrossing(sessionData, trIdx,0);
%     [ sessionData ] = stepLengthAndDur(sessionData,trIdx);
%     
%     [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
%     [ sessionData ] = stepLengthAndDurASO(sessionData,trIdx);
%     [ sessionData ] = findCOM(sessionData,trIdx);
%     [ sessionData ] = avgCOMVelocity(sessionData,trIdx);
    
end

% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2);
plotTrialRigid(sessionData,3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures

dm = sessionData.dependentMeasures_tr;
xData = sessionData.expInfo.obsHeightRatios;

%% Lead Toe Height ASO

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.leadToeZASO],'leadToeZASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
fig_leadToeZASO = plot_cIdx_hIdx(xData,ss.meanLeadToeZASO_cIdx_hIdx,ss.stdLeadToeZASO_cIdx_hIdx,'obstacle height','lead toe Z ASO');
title('lead toe height ASO')

%% Lead Toe Clearance ASO

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.leadToeZASO],'leadToeZClearanceASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
fig_leadToeClearanceASO = plot_cIdx_hIdx(xData,ss.meanLeadToeZClearanceASO_cIdx_hIdx,ss.meanLeadToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','toeZ ASO (m)');
title('lead toe clearance ASO')

%% Trail Toe Height ASO

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.trailToeZASO],'trailToeZASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
fig_leadToeZASO = plot_cIdx_hIdx(xData,ss.meanTrailToeZASO_cIdx_hIdx,ss.stdTrailToeZASO_cIdx_hIdx,'obstacle height','trail toe Z ASO');
title('trail toe height ASO')

%% Trail Toe Clearance ASO

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.trailToeZClearanceASO],'trailToeZClearanceASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
fig_leadToeClearanceASO = plot_cIdx_hIdx(xData,ss.meanTrailToeZClearanceASO_cIdx_hIdx,ss.stdTrailToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','toeZ ASO (m)');
title('trail toe clearance ASO')



%% Average step duration

% Group trials by condition and obs height and take the average
% Note that sessionData.dependentMeasures_tr.bothFeet, or dm.bothFeet
% returns a bunch of structs.  You can turn them into an array using [] 
dmBoth_tr = [dm.bothFeet];

sessionData = mean_cIdx_hIdx(sessionData,[dmBoth_tr.stepDur_sIdx],'stepDuration');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
fig_stepDur = plot_cIdx_hIdx(xData,ss.meanLeadToeZASO_cIdx_hIdx,ss.meanLeadToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','toeZ ASO (m)');
title('Step duration')




%% Step duration ASO  
% this one is a bit tricky because the variable of interest (dep. measure)
% is a struct buried withn a list of structs.  Yikes.
% Let me try and break this down for yah...
% We want to get at sessionData.dependentMeasures_tr.bothFeet.stepDur_sIdx
% sessionData = struct
% .dependentMeasures_tr = array of structs N trials long
% ...and within each of these structs is another struct, bothFeet
% bothFeet contains an array stepDur_sIdx.  
% Yikes.  So that's...
% struct.array(1:numTrials).struct.array(1:numSteps)

%%%%% Here's how to get at the data buried in stepDur_sIdx
dmBoth_tr  = [dm.bothFeet]; % Avoids a pesky matlab error.

stepDur_tr_cSIdx = {dmBoth_tr .stepDur_sIdx}; % This creates a vector of cells.  Type in the var to see.
crossingStepIdx_tr = [dmBoth_tr .crossingStepIdx]; 
crossingStepDur_tr = nan(1,numel(stepDur_tr_cSIdx));

for trIdx = 1:numel(stepDur_tr_cSIdx)
    crossingStepDur_tr(trIdx) = stepDur_tr_cSIdx{trIdx}(crossingStepIdx_tr(trIdx));
end

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,crossingStepDur_tr,'bothFeetStepDur');
ss = sessionData.summaryStats;

% Plot the mean / std calculated above
leadToeZASO = plot_cIdx_hIdx(xData,ss.meanBothFeetStepDur_cIdx_hIdx,ss.stdBothFeetStepDur_cIdx_hIdx,'obstacle height (m)','step duration ASO (s)');

%leadToeZASO2 = plot_cIdx_hIdx(sessionData,'leadToeZClearanceASO',sessionData.expInfo.obsHeightRatios,'obstacle height','toeZ clearance ASO');
title('Step Duration ASO')

%%

save(sessionFilePath,'sessionData')
