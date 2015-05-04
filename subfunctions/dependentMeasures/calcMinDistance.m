function [minDistance minDistFrameIndex] = calcMinDistance(sessionData,markerData)

loadParameters

% search range
% start frame startFrameIndex
% end frame endFrameIndex

obstacleXLocation = sessionData.rawData_tr(trialNumber).obstacle_XposYposHeight(1);
obstacleYLocation = sessionData.rawData_tr(trialNumber).obstacle_XposYposHeight(2);
obstacleZLocation = sessionData.rawData_tr(trialNumber).obstacle_XposYposHeight(3);
    
% Selecting two points one meter away on the obstacle line (Triangle Base)
pointC = [0.5, obstacleYLocation, obstacleZLocation];
pointB = [-0.5, obstacleYLocation, obstacleZLocation];

tempVar = 100 * ones(1,(endFrameIndex - startFrameIndex  + 1));

sessionData.processedData_tr(trIdx)
for frameNumber = 1:endFrameIndex - startFrameIndex + 1
    
    %markerPoint = rFData(frameNumber,:);
    
    markerLocation_XYZ = rFData(frameNumber,:)
    
    bc = sqrt(sum((pointC-pointB).^2));
    ac = sqrt(sum((markerPoint-pointC).^2));
    ab = sqrt(sum((markerPoint-pointB).^2));
    S = (ab + ac + bc)/2;                    % Semiperimeter
    Area = sqrt(S*(S-ab)*(S-ac)*(S-bc));      % Area of the Triangle
    
    minDistance(frameNumber) = (2 * Area)/bc;
    
end

minDistance_mIdx(markerIndex) = min(tempVar_R);
