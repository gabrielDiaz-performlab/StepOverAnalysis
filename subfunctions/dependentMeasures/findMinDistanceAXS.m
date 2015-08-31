function [sessionData] = findMinDistanceAXS(sessionData, trIdx)

% Kamran Binaee 4/30/2015
%
% This function gets two Frame indexes as input (startFrameIndex, endFrameIndex)
% and finds the minimum distance to the obstacle among all the markers
%
% It draws a line on the obstacle between Points B and C
% Then from each marker point (A) the distance is calculated using the
% Area of the triangle shaped by A, B and C.
% (Area = ( Dsitance * BC )/ 2 ==>  Distance = ( 2 * Area )/ BC

% Modified by GDiaz 5/1/15

loadParameters


%% If this trial is being excluded, skip the analysis

dmTrialStruct = sessionData.dependentMeasures_tr(trIdx);

%%  Some checks

if(sum(strcmp(fieldnames(dmTrialStruct),'lFoot'))==0 || sum(strcmp(fieldnames(dmTrialStruct),'rFoot'))==0)
    error('Must run findSteps.m prior to stepLengthAndDurASO.m \n')
    return
end


if(sessionData.rawData_tr(trIdx).info.excludeTrial == 1)
    
    sessionData.dependentMeasures_tr(trIdx).leadMinClearanceAXS = NaN;
    sessionData.dependentMeasures_tr(trIdx).leadMinClearanceMidx = NaN;
    sessionData.dependentMeasures_tr(trIdx).leadMinClearanceFrame = NaN;
    
    sessionData.dependentMeasures_tr(trIdx).trailMinClearanceAXS = NaN;
    sessionData.dependentMeasures_tr(trIdx).trailMinClearanceMidx = NaN;
    sessionData.dependentMeasures_tr(trIdx).trailMinClearanceFrame = NaN;
    
    return
end
%%

numberOfFootMarkers = length(sessionData.rawData_tr(trIdx).rFoot.mkrPos_mIdx_Cfr_xyz);

if( numberOfFootMarkers ~= length(sessionData.rawData_tr(trIdx).lFoot.mkrPos_mIdx_Cfr_xyz) )
    error('findMinDistanceAXS: Assumption that num markeres for both feet is equal has been violated.  Adjust the code to fix.')
    return
end

%%

footString_fIdx = {'lFoot','rFoot'};

minClearance_fIdx_mkr = zeros(2,numberOfFootMarkers);
minClearanceFrame_fIdx_mkr = zeros(2,numberOfFootMarkers);

for fIdx  = 1:2
    for mIdx = 1:numberOfFootMarkers
        
        footString = footString_fIdx{fIdx};
        
        if( strcmp(footString,'lFoot'))
            
            crossingFrame = sessionData.dependentMeasures_tr(trIdx).lFoot.crossingFr;
        
        else
        
            crossingFrame = sessionData.dependentMeasures_tr(trIdx).rFoot.crossingFr;
        
        end
        
        searchFrames = (crossingFrame - crossingSearchWindowSize):(crossingFrame + crossingSearchWindowSize);
               
        mData_fr_XYZ = sessionData.processedData_tr(trIdx).(footString).mkrPos_mIdx_Cfr_xyz{mIdx}(searchFrames,:);
        
        obstacleXLocation = sessionData.rawData_tr(trIdx).obs.pos_xyz(1);
        obstacleYLocation = sessionData.rawData_tr(trIdx).obs.pos_xyz(2);
        obstacleZLocation = sessionData.rawData_tr(trIdx).obs.pos_xyz(3);
        
        %%
        % Selecting two points one meter away on the obstacle line (Triangle Base)
        
        pointC_fr = repmat([0.5, obstacleYLocation, obstacleZLocation],size(mData_fr_XYZ,1),1);
        pointB_fr = repmat([-0.5, obstacleYLocation, obstacleZLocation],size(mData_fr_XYZ,1),1);
        
        ac_fr = sqrt(sum((mData_fr_XYZ - pointC_fr).^2,2));
        ab_fr = sqrt(sum((mData_fr_XYZ - pointB_fr).^2,2));
        bc_fr = sqrt(sum((pointC_fr-pointB_fr).^2,2));
        
        S = (ab_fr + ac_fr + bc_fr) ./2; % Semiperimeter
        Area = sqrt( S.*(S-ab_fr) .* (S-ac_fr) .* (S-bc_fr));      % Area of the Triangle
        
        distance_fr = (2 .* Area)./bc_fr;
        
        [minVal, minFrameIdx] = min(distance_fr);
        
        minClearance_fIdx_mkr(fIdx,mIdx) = minVal;
        minClearanceFrame_fIdx_mkr(fIdx,mIdx) = minFrameIdx + searchFrames(1) - 1;
        
    end
end

[minClearance_LRFoot, closestMarkerMidx_LRFoot] = min(minClearance_fIdx_mkr,[],2);
minClearanceFrame_fIdx = [minClearanceFrame_fIdx_mkr(1,closestMarkerMidx_LRFoot(1)) minClearanceFrame_fIdx_mkr(2,closestMarkerMidx_LRFoot(2))];


%% 

if( strcmp( dmTrialStruct.firstCrossingFoot, 'Left' ) )

    leadIdx = 1;
    trailIdx = 2;
    
else
    leadIdx = 2;
    trailIdx = 1;
end

sessionData.dependentMeasures_tr(trIdx).leadMinClearanceAXS = minClearance_LRFoot(leadIdx);
sessionData.dependentMeasures_tr(trIdx).leadMinClearanceMidx = closestMarkerMidx_LRFoot(leadIdx);
sessionData.dependentMeasures_tr(trIdx).leadMinClearanceFrame = minClearanceFrame_fIdx(leadIdx);

sessionData.dependentMeasures_tr(trIdx).trailMinClearanceAXS = minClearance_LRFoot(trailIdx);
sessionData.dependentMeasures_tr(trIdx).trailMinClearanceMidx = closestMarkerMidx_LRFoot(trailIdx);
sessionData.dependentMeasures_tr(trIdx).trailMinClearanceFrame = minClearanceFrame_fIdx(trailIdx);
end