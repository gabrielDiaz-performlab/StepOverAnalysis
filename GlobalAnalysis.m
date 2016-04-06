clear all
close all
clc

pathToSessionFiles = [ pwd '\data\sessionFiles'];

D = dir(pathToSessionFiles);
m = 0;
for i = 1:length(D)
   if ~isdir(D(i).name)
       D(i).name
       [loc] = strfind(D(i).name,'_data-');      
       if loc == 1
           m = m + 1;
           listOfSessionFiles(m) = {[pathToSessionFiles '\' D(i).name]};
       end               
   end
end

display(['Number of participants used: ' num2str(m)])

listOfMeasures = {'leadFootPlacementVariability','trailFootPlacementVariability',...
    'leadStepLengthASO','leadStepDurASO','trailStepLengthASO','trailStepDurASO',...
    'leadFootMaxVelAXS','trailFootMaxVelAXS','leadFootMaxZAXS','trailFootMaxZAXS',...
    'distPlantedFootASO','leadToeZClearanceASO','trailToeZClearanceASO',...
    'leadToeZASO','trailToeZASO','leadMinClearanceAXS','trailMinClearanceAXS'...
    'numFixOnObj','totLenFixOnObj','firstLook','firstLookStepPer','StepFlag',...
    'distFromSBFirstLook','distFromObjFirstLook','timeFromObjAppear'};

globalData = cell(length(listOfSessionFiles) + 1,length(listOfMeasures) + 1);
globalData(1,1:end-1) = listOfMeasures;
globalData(1,end) = {'objectHeight'};

for i = 1:length(listOfSessionFiles)
    load(listOfSessionFiles{i})
    
    % Loop through various Measures 
    for measIdx = 1:length(listOfMeasures)
        
        measTempVal = []; obsHeightRatio = [];
        
        % Loop through trials
        for trIdx = 1:sessionData.expInfo.numTrials
            
            % Don't accept values of Dependent measures which are from
            % Blank Trials 
            if ~sessionData.processedData_tr(trIdx).info.isBlankTrial
                 temp = sessionData.dependentMeasures_tr(trIdx).(listOfMeasures{measIdx});
                 
                 % If the value doesn't exist, add a NaN.
                 if isempty(temp)
                     temp = nan(size(measTempVal(end,:)));
                 end
                 measTempVal = [measTempVal; temp];
                 obsHeightRatio = [obsHeightRatio; ...
                     sessionData.processedData_tr(trIdx).obs.height/sessionData.expInfo.legLength];
            end
        end
        globalData(i + 1, measIdx) = {measTempVal};
        globalData(i + 1, end) = {obsHeightRatio};
    end  
end

plotGlobalMeasureVariability(globalData(:,:));

