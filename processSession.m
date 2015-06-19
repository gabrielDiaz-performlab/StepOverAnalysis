% function [sessionData sessionFigH]= processSession(sessionNumber,cleanRunBool)
% 
% if(nargin == 1 )
%    cleanRunBool = 1; 
% end

clear all
close all
sessionNumber = 1;
cleanRunBool = 1;

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

close all

tic

loadParameters

% You just need to pass the .mat file name and the experiment Data structure will be generated
dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

%% Generate or open session file struct
sessionData =  loadSession(sessionNumber);

%% If you want, you can reset the struct for a fresh analysis
% For example, if you cahnge parameters.  I suggest this is done every
% time, just in case.  

if( cleanRunBool )
    sessionData = cleanSessionData(sessionData);
end

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
