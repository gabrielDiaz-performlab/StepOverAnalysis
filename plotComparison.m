function [] = plotComparison(sessionData, stepNum)

obsHeightRatios = sessionData.expInfo.obsHeightRatios;
colorMat = linspecer(length(obsHeightRatios));

figure; suptitle('Trajectory analysis')
subplot(1,2,1); hold on;
xlabel('Time (S)'); ylabel('Distance (M)'); zlabel('Height (M)'); 
title(['Trajectories for: ' num2str(stepNum) ' Step before crossing step']); grid on
for trIdx = 1:sessionData.expInfo.numTrials
    
    if ~sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial
        obsHeightRatio_trIdx = sessionData.processedData_tr(trIdx).obs.height/sessionData.expInfo.legLength;
        colorToPlot = obsHeightRatios == obsHeightRatio_trIdx/100;
        biasedStepTrajectory = sessionData.dependentMeasures_tr(trIdx).stepFlow{end - stepNum, 4};
        biasedStepTS = sessionData.dependentMeasures_tr(trIdx).stepFlow{end - stepNum, 5};
        if sum(colorToPlot ~= 0)
            plot3(biasedStepTS, biasedStepTrajectory(:,2), biasedStepTrajectory(:,3), 'LineWidth', 3, 'Color', colorMat(colorToPlot, :))
        else
            plot3(biasedStepTS, biasedStepTrajectory(:,2), biasedStepTrajectory(:,3), 'LineWidth', 3, 'Color', [0 0 0])
        end
    end
end

for trIdx = 1:size(sessionData.RightStepModel, 2)
    for stepNum_idx = 1:size(sessionData.RightStepModel, 1) - 1
        tempmatR = sessionData.RightStepModel{stepNum_idx, trIdx, 1};
        tempmatL = sessionData.LeftStepModel{stepNum_idx, trIdx, 1};
        
        unbiasedRStepTrajectory = tempmatR(:,1:3);
        unbiasedRStepTime = tempmatR(:,end);
        
        unbiasedLStepTrajectory = tempmatL(:,1:3);
        unbiasedLStepTime = tempmatL(:,end);
        
        plot3(unbiasedRStepTime, unbiasedRStepTrajectory(:,2), unbiasedRStepTrajectory(:,3), 'LineWidth', 3, 'Color', [.5 .5 .5], 'LineStyle', '--')
        plot3(unbiasedLStepTime, unbiasedLStepTrajectory(:,2), unbiasedLStepTrajectory(:,3), 'LineWidth', 3, 'Color', [.5 .5 .5], 'LineStyle', '--')
    end
end
drawnow;
hold off

subplot(1,2,2); hold on;
xlabel('Time (S)'); ylabel('Distance (M)'); zlabel('Height (M)'); 
title(['Trajectory end points for: ' num2str(stepNum) ' step before crossing step']); grid on
for trIdx = 1:sessionData.expInfo.numTrials
    
    if ~sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial
        obsHeightRatio_trIdx = sessionData.processedData_tr(trIdx).obs.height/sessionData.expInfo.legLength;
        colorToPlot = obsHeightRatios == obsHeightRatio_trIdx/100;
        biasedStepTrajectoryEP = sessionData.dependentMeasures_tr(trIdx).stepFlow{end - stepNum, 6};
        if sum(colorToPlot)~=0
            scatter(biasedStepTrajectoryEP(:,1), biasedStepTrajectoryEP(:,2), 50, colorMat(colorToPlot, :))
        else
            scatter(biasedStepTrajectoryEP(:,1), biasedStepTrajectoryEP(:,2), 50, [0 0 0])
        end
    end
end
for trIdx = 1:size(sessionData.RightStepModel, 2)
    for stepNum_idx = 1:size(sessionData.RightStepModel, 1) - 1
        unbiasedRStepTrajectoryEP = sessionData.RightStepModel{stepNum_idx, trIdx, 2};
        unbiasedLStepTrajectoryEP = sessionData.LeftStepModel{stepNum_idx, trIdx, 2};
              
        scatter(unbiasedRStepTrajectoryEP(:,1), unbiasedRStepTrajectoryEP(:,2), 200, [.5 .5 .5], '*');
        scatter(unbiasedLStepTrajectoryEP(:,1), unbiasedLStepTrajectoryEP(:,2), 200, [.5 .5 .5], '*');
    end
end
hold off;
drawnow;
end