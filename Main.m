
%FIXME:  Python variable sugests quat form of WXYZ, but it is in XYZW
%FIXME:  Python obstacle_XYZ is actually Xpos, Ypos, Height

%%%%%%%%%%%%
%FIXME:  Python output needs:
%FIXME:  Rigid body posiion should be passed in from vizard (start of trial)
%FIXME:  Rigid body sizes should be passed in from vizard (start of trial)
%FIXME:  Block index and numBlocks
%FIXME:  numTrialTypes
%FIXME:  marker condition
%%%%%%%%%%%

clc
clear all
close all

loadParameters

% You just need to pass the .mat file name and the experiment Data structure will be generated
sessionNumber = 1;

%sessionData = struct;
%sessionData.fileID = dataFileList{sessionNumber};

parseTextFileToMat(sessionNumber)

dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})
%%

sessionData = generateRawData(dataFileString);
sessionData.expInfo.fileID = dataFileList{sessionNumber};

%%
sessionData.expInfo.numConditions = 2;
sessionData.expInfo.numObsHeights = 3;

sessionData.expInfo

%% Interpolate and filter

% It seems that data is already interpolated.
% Evidence?  THe NaNs are in the start of the first trial.
% I should probably try and turn this off and see what happens,
% Or import marker condition

sessionData = interpolateMocapData(sessionData, 0);
sessionData = filterMocapData(sessionData, 0);

%% Some methods for plotting a trial

plotTrialMarkers(sessionData,2)
%plotTrialRigid(sessionData,2)

%% Some per-trial functions

for trIdx = 1:numel(sessionData.rawData_tr)

    [ sessionData ] = findSteps(sessionData, trIdx, 0);
    [ sessionData ] = findFootCrossing(sessionData, trIdx,0);
    
    [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
    [ sessionData ] = stepLengthAndDur(sessionData,trIdx);
    
end


%% Make some figures

dm = sessionData.dependentMeasures_tr;
xData = sessionData.expInfo.obsHeightRatios;
%%

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.leadToeZASO],'leadToeZASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
leadToeZASO = plot_cIdx_hIdx(xData,ss.meanLeadToeZASO_cIdx_hIdx,ss.stdLeadToeZASO_cIdx_hIdx,'obstacle height','toeZ ASO');
title('Height ASO')

%%

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dm.leadToeZASO],'leadToeZClearanceASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
leadToeZASO = plot_cIdx_hIdx(xData,ss.meanLeadToeZASO_cIdx_hIdx,ss.meanLeadToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','toeZ ASO (m)');
title('Clearance ASO')


%%
% Group trials by condition and obs height and take the average
% Note that sessionData.dependentMeasures_tr.bothFeet, or dm.bothFeet
% returns a bunch of structs.  You can turn them into an array using [] 
dmBoth_tr = [dm.bothFeet];

sessionData = mean_cIdx_hIdx(sessionData,[dmBoth_tr.stepDur_sIdx],'leadToeZClearanceASO');

% Plot the mean / std calculated above
ss = sessionData.summaryStats;
leadToeZASO = plot_cIdx_hIdx(xData,ss.meanLeadToeZASO_cIdx_hIdx,ss.meanLeadToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','toeZ ASO (m)');
title('Clearance ASO')

%%

dmBothFeet = [sessionData.dependentMeasures_tr.bothFeet];

% Group trials by condition and obs height and take the average
sessionData = mean_cIdx_hIdx(sessionData,[dmBothFeet.stepDur_sIdx],'bothFeetStepDur');
ss = sessionData.summaryStats;

% Plot the mean / std calculated above
leadToeZASO = plot_cIdx_hIdx(xData,ss.meanBothFeetStepDur_cIdx_hIdx,ss.stdBothFeetStepDur_cIdx_hIdx,'obstacle height (m)','step duration (s)');

%leadToeZASO2 = plot_cIdx_hIdx(sessionData,'leadToeZClearanceASO',sessionData.expInfo.obsHeightRatios,'obstacle height','toeZ clearance ASO');
title('Step Duration')
