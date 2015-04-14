
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

%FIXME:  Rigid body - marker positions in a LOCAL frame of reference
% ...or, set interp/post processing to the correct value (better) and save
% condition

%%%%%%%%%%%

clc
clear all
close all

tic

loadParameters

% You just need to pass the .mat file name and the experiment Data structure will be generated
sessionNumber = 2;

dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

%% Generate or open session file struct
sessionData = loadSession(sessionNumber);

%% If you want, you can reset the struct for a fresh analysis
% For example, if you cahnge parameters.  I suggest this is done every
% time, just in case.  

sessionData = cleanSessionData(sessionData);
sessionData = checkForExclusions(sessionData);

% FIXME:  Leg length data in .txt file is not correct!

%% Interpolate and filter

% It seems that data is already interpolated.
% Evidence?  THe NaNs are in the start of the first trial.
% I should probably try and turn this off and see what happens,
% Or import marker condition

sessionData = calculateSamplingRate(sessionData);
sessionData = interpAndFilterData(sessionData, 0); %Fixme - add trialModification messages

%%

sessionData = avgTrialDuration(sessionData);
sessionData.expInfo.meanTrialDuration;


%% Some per-trial functions

for trIdx = 1:numel(sessionData.rawData_tr)
    
    [ sessionData ] = calcMeanRigidBodyPos(sessionData, trIdx);
    
    [ sessionData ] = findSteps(sessionData, trIdx, 0);
    [ sessionData ] = findFootCrossing(sessionData, trIdx,0);
    [ sessionData ] = stepLengthAndDur(sessionData,trIdx);
    
    [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
    
    [ sessionData ] = stepLengthAndDurASO(sessionData,trIdx);
    [ sessionData ] = findCOM(sessionData,trIdx);
    [ sessionData ] = avgCOMVelocity(sessionData,trIdx);
    [ sessionData ] = maxVelAndHeightAXS(sessionData,trIdx);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2);
%plotTrialRigid(sessionData,3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures


dm = sessionData.dependentMeasures_tr;


%% Lead Toe Height ASO BY REPETITION

% % Group trials by condition and obs height and take the average
% sessionData = cNp_cIdx_hIdx(sessionData,'leadToeZASO');
% % Plot the mean / std calculated above
% ss = sessionData.summaryStats;
% fig_leadToeZASO_REP = plot_cIdx_hIdx_REP(sessionData,[sessionData.dependentMeasures_tr.leadToeZASO],'repetition','lead toe Z ASO');
% title('lead toe height ASO by repetition')
% ylim([0.2 .6])

%% Set plotting parameters

removeOutliers = 1
showIndividualTrials= 1;
sessionFigH = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step Duration

% duration of lead crossing step

[sessionData sessionFigH.leadStepDurASO] = cNp_cIdx_hIdx(sessionData,'leadStepDurASO',removeOutliers,showIndividualTrials);
ylabel({'lead step','duration (s)' })
ylim([.5 1 ])

% duration of trail crossing step
[sessionData sessionFigH.trailStepDurASO] = cNp_cIdx_hIdx(sessionData,'trailStepDurASO',removeOutliers,showIndividualTrials);
ylabel({'trail step','duration (s)' })
ylim([.5 1 ])

%% Clearance ASO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead clearance ASO (at step-over frame)
    
[sessionData sessionFigH.leadToeZClearanceASO] = cNp_cIdx_hIdx(sessionData,'leadToeZClearanceASO',removeOutliers,showIndividualTrials);
ylabel({'lead toe','clearance ASO (m)' })
ylim([0 0.5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail clearance ASO (at step-over frame)
    
[sessionData sessionFigH.trailToeZClearanceASO] = cNp_cIdx_hIdx(sessionData,'trailToeZClearanceASO',removeOutliers,showIndividualTrials);
ylabel({'trail toe','clearance ASO (m)' })
ylim([0 0.5])

%% Max Velocity AXS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max velocity AXS (at crossing step)

[sessionData sessionFigH.leadFootVelAXS] = cNp_cIdx_hIdx(sessionData,'leadFootMaxVelAXS',removeOutliers,showIndividualTrials);
ylabel({'lead foot','max velocity ASX (m/s)' })
ylim([0 7])

% trail max velocity AXS (at crossing step)

[sessionData sessionFigH.trailFootVelAXS] = cNp_cIdx_hIdx(sessionData,'trailFootMaxVelAXS',removeOutliers,showIndividualTrials);
ylabel({'trail foot','max velocity ASX (m/s)' })
ylim([0 7])

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Height AXS
%lead max  height AXS (at crossing step)
     
[sessionData sessionFigH.leadFootMaxZAXS] = cNp_cIdx_hIdx(sessionData,'leadFootMaxZAXS',removeOutliers,showIndividualTrials);
ylabel({'lead foot','max height ASX (m)' })
ylim([0 1])
% trail max height AXS (at crossing step)
    
[sessionData sessionFigH.trailFootMaxZAXS] = cNp_cIdx_hIdx(sessionData,'trailFootMaxZAXS',removeOutliers,showIndividualTrials);
ylabel({'trail foot','max height ASX (m)' })
ylim([0 1])


%% Visually organize figures


%%
% To automatically tile figures
tileFigs

% Or, use my function "getFigureLayout" to save existing oranization to
% % clipboard for pasting tinto code, as done below
% set(1434,'Units','Normalized','Position',[0.56 0.2 0.39 0.47]);
% set(1913,'Units','Normalized','Position',[0.51 0.34 0.39 0.47]);
% set(1639,'Units','Normalized','Position',[-69.54 0.43 0.39 0.47]);
% set(1568,'Units','Normalized','Position',[0.12 0.27 0.39 0.47]);
% set(2047,'Units','Normalized','Position',[0.058 0.36 0.39 0.47]);
% set(1773,'Units','Normalized','Position',[0.011 0.43 0.39 0.47]);
% set(1473,'Units','Normalized','Position',[0.27 0.01 0.39 0.47]);

toc
%%
saveFigStructToDir(dataFileList{sessionNumber},sessionFigH);