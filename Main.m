
%FIXME:  Python variable sugests quat form of WXYZ, but it is in XYZW
%FIXME:  Python obstacle_XYZ is actually Xpos, Ypos, Height

%%%%%%%%%%%%
%FIXME:  Python output needs:
%FIXME:  Rigid body posiion should be passed in from vizard (start of trial)
%FIXME:  Rigid body sizes should be passed in from vizard (start of trial)
%FIXME:  Block index and numBlocks
%FIXME:  numTrialTypes
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
sessionData.expInfo

%% Interpolate and filter

sessionData = interpolateMocapData(sessionData, 1);
sessionData = filterMocapData(sessionData, 0);

%% Some methods for plotting a trial

%plotTrialMarkers(sessionData,2)
%plotTrialRigid(sessionData,2)

%% Some per-trial functions

for trIdx = 1:numel(sessionData.rawData_tr)

    [ sessionData ] = findSteps(sessionData, trIdx, 0);
    [ sessionData ] = findFootCrossingTime(sessionData, trIdx,0);
    [ sessionData ] = toeHeightAndClearanceASO(sessionData, trIdx);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% How to average over data and plot
% Fixme:  create generalized function that calculate the mean/std
% for any input variable of the form data_tr.

% condition (real vs virtual) vs height (s, m, tall).
% Fixme: must average over trial types
numConditions = 2;
numObsheights = 3;
meanToeClearance_cIdx_hIdx = nan(numConditions ,numObsheights);

for cIdx = 1:2
    for hIdx = 1:3
        
            % One way to do things.  I abandoned this approach for the more
            % intuitive use of for loops.  I rarely do that.
            %trInBlock_tIdx = find( [sessionData.rawData_tr.blockIdx] == bIdx);
            %trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == ttIdx);
            
            trOfType_tIdx = find( [sessionData.rawData_tr.trialType] == hIdx * cIdx );
            
            if( sum( isnan([sessionData.dependentMeasures_tr(trOfType_tIdx).leadToeZASO]) ) > 0 )
               print( 'Found a NAN value!' )
               keyboard
            end
            
            meanToeClearance_cIdx_hIdx(cIdx,hIdx) = mean([sessionData.dependentMeasures_tr(trOfType_tIdx).leadToeZASO]);
            stdToeClearance_cIdx_hIdx(cIdx,hIdx) = std([sessionData.dependentMeasures_tr(trOfType_tIdx).leadToeZASO]);

    end
end

%%

sessionData.summaryStats = struct;
sessionData.summaryStats.meanToeClearance_cIdx_hIdx = meanToeClearance_cIdx_hIdx;
sessionData.summaryStats.stdToeClearance_cIdx_hIdx = stdToeClearance_cIdx_hIdx;
close all

%%  Plot data
% Fixme:  create generalized function that plot the mean/std
% for any input variable of the form data_tr.

figure(1)
clf
hold on

xlabel('Obs Height / Leg Length')
ylabel('Toe Clearance at Stepover (m)')

obsHeightRatios = sessionData.expInfo.obsHeightRatios;

l1 = errorbar( obsHeightRatios, meanToeClearance_cIdx_hIdx(1,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2);
l2 = errorbar( obsHeightRatios, meanToeClearance_cIdx_hIdx(2,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2);

%l1 = errorbar( sessionData.summaryStats.meanToeClearance_cIdx_hIdx(1,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(1,:)','LineWidth',2)
%l2 = errorbar( sessionData.summaryStats.meanToeClearance_cIdx_hIdx(2,:)',sessionData.summaryStats.stdToeClearance_cIdx_hIdx(2,:)','LineWidth',2)

l2X = l2.XData;
l2.XData = l2X-.005

l1X = l1.XData;
l1.XData = l1X+.005

set(gca,'xtick',obsHeightRatios)
xlim([obsHeightRatios(1)-.02 obsHeightRatios(end)+.02])
ylim([0 1])

%%
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
