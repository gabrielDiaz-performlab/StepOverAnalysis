
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
sessionNumber = 2;

dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

textFileName = dataFileList{sessionNumber};


%% Generate or open session file struct

sessionData = generateSessionStruct(sessionNumber);

%% Reset the struct for a fresh analysis

sessionData = cleanSessionData(sessionData);

%% Interpolate and filter

% It seems that data is already interpolated.
% Evidence?  THe NaNs are in the start of the first trial.
% I should probably try and turn this off and see what happens,
% Or import marker condition

sessionData = calculateSamplingRate(sessionData);
sessionData = interpAndFilterData(sessionData, 0);

%%

sessionData = avgTrialDuration(sessionData);
sessionData.expInfo.meanTrialDuration;

% (40 * 60 ) / 10

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
    [ sessionData ] = maxVelAndHeightAXS(sessionData,trIdx) ;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2);
%plotTrialRigid(sessionData,3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures

figH = struct;
dm = sessionData.dependentMeasures_tr;


% %% Lead Toe Height ASO BY REPETITION
% 
% % Group trials by condition and obs height and take the average
% %sessionData = cNp_cIdx_hIdx(sessionData,[dm.leadToeZASO],'leadToeZASO');
% % Plot the mean / std calculated above
% ss = sessionData.summaryStats;
% fig_leadToeZASO_REP = plot_cIdx_hIdx_REP(sessionData,[sessionData.dependentMeasures_tr.leadToeZASO],'repetition','lead toe Z ASO');
% title('lead toe height ASO by repetition')
% ylim([0.2 .6])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% duration of crossing step

[sessionData figH.stepDurASO] = cNp_cIdx_hIdx(sessionData,'stepDurASO_sIdx')  
ylabel({'crossing step','duration (s)' })

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max velocity AXS (at crossing step)

[sessionData figH.leadFootVelAXS] = cNp_cIdx_hIdx(sessionData,'leadFootMaxVelAXS')  
ylabel({'lead foot','max velocity ASX (m/s)' })
ylim([0 7])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max  height AXS (at crossing step)
    
[sessionData figH.leadFootMaxZAXS] = cNp_cIdx_hIdx(sessionData,'leadFootMaxZAXS')  
ylabel({'lead foot','max height ASX (m)' })
ylim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead clearance ASO (at step-over frame)
    
[sessionData figH.leadToeZClearanceASO] = cNp_cIdx_hIdx(sessionData,'leadToeZClearanceASO')  
ylabel({'lead toe','max clearance ASO (m)' })
ylim([0 0.5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail max velocity AXS (at crossing step)

[sessionData figH.trailFootVelAXS] = cNp_cIdx_hIdx(sessionData,'trailFootMaxVelAXS')  
ylabel({'trail foot','max velocity ASX (m/s)' })
ylim([0 7])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail max height AXS (at crossing step)
    
[sessionData figH.trailFootMaxZAXS] = cNp_cIdx_hIdx(sessionData,'trailFootMaxZAXS')  
ylabel({'trail foot','max height ASX (m)' })
ylim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail clearance ASO (at step-over frame)
    
[sessionData figH.trailToeZClearanceASO] = cNp_cIdx_hIdx(sessionData,'trailToeZClearanceASO')  
ylabel({'trail toe','max clearance ASO (m)' })
ylim([0 0.5])


tileFigs



