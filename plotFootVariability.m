function [] = plotFootVariability( sessionData )

colorMat = [1 0 1;1 1 0; 0 1 1];
obsHeights = sessionData.expInfo.obsHeightRatios*sessionData.expInfo.legLength*100;

figure; hold on
plot([0,0],[0 obsHeights(3)],'Color',colorMat(3,:),'LineWidth', 3)
plot([0 0],[0 obsHeights(2)],'Color',colorMat(2,:),'LineWidth', 3)
plot([0 0],[0 obsHeights(1)],'Color',colorMat(1,:),'LineWidth', 3)
xlabel('Y axis')
ylabel('Height')
axis equal
grid on
title('Lead foot trajectory and variability')

for trIdx = 1:sessionData.expInfo.numTrials
   if ~sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial  
       
       crossingTraj = sessionData.dependentMeasures_tr(trIdx).leadFootCrossingTrajectory;
       crossingTraj(:,2) = crossingTraj(:,2) - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);
    
       onPoint = sessionData.dependentMeasures_tr(trIdx).leadFootPlacementVariability(1);
       offPoint = sessionData.dependentMeasures_tr(trIdx).leadFootPlacementVariability(2);
       
       colorI = colorMat(sessionData.processedData_tr(trIdx).obs.height == obsHeights,:);
       
       if isempty(colorI)
           colorI = [0 0 0];
       end
       
       plot(crossingTraj(:,2),crossingTraj(:,3),'Color',colorI) 
       plot(onPoint,0,'Color',colorI,'Marker','x')
       plot(offPoint,0,'Color',colorI,'Marker','o')
   end
end

figure; hold on
plot([0,0],[0 obsHeights(3)],'Color',colorMat(3,:),'LineWidth', 3)
plot([0 0],[0 obsHeights(2)],'Color',colorMat(2,:),'LineWidth', 3)
plot([0 0],[0 obsHeights(1)],'Color',colorMat(1,:),'LineWidth', 3)
xlabel('Y axis')
ylabel('Height')
axis equal
grid on
title('Trail foot trajectory and variability')

for trIdx = 1:sessionData.expInfo.numTrials
   if ~sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial  
       
       crossingTraj = sessionData.dependentMeasures_tr(trIdx).trailFootCrossingTrajectory;
       crossingTraj(:,2) = crossingTraj(:,2) - sessionData.processedData_tr(trIdx).obs.pos_xyz(2);
       
       onPoint = sessionData.dependentMeasures_tr(trIdx).trailFootPlacementVariability(1);
       offPoint = sessionData.dependentMeasures_tr(trIdx).trailFootPlacementVariability(2);
       
       colorI = colorMat(sessionData.processedData_tr(trIdx).obs.height == obsHeights,:);
       
       if isempty(colorI)
           colorI = [0 0 0];
       end
       
       plot(crossingTraj(:,2),crossingTraj(:,3),'Color',colorI) 
       plot(onPoint,0,'x','Color',colorI,'Marker','x')
       plot(offPoint,0,'o','Color',colorI,'Marker','o')
   end
end
end