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

clear all
close all

sessionNumber = 1;
cleanRunBool = 1;

close all

tic

loadParameters

% You just need to pass the .mat file name and the experiment Data structure will be generated
dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

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

%% Rakshit:  

% I think that, here, you should add a function to interpolate data to a
% common timestamp
% sessionData = sycnhronizeData(sessionData);

sessionData = checkForExclusions(sessionData);


%% Interpolate and filter

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
    [ sessionData ] = stepLengthAndDurASO(sessionData,trIdx);
    [ sessionData ] = findCOM(sessionData,trIdx);
    [ sessionData ] = avgCOMVelocity(sessionData,trIdx);
    [ sessionData ] = maxVelAndHeightAXS(sessionData,trIdx);
    [ sessionData ] = findDistPlantedFootASO(sessionData,trIdx);
    
    [ sessionData ] = calcObjCenteredTraj(sessionData,trIdx);
    
    %[ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
    [ sessionData ] = findMinDistanceAXS(sessionData,trIdx);
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Plot body scaled
% 
% figure(1010)
% hold on
% cla
% set(1010,'Units','Normalized','Position',[0.118055555555556 0.235555555555556 0.829166666666667 0.65]);
% title({'lead foot position','in units of leg length','for 1 obstacle height'})
% 
% for hIdx = 1:3
%     
%     trIdxList = find([sessionData.rawData_tr.trialType] == hIdx);
%     trIdxList = [trIdxList  find([sessionData.rawData_tr.trialType] == hIdx+3)];
%         
%     for trIdx = 1:numel(trIdxList)
%         
%         trNum = trIdxList(trIdx);
%         
%         if( strcmp( sessionData.dependentMeasures_tr(trNum).firstCrossingFoot, 'Left' ) )
%             
%             leadFoot_fr_XYZ = sessionData.processedData_tr(trIdxList(trIdx)).lFootBS_fr_XYZ;
%         else
%             leadFoot_fr_XYZ = sessionData.processedData_tr(trIdxList(trIdx)).rFootBS_fr_XYZ;
%         end
%         
%         X = repmat(trIdx,1,length(leadFoot_fr_XYZ ));
%         Y = leadFoot_fr_XYZ(:,2);
%         Z = leadFoot_fr_XYZ(:,3);
%         plot3(X,Y,Z)
%         
%     end
% end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2);
%plotTrialRigid(sessionData,3)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plotAvgTraj_CxH - a work in progress
% Analyzing to see if postural adjustments occurred during the approach,
% or as they left the go-box

%plotAvgTraj_CxH(sessionData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make some figures

removeOutliers = 1
showIndividualTrials= 1;
sessionFigH = struct;

[sessionData sessionFigH ] = calculateSSandPlot(sessionData,removeOutliers,showIndividualTrials)

%%  Save figures

saveFigStructToDir(dataFileList{sessionNumber},sessionFigH);

%% Save session file

save([ sessionFileDir dataFileList{sessionNumber} '.mat'] , 'sessionData');
