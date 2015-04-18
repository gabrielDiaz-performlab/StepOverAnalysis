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

%% Clearance ASO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead clearance ASO (at step-over frame)
    
fieldName = 'leadToeZClearanceASO';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading toe','clearance ASO (m)' })
ylim([0 1 ])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trail clearance ASO (at step-over frame)
    
fieldName = 'trailToeZClearanceASO';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing toe','clearance ASO (m)' })
ylim([0 1 ])

%% Max Velocity AXS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lead max velocity AXS (at crossing step)

fieldName = 'leadFootMaxVelAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'leading foot','max velocity AXS (m/s)' })
ylim([0 7])

fieldName = 'trailFootMaxVelAXS';
figH = plotGroupAvg_cIdx_hIdx(betweenSubStats,fieldName,showIndividualTrials);
eval(['betweenGroupsFigStruct.' fieldName '=figH;']);
ylabel({'trailing foot','max velocity AXS (m/s)' })
ylim([0 7])

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