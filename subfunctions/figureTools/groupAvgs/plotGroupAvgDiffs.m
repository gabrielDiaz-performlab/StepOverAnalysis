function betweenGroupsFigStruct = plotGroupAvgDiffs(betweenSubStats,showIndividualTrials)

%% Step Duration
% duration of lead crossing step
betweenGroupsFigStruct = struct;

fieldName = 'leadStepDurASO';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading step','duration (s)' })
ylim([-0.5 0.5])

fieldName = 'trailStepDurASO';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing step','duration (s)' })
ylim([-0.5 0.5])

% %% Clearance ASO
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % lead clearance ASO (at step-over frame)
%     
% fieldName = 'leadToeZClearanceASO';
% figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
% eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
% ylabel({'leading toe','clearance ASO (m)' })
% ylim([-0.5 0.5])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % trail clearance ASO (at step-over frame)
%     
% fieldName = 'trailToeZClearanceASO';
% figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
% eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
% ylabel({'trailing toe','clearance ASO (m)' })
% ylim([-0.5 0.5])

%% Max Velocity AXS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max velocity AXS (at crossing step)

fieldName = 'leadFootMaxVelAXS';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading foot','max velocity AXS (m/s)' })
ylim([-1 1])

fieldName = 'trailFootMaxVelAXS';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing foot','max velocity AXS (m/s)' })
ylim([-1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Height AXS
%lead max  height AXS (at crossing step)
     
fieldName = 'leadFootMaxZAXS';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading foot','max height ASX (m)' })
ylim([-0.5 0.5])

fieldName = 'trailFootMaxZAXS';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing foot','max height ASX (m)' })
ylim([-0.5 0.5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distance of the planted foot ASO

% duration of lead crossing step
fieldName = 'distPlantedFootASO';
figH = plotGroupAvgDiffs_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'planted foot','location ASO (m)' })
ylim([-0.5 0.5])