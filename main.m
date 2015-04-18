
%FIXME:  Python variable sugests quat form of WXYZ, but it is in XYZW
%FIXME:  Python obstacle_XYZ is actually Xpos, Ypos, Height

%%%%%%%%%%%%
%FIXME:  Python output needs:
%FIXME:  Rigid body position should be passed in from vizard (on each frame)
%FIXME:  Rigid body sizes should be passed in from vizard (start of trial)
%FIXME:  Marker conditions
%FIXME:  Leg length ratios

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
sessionNumber = 1;

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
    [ sessionData ] = findDistPlantedFootASO(sessionData,trIdx);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2);
%plotTrialRigid(sessionData,3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures
removeOutliers = 1
showIndividualTrials= 1;
sessionFigH = struct;

[sessionData sessionFigH ] = calculateSSandPlot(sessionData,removeOutliers,showIndividualTrials)

%%
saveFigStructToDir(dataFileList{sessionNumber},sessionFigH);