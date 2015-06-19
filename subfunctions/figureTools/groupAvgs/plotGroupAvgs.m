function betweenGroupsFigStruct = plotGroupAvgs(betweenSubStats,showIndividualTrials)

%% Step Duration
% duration of lead crossing step
betweenGroupsFigStruct = struct;

fieldName = 'leadStepDurASO';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading step','duration (s)' })
ylim([.5 1 ])

fieldName = 'trailStepDurASO';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing step','duration (s)' })
ylim([.5 1 ])

% %% Clearance ASO
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % lead clearance ASO (at step-over frame)
%     
fieldName = 'leadMinClearanceAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading toe','clearance AXS (m)' })
ylim([0 0.25 ])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail clearance ASO (at step-over frame)
    
fieldName = 'trailMinClearanceAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing toe','clearance AXS (m)' })
ylim([0 0.25 ])

%% Max Velocity AXS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max velocity AXS (at crossing step)

fieldName = 'leadFootMaxVelAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading foot','max velocity AXS (m/s)' })
ylim([3 6])

fieldName = 'trailFootMaxVelAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing foot','max velocity AXS (m/s)' })
ylim([3 6])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Height AXS
%lead max  height AXS (at crossing step)
     
fieldName = 'leadFootMaxZAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading foot','max height ASX (m)' })
ylim([0 1])

fieldName = 'trailFootMaxZAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing foot','max height ASX (m)' })
ylim([0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distance of the planted foot ASO

% duration of lead crossing step
fieldName = 'distPlantedFootASO';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'planted foot','location ASO (m)' })
ylim([0 1.25])