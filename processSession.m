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

sessionData = checkForExclusions(sessionData);

sessionData = synchronizeData(sessionData);

DisplaySessionData(sessionData, 2, 1, 'processedData_tr', 1) % rawData_tr -> view raw data; processedData_tr -> view processed data

%% Override exclude trials
% for trIdx = 1:sessionData.expInfo.numTrials
%     sessionData.rawData_tr(trIdx).info.excludeTrial = 0;
%     sessionData.processedData_tr(trIdx).info.excludeTrial = 0;
% end

%% filter

sessionData = calculateSamplingRate(sessionData);
sessionData = filterData(sessionData);

DisplaySessionData(sessionData, 3, 13, 'processedData_tr', 1) % rawData_tr -> view raw data; processedData_tr -> view processed data

sessionData.expInfo.obsHeightRatios = sessionData.expInfo.obsHeightRatios(~isnan(sessionData.expInfo.obsHeightRatios));
sessionData.expInfo.legLength = input('Enter leg length in meters: ');

%% Mean Trial Duration
sessionData = avgTrialDuration(sessionData);
display(['Mean trial duration:' num2str(sessionData.expInfo.meanTrialDuration)]);

%% Trial process functions

for trIdx = 1:numel(sessionData.rawData_tr)

    isBlankTrial = strcmp(sessionData.rawData_tr(trIdx).info.type{1}, 't4');
    excludeTrial = sessionData.processedData_tr(trIdx).info.excludeTrial;
    
    sessionData.processedData_tr(trIdx).info.isBlankTrial = isBlankTrial;
    
    if ~isBlankTrial && ~excludeTrial    
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
        
        [ sessionData ] = generateStepTrajectories(sessionData, trIdx);
%         
        [ sessionData ] = processEyeTrackerInfo(sessionData, trIdx, 0);
        [ sessionData ] = calcGVPosOnObj(sessionData, trIdx);
        [ sessionData ] = findObstacleFix(sessionData, trIdx, 1);        
        
    elseif isBlankTrial && ~excludeTrial     
        [ sessionData ] = findSteps(sessionData, trIdx, 0);
        [ sessionData ] = generateStepTrajectories(sessionData, trIdx);      
    end
end

%%
StepNumber = 1;

DisplayTemplates(sessionData, 'lFoot', StepNumber);
sessionData = generateUnbiasedModel(sessionData);
sessionData = generateStepFlow(sessionData);

plotModel(sessionData, StepNumber)
plotFootVariability(sessionData)

%% Read ETG Video file and play Trial number trIdx
ETG_VidObj = VideoReader([videoDir '\' ETG_videoFileList{1}]);
playTrial(ETG_VidObj, sessionData, 23)


%% Step heel down point analysis

% %% 3D plot of Walking Data
% 
% CT = 0;
% for trIdx = 1:numel(sessionData.rawData_tr)
%     t = sessionData.processedData_tr(trIdx).lFoot.rbPosSysTime_mFr_xyz;
%     CT = unique([CT; t]);  
% end
% 
% Y_lFoot_data = zeros(length(CT), numel(sessionData.rawData_tr));
% Z_lFoot_data = zeros(length(CT), numel(sessionData.rawData_tr));
% 
% for trIdx = 1:numel(sessionData.rawData_tr)
%     t = sessionData.processedData_tr(trIdx).lFoot.rbPosSysTime_mFr_xyz;
%     Y_lFoot_data(:,trIdx) = interp1(t, sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(:,2), CT);
%     Z_lFoot_data(:,trIdx) = interp1(t, sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(:,3), CT);
% end
% 
% figure; hold on
% for trIdx = 1:numel(sessionData.rawData_tr)
%     plot3(CT, Y_lFoot_data(:,trIdx), Z_lFoot_data(:,trIdx));grid on  
% end
% xlabel('Time')
% ylabel('Y Data')
% zlabel('Z Data')
% hold off
% 
% figure; hold on
% for trIdx = 1:numel(sessionData.rawData_tr)
%     plot(CT, Z_lFoot_data(:,trIdx));grid on  
% end
% xlabel('Time')
% ylabel('Z Data')
% hold off
% 
% figure; hold on
% for trIdx = 1:numel(sessionData.rawData_tr)
%     plot(Y_lFoot_data(:,trIdx), Z_lFoot_data(:,trIdx));grid on  
% end
% xlabel('Y Data')
% ylabel('Z Data')
% hold off
%%
% for i = 1:45
%     temp(i) = sessionData.processedData_tr(i).ETG.NumOfSaccades;
% end
%% For Seth

% ETG_data = cell(45,2);
% 
% % for i = 1:45
% %     cgv = sessionData.processedData_tr(i).ETG.cycGIW_fr_vec;
% %     ts = sessionData.processedData_tr(i).ETG.ETG_ts;
% %     SR = 1/mean(diff(ts));
% %     theta_X = atand(cgv(:,1)./cgv(:,2));
% %     theta_Y = atand(cgv(:,3)./cgv(:,2));
% %     ETG_data(i,1) = {[theta_X'; theta_Y']}; 
% %     ETG_data(i,2) = {SR};
% % end
% 
% for i = 1:45
%     cgv = sessionData.rawData_tr(i).ETG.L_GVEC + sessionData.rawData_tr(i).ETG.R_GVEC; 
%     cgv = normr(cgv);
%     ts = sessionData.rawData_tr(i).ETG.ETG_ts;
%     SR = 1/mean(diff(ts));
%     theta_X = atand(cgv(:,1)./cgv(:,3));
%     theta_Y = atand(cgv(:,2)./cgv(:,3));
%     ETG_data(i,1) = {[theta_X'; theta_Y']}; 
%     ETG_data(i,2) = {SR};
% end

%% Plot functions for a Trial

% plotTrialMarkers(sessionData,trIdx);
% F = plotTrialRigid(sessionData,trIdx);


%% Analysis and Generate figures


%%
% movFig = figure;
% movie(movFig,F,1)
% movie2avi(F,'Animation.avi','compression','None');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plotAvgTraj_CxH - a work in progress
% Analyzing to see if postural adjustments occurred during the approach,
% or as they left the go-box

% plotAvgTraj_CxH(sessionData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures
% 
% removeOutliers = 1;
% showIndividualTrials = 0;
% sessionFigH = struct;
% 
% [sessionData, sessionFigH ] = calculateSSandPlot(sessionData,removeOutliers,showIndividualTrials);

%%  Save figures

% saveFigStructToDir(dataFileList{sessionNumber},sessionFigH);
% 
% %% Save session file
display('Finished processing session')
save([ sessionFileDir dataFileList{sessionNumber} '.mat'] , 'sessionData');