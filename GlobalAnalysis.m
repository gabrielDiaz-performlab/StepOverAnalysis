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
    'numFixOnObj','stepsToObs','fixOnStep','totLenFixOnObj','firstLook','firstLookStepPer','StepFlag',...
    'distFromSBFirstLook','distFromObjFirstLook','timeFromObjAppear','objStepDist'};

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
                 if isempty(temp) && ~isempty(measTempVal)
                     temp = nan(size(measTempVal(end,:)));
                 elseif isempty(temp) && isempty(measTempVal)
                     temp = nan;
                 end
                 if size(measTempVal, 2) == size(temp, 2)
                    measTempVal = [measTempVal; temp];
                 else
                    measTempVal = repmat(measTempVal, [1 size(temp, 2)]);
                    measTempVal = [measTempVal; temp];
                 end
                 obsHeightRatio = [obsHeightRatio; ...
                     sessionData.processedData_tr(trIdx).obs.height/sessionData.expInfo.legLength];
            end
        end
        globalData(i + 1, measIdx) = {measTempVal};
        globalData(i + 1, end) = {obsHeightRatio};
    end  
end

% plotGlobalMeasure(globalData(:,:));

%% Generate Mean Info
globalMeanData = cell(size(globalData, 1), size(globalData, 2));
globalMeanData(1,:) = globalData(1,:);

for i = 2:size(globalData, 1)
    obsHeightRatio = globalData{i,end};
    listObsHeightRatio = unique(obsHeightRatio);
    
    if length(listObsHeightRatio) ~= 3
       disp('Error. There supposed to be 3 Obs height ratios') 
    end
   
    for j = 1:size(globalData, 2) - 1
        measTempVal = globalData{i,j};
              
        for ratioId = 1:length(listObsHeightRatio)
            loc = obsHeightRatio == listObsHeightRatio(ratioId);
            globalMeanData(i, j) = {[ globalMeanData{i, j}; nanmean(measTempVal(loc,:), 1)]};
            
            % Just once, find the mean of the obstacle height ratios
            if j == 1
                globalMeanData(i, end) = {[ globalMeanData{i, end}; nanmean(obsHeightRatio(loc), 1)]};
            end
        end

    end
end

plotGlobalMeasure(globalMeanData(:,:));

%% Plot Number of fixations against obstacle step distance

xData = cell2mat(globalData(2:end, end - 1));
yData = cell2mat(globalData(2:end, 18));

xVals = unique(xData); xVals = xVals(~isnan(xVals)); % Obs step distance
yVals = unique(yData); yVals = yVals(~isnan(yVals)); % Number of fixations

ValMat = zeros(length(xVals), length(yVals));
for i = 1:length(xVals)
    for j = 1:length(yVals)
        ValMat(i,j) = sum( xData == xVals(i) & yData == yVals(j));
    end
end

ValMat = ValMat./ repmat(sum(ValMat,2),[1 length(yVals)]);
ValMat = ValMat*15000;

[Y, X] = meshgrid(yVals, xVals);
figure; hold on
scatter(X(:),Y(:), ValMat(:) + 100, 'LineWidth' ,3, 'MarkerFaceColor', [1 1 0])
xlabel('Object distance in Step Lengths')
ylabel('Number of Fixations')
title('Percent probability of Occurrence')
grid on;
axis([2 6 -1 4])
for i = 1:length(xVals)
    for j = 1:length(yVals)
        text(xVals(i) - 0.4, yVals(j), [mat2str(round(ValMat(i,j)*10/1500)) ' %'],'FontSize',23)
    end
end

%% Plot fixation probability wrt obstacle
xData = single(cell2mat(globalData(2:end, 19)));
yData = single(cell2mat(globalData(2:end, 20)));

xVals = unique(xData); xVals = xVals(~isnan(xVals)); % Obs step distance
yVals = unique(yData); yVals = yVals(~isnan(yVals)); % Number of fixations

ValMat = zeros(length(xVals), length(yVals));
for i = 1:length(xVals)
    for j = 1:length(yVals)
        ValMat(i,j) = sum( xData == xVals(i) & yData == yVals(j));
    end
end

ValMat = ValMat./ repmat(sum(ValMat,2),[1 length(yVals)]);
ValMat = ValMat*5000;

[Y, X] = meshgrid(yVals, xVals);
figure; hold on
scatter(X(:),Y(:), ValMat(:) + 100, 'LineWidth' ,3, 'MarkerFaceColor', [1 1 0])
xlabel('Object distance in Step Lengths post obstacle appearance')
ylabel('Step number prior crossing step')
title('Percent probability of Occurrence')
grid on;
axis([-1 5 0 5])
for i = 1:length(xVals)
    for j = 1:length(yVals)
        text(double(xVals(i) - 0.4), double(yVals(j)), [mat2str(round(ValMat(i,j)*10/500)) '%'],'FontSize',20)
    end
end

%% Plot mean info

% xData = cell2mat(globalMeanData(:, end, :));
% 
% for measId = 1:size(globalData, 2) - 1
%     yData = cell2mat(globalMeanData(:, measId, :));
%     
%     colorMat = linspecer(size(yData, 2));
%     for j = 1:size(yData, 2)      
%         tempx = xData(:);
%         tempy = yData(:, j, :); tempy = tempy(:);
%         
%         figure
%         scatter(tempx, tempy, 80, colorMat(j,:))
%         title([globalData(1,measId) 'vs Obstacle Height Ratio'])       
%     end
% end
