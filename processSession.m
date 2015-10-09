% function [sessionData sessionFigH]= processSession(sessionNumber,cleanRunBool)
% 
% if(nargin == 1 )
%    cleanRunBool = 1; 
% end

% _tr = trial
% _fr = frame (vizard frame)
% _mFr frame (phasespace/mocap frame)
% _xyz = xyz position data
% _wxyz = quaternion data wxyz
% rb = phasespace rigid body data
% mkr = phasespace marker data

%%%  Subjects are always walking from 0,0,0, (center of the start box) towarsda and over an obstacle placed up the Y axis

%%%%% Examples of phasespace data (highfrequ sampling)
% rbPos_mFr_xyz: [2881x3 double]
% rbPosSysTime_mFr_xyz: [2881x1 double]
% rbQuat_mFr_xyz: [2881x4 double]
% rbQuatSysTime_mFr: [2881x1 double]  
% mkrPos_mIdx_Cfr_xyz: {5x1 cell}
% mkrSysTime_mIdx_Cfr: {5x1 cell}
%%%%% 

%%%%% Examples of vizard data (low frequ sampling)
%rFoot.pos_fr_xyz: [1147x3 double]
%rFoot.quat_fr_wxyz: [1147x4 double]
%rFoot.rot_fr_d1_d2: [1147x4x4 double]
% TIMESTAMPS are stored in sessionData.rawData_tr(trialNum).info.sysTime_fr
%%%%% 

%%
clc
clear all
close all

sessionNumber = 1;
cleanRunBool = 0;

close all

tic

loadParameters

addpath(genpath('helperFiles'))

% You just need to pass the .mat file name and the experiment Data structure will be generated
dataFileString = sprintf('%s.mat',dataFileList{sessionNumber});

%% Generate or open session file struct

if( cleanRunBool )
    
    removeParsedData(sessionNumber);
    removeSessionData(sessionNumber);
    
    % An alternative: 
    % This just sets the session file back to its raw state,
    % after importorting text data and creating session struct.
    % Avoids having to import / parse text again.
    %sessionData = cleanSessionData(sessionData);
end

sessionData =  loadSession(sessionNumber);

%%
% DisplaySessionData(sessionData, 2, 1, 'rawData_tr', 1) % rawData_tr -> view raw data; processedData_tr -> view processed data

sessionData = checkForExclusions(sessionData);

sessionData = synchronizeData(sessionData);

%% filter

sessionData = calculateSamplingRate(sessionData);
sessionData = filterData(sessionData);

DisplaySessionData(sessionData, 3, 1, 'processedData_tr', 1) % rawData_tr -> view raw data; processedData_tr -> view processed data

%%
sessionData = avgTrialDuration(sessionData);
display(['Mean trial duration:' num2str(sessionData.expInfo.meanTrialDuration)]);

% Some per-trial functions

for trIdx = 1:numel(sessionData.rawData_tr)
    
%     [ sessionData ] = calcMeanRigidBodyPos(sessionData, trIdx);
    [ sessionData ] = findSteps(sessionData, trIdx, 0);
    [ sessionData ] = findFootCrossing(sessionData, trIdx);
    [ sessionData ] = stepLengthAndDur(sessionData, trIdx);
    [ sessionData ] = stepLengthAndDurASO(sessionData, trIdx);
    [ sessionData ] = findCOM(sessionData, trIdx);
    [ sessionData ] = avgCOMVelocity(sessionData, trIdx);
    [ sessionData ] = maxVelAndHeightAXS(sessionData, trIdx);
    [ sessionData ] = findDistPlantedFootASO(sessionData, trIdx);
    [ sessionData ] = calcObjCenteredTraj(sessionData, trIdx);
    [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
    [ sessionData ] = findMinDistanceAXS(sessionData, trIdx);  
    [ sessionData ] = processEyeTrackerInfo(sessionData, trIdx);
    [ sessionData ] = calcGVPosOnObj(sessionData, trIdx);
    [ sessionData ] = findObstacleFix(sessionData, trIdx, 0);
end

%% Plot functions for a Trial

plotTrialMarkers(sessionData,trIdx);
F = plotTrialRigid(sessionData,trIdx);

%%
movFig = figure;
movie(movFig,F,1)
movie2avi(F,'Animation.avi','compression','None');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plotAvgTraj_CxH - a work in progress
% Analyzing to see if postural adjustments occurred during the approach,
% or as they left the go-box

% plotAvgTraj_CxH(sessionData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures

% removeOutliers = 1
% showIndividualTrials= 1;
% sessionFigH = struct;
% 
% [sessionData, sessionFigH ] = calculateSSandPlot(sessionData,removeOutliers,showIndividualTrials);
% 
% %%  Save figures
% 
% saveFigStructToDir(dataFileList{sessionNumber},sessionFigH);
% 
% %% Save session file
% 
% save([ sessionFileDir dataFileList{sessionNumber} '.mat'] , 'sessionData');
