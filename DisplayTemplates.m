function [] = DisplayTemplates(sessionData, str, StepNum)

figure; hold on; grid on;
xlabel('Time (s)'); ylabel('Y (m)'); zlabel('Z (m)'); title([str ' Data with Step Number: ' num2str(StepNum)])
for i = 1:sessionData.expInfo.numTrials
    
    if ~sessionData.processedData_tr(i).info.isBlankTrial && ~sessionData.processedData_tr(i).info.excludeTrial  
        ZData = sessionData.dependentMeasures_tr(i).(str).footTrajectory{StepNum,1}(:,3);
        YData = sessionData.dependentMeasures_tr(i).(str).footTrajectory{StepNum,1}(:,2);
        TData = sessionData.dependentMeasures_tr(i).(str).footTrajectory{StepNum,2};
        plot3(TData, YData, ZData)
    end
    
end
hold off
end