function [sessionData sessionFigH]= calculateSSandPlot(sessionData,removeOutliers,showIndividualTrials )

if( removeOutliers == 1)
    fprintf('*** calculateSSandPlot: Removing outliers from data! *** \n') 
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


sessionFigH = struct;


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distance of the planted foot ASO

% duration of lead crossing step

[sessionData sessionFigH.distPlantedFootASO] = cNp_cIdx_hIdx(sessionData,'distPlantedFootASO',removeOutliers,showIndividualTrials);
ylabel({'planted foot','location ASO (m)' })

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
