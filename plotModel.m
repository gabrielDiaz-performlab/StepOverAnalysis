function plotModel(sessionData, StepNum)

numUnbiasedTrials = length(sessionData.LeftStepModel);

% figure; hold on; grid on
% for i = 1:numUnbiasedTrials
%     tempLeft = sessionData.LeftStepModel{StepNum, i, 1};
%     plot3(tempLeft(:,4), tempLeft(:,2), tempLeft(:,3))
% end
% hold off
% 
% figure; hold on; grid on
% for i = 1:numUnbiasedTrials
%     tempRight = sessionData.RightStepModel{StepNum, i, 1};
%     plot3(tempRight(:,4), tempRight(:,2), tempRight(:,3))    
% end
% hold off

tempRight = []; tempLeft = [];

for i = 1:numUnbiasedTrials
    tempRight(i,:) = sessionData.RightStepModel{StepNum, i, 2};
    tempLeft(i,:) = sessionData.LeftStepModel{StepNum, i ,2};
end

figure;
subplot(1,2,1); plot(tempRight(:,1), tempRight(:,2), 'rx'); title('Unbiased right foot points')
subplot(1,2,2); plot(tempLeft(:,1), tempLeft(:,2), 'rx'); title('Unbiased left foot points')

tempRight = []; tempLeft = [];

figure; hold on; grid on; title('Unbiased Feet Trajectories')
m = 1;
for i = 1:size(sessionData.RightStepModel,1)
    for j = 1:size(sessionData.RightStepModel,2)
        tempRight = sessionData.RightStepModel{i,j,1};        
        plot3(tempRight(:,4), tempRight(:,2), tempRight(:,3),'r'); 
        m = m + 1;
    end
end

% figure; hold on; grid on; title('Unbiased all left foot step trajectories')
m = 1;
for i = 1:size(sessionData.LeftStepModel,1)
    for j = 1:size(sessionData.LeftStepModel,2)
        tempLeft = sessionData.LeftStepModel{i,j,1}; 
        plot3(tempLeft(:,4), tempLeft(:,2), tempLeft(:,3),'b'); 
        m = m + 1;
    end
end

legend('Red - Right','Left - Blue')

tempRight = []; tempLeft = [];

m = 1;
for i = 1:size(sessionData.LeftStepModel,1)
    for j = 1:size(sessionData.LeftStepModel,2)
        tempRight(m,:) = sessionData.RightStepModel{i, j, 2};
        tempLeft(m,:) = sessionData.LeftStepModel{i,j,2};
        m = m + 1;
    end
end

figure;
subplot(1,2,1); plot(tempRight(:,1), tempRight(:,2), 'rx'); title('Unbiased right foot points for all steps'); axis([0.3 0.55 0.7 1.1])
subplot(1,2,2); plot(tempLeft(:,1), tempLeft(:,2), 'rx'); title('Unbiased left foot points for all steps'); axis([0.3 0.55 0.7 1.1])

end