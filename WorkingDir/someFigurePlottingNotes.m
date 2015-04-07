%%
% %% Average step duration
% 
% % Group trials by condition and obs height and take the average
% % Note that sessionData.dependentMeasures_tr.bothFeet, or dm.bothFeet
% % returns a bunch of structs.  You can turn them into an array using [] 
% dmBoth_tr = [dm.bothFeet];
% 
% sessionData = mean_cIdx_hIdx(sessionData,[dmBoth_tr.stepDur_sIdx],'stepDuration');
% 
% % Plot the mean / std calculated above
% ss = sessionData.summaryStats;
% meanLeadToeZASO = ss.meanLeadToeZASO_cIdx_hIdx;
% fig_stepDur = plot_cIdx_hIdx(xData,meanLeadToeZASO ,ss.meanLeadToeZClearanceASO_cIdx_hIdx,'obstacle height (m)','step duration (s)');
% title('Step duration')


% %% Step duration ASO  
% % this one is a bit tricky because the variable of interest (dep. measure)
% % is a struct buried withn a list of structs.  Yikes.
% % Let me try and break this down for yah...
% % We want to get at sessionData.dependentMeasures_tr.bothFeet.stepDur_sIdx
% % sessionData = struct
% % .dependentMeasures_tr = array of structs N trials long
% % ...and within each of these structs is another struct, bothFeet
% % bothFeet contains an array stepDur_sIdx.  
% % Yikes.  So that's...
% % struct.array(1:numTrials).struct.array(1:numSteps)

% %%%%% Here's how to get at the data buried in stepDur_sIdx
% dmBoth_tr  = [dm.bothFeet]; % Avoids a pesky matlab error.
% 
% stepDur_tr_cSIdx = {dmBoth_tr .stepDur_sIdx}; % This creates a vector of cells.  Type in the var to see.
% crossingStepIdx_tr = [dmBoth_tr .crossingStepIdx]; 
% 
% % Initialize the data structure.
% crossingStepDur_tr = nan(1,numel(stepDur_tr_cSIdx));
% 
% for trIdx = 1:numel(stepDur_tr_cSIdx)
%     if( ~isnan(crossingStepIdx_tr(trIdx)))
%         crossingStepDur_tr(trIdx) = stepDur_tr_cSIdx{trIdx}(crossingStepIdx_tr(trIdx));
%     else
%         crossingStepDur_tr(trIdx) = NaN;
%     end
% end
% 
% % Group trials by condition and obs height and take the average
% sessionData = mean_cIdx_hIdx(sessionData,crossingStepDur_tr,'bothFeetStepDur');
% 
% ss = sessionData.summaryStats;
% meanBothFeetStepDur = ss.meanBothFeetStepDur_cIdx_hIdx;
% 
% % Plot the mean / std calculated above
% leadToeZASO = plot_cIdx_hIdx(xData,meanBothFeetStepDur,ss.stdBothFeetStepDur_cIdx_hIdx,'obstacle height (m)','step duration ASO (s)');
% ylim([0 .6]);
% %leadToeZASO2 = plot_cIdx_hIdx(sessionData,'leadToeZClearanceASO',sessionData.expInfo.obsHeightRatios,'obstacle height','toeZ clearance ASO');
% title('Step Duration ASO')
% 
% %%
% textFileName = dataFileList{sessionNumber};
% sessionFilePath = [ sessionFileDir textFileName '.mat'];
% save(sessionFilePath,'sessionData')