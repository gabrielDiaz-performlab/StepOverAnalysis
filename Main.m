
%FIXME:  Python variable sugests quat form of WXYZ, but it is in XYZW
%FIXME:  Python obstacle_XYZ is actually Xpos, Ypos, Height

%%%%%%%%%%%%
%FIXME:  Python output needs:
%FIXME:  Rigid body posiion should be passed in from vizard (start of trial)
%FIXME:  Rigid body sizes should be passed in from vizard (start of trial)
%%%%%%%%%%%

clc
clear all
close all

loadParameters
% You just need to pass the .mat file name and the experiment Data structure will be generated
sessionNumber = 1;

sessionData = struct;
sessionData.fileID = dataFileList{sessionNumber};

parseTextFileToMat(sessionNumber)

dataFileString = sprintf('%s.mat',dataFileList{sessionNumber})

sessionData.rawData_tr = generateRawData(dataFileString);

%%


sessionData = interpolateMocapData(sessionData, 0);
sessionData = filterMocapData(sessionData, 0);

%%
[sessionData figH ]= findSteps(sessionData, 10, 1)
sessionData.dependentMeasures_tr(5)

%%
for trIdx = 1:numel(sessionData.rawData_tr)

    [sessionData figH ]= findSteps(sessionData, trIdx, 1)
    
end

%%
%plotTrialMarkers(sessionData,1)
%plotTrialRigid(sessionData,trIdx )  Not quite right, yet.  

% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% How to access data for one trial
% 
% fprintf('*** Number of trials: %i \n', length(sessionData.rawData_tr)) 
% 
% % To view rawData fields:
% sessionData.rawData_tr
% 
% % To access specific data for trial 2:
% fprintf('** Trial 2 Type: %i \n', sessionData.rawData_tr(2).trialType)
% % Fix ME:
% %fprintf('** Trial 2 Block: %i \n', sessionData.rawData_tr(2).block)
% fprintf('** Trial 2 StartFr: %i \n', sessionData.rawData_tr(2).startFr)
% fprintf('** Trial 2 EndFr: %i \n \n', sessionData.rawData_tr(2).stopFr)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Here's where one might call a function.
% % Our functions will accept trial data as input
% 
% % For example, here is a function to find Toe Clearance at step over
% % ExpData structure is passed to the function,
% % % the height of the first toe to break the plane of the obstacle is returned
% % 
% % ProcessedData = struct;
% % N = length(sessionData.rawData_tr);
% % processedData_tr = repmat(ProcessedData, N, 1 );
% % sessionData.processedData_tr = processedData_tr;
% % 
% % [ sessionData ] = findFootCrossingTime(sessionData, trialNumber,1);
% 
% % % %
% % [ sessionData ] = findDistPlantedFootASO(sessionData, trialNumber);
% % [ sessionData ] = toeClearanceASO(sessionData, trialNumber);
% % 
% % % Fix Me: There is an error in storing the COM into the Processed Data
% % % Structure
% % [ sessionData ] = findCOM(sessionData, trialNumber);
% % 
% % [ sessionData ] = avgCOMVelocity(sessionData, trialNumber);
% % 
% % [ sessionData ] = stepSize(sessionData, trialNumber);
% % 
% % 
% % %rightFootDistanceASO = FindStepOverDistance( SessionData, trialNumber, rightFootCrossingFr, rightFootMkrIdx )
% % %leftFootDistanceASO = FindStepOverDistance( SessionData, trialNumber,  leftFootCrossingFr, leftFootMkrIdx)
% % 
% % %% Lets plot that marker!
% % 
% % % Question : Is this just for test? or ?
% % rightFootMkrIdx = 1;
% % leftFootMkrIdx = 1;
% % % To access time series data for trial 2:
% % if( strcmp(sessionData.processedData_tr(trialNumber).firstCrossingFoot,'Right'))
% %     footData_fr_mkr_XYZ = sessionData.rawData_tr(trialNumber).rightFoot_fr_mkr_XYZ;
% %     footMkrIdx = rightFootMkrIdx;
% % elseif( strcmp(firstFootStr,'Left'))
% %     footData_fr_mkr_XYZ = sessionData.rawData_tr(trialNumber).leftFoot_fr_mkr_XYZ;
% %     footMkrIdx = leftFootMkrIdx;
% % end
% % 
% % Obstacle_XYZ = sessionData.rawData_tr(trialNumber).obstacle_XYZ;
% % 
% % footData_fr_XYZ = squeeze(footData_fr_mkr_XYZ(:,footMkrIdx,:));
% % X = footData_fr_XYZ(:,1);
% % Y = footData_fr_XYZ(:,2);
% % Z = footData_fr_XYZ(:,3);
% % createfigure(X,Z,Y,'Foot Marker Position', Obstacle_XYZ);
% % 
% % %% COM Position and Velocity Plots
% % 
% % %Position
% % COMData = sessionData.COM;
% % COM_X = COMData(:,1);
% % COM_Y = COMData(:,2);
% % COM_Z = COMData(:,3);
% % 
% % Obstacle_XYZ = sessionData.rawData_tr(trialNumber).obstacle_XYZ;
% % 
% % createfigure(COM_X, COM_Z, COM_Y, 'COM Position', Obstacle_XYZ);
% % 
% % %Velocity
% % velData = sessionData.processedData_tr(trialNumber).avgCOMVelocity;
% % figure;
% % plot(COM_X,velData,'x','MarkerSize',8,'LineWidth',2)
% % xlabel('Position (m)','FontSize',12);
% % ylabel('Velocity (m/s)','FontSize',12);
% % title('COM Velocity','FontSize',12,'FontWeight','bold');
% % hold on;
% % obsLineX = [Obstacle_XYZ(1), Obstacle_XYZ(1)];
% % obsLineY = [0, max(velData)];
% % plot(obsLineX, obsLineY, '-r','LineWidth',2);
% % hold off;
% % grid('on');
% % 
% % %Plot both?
% % figure;
% % subplot(2,1,1);
% % plot3(COM_X,COM_Z, COM_Y,'Marker','*','LineStyle','none');
% % if (Obstacle_XYZ ~= [0 0 0])
% %     X = zeros(1,100);
% %     Z = X;
% %     Y = linspace(-1,1,100);
% %     hold on
% %     plot3(X+Obstacle_XYZ(1), Y + Obstacle_XYZ(3), Z+Obstacle_XYZ(2),'Marker','o','LineStyle','none', 'color', 'red')
% %     hold off
% % end
% % title('COM Position','FontWeight','bold','FontSize',14);
% % xlabel('X (m)','FontSize',12);
% % ylabel('Y (m)','FontSize',12);
% % zlabel('Z (m)','FontSize',12);
% % grid('on');
% % 
% % subplot(2,1,2)
% % plot(COM_X,velData,'x','MarkerSize',8,'LineWidth',2)
% % xlabel('Position (m)','FontSize',12);
% % ylabel('Velocity (m/s)','FontSize',12);
% % title('COM Velocity','FontSize',12,'FontWeight','bold');
% % hold on;
% % obsLineX = [Obstacle_XYZ(1), Obstacle_XYZ(1)];
% % obsLineY = [0, max(velData)];
% % plot(obsLineX, obsLineY, '-r','LineWidth',2);
% % hold off;
% % grid('on');
% % 
% % %% Plot Step Size
% % figure;
% % 
% % subplot(1,2,1)
% % plot(sessionData.rawData_tr(trialNumber).frameTime_fr, sessionData.processedData_tr(trialNumber).stepLength,'x','MarkerSize',8,'LineWidth',2)
% % xlabel('Time (s)','FontSize',12);
% % ylabel('Step Length (m)','FontSize',12);
% % title('Step Length','FontSize',12,'FontWeight','bold');
% % hold on;
% % obsLineX = [Obstacle_XYZ(1), Obstacle_XYZ(1)];
% % obsLineY = [0, max(velData)];
% % plot(obsLineX, obsLineY, '-r','LineWidth',2);
% % hold off;
% % grid('on');
% % 
% % 
% % subplot(1,2,2)
% % plot(sessionData.rawData_tr(trialNumber).frameTime_fr, sessionData.processedData_tr(trialNumber).stepLength,'x','MarkerSize',8,'LineWidth',2)
% % xlabel('Time (s)','FontSize',12);
% % ylabel('Step Width (m)','FontSize',12);
% % title('Step Width','FontSize',12,'FontWeight','bold');
% % hold on;
% % obsLineX = [Obstacle_XYZ(1), Obstacle_XYZ(1)];
% % obsLineY = [0, max(velData)];
% % plot(obsLineX, obsLineY, '-r','LineWidth',2);
% % hold off;
% % grid('on');
