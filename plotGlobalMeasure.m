function [] = plotGlobalMeasure(globalData)
% Plot a measures variability.

for i = 1:size(globalData,2)-1
    xData = single(cell2mat(globalData(2:end,end - 1)));
    yData = cell2mat(globalData(2:end,i));
    
    xData = repmat(xData, [1 size(yData, 2)]);
    
    % If multiple values in 1 measure, plot them in different figures
    colorMat = linspecer(size(yData, 2));
    for j = 1:size(yData, 2)
        
        [xData(:,j), loc] = sort(xData(:,j), 'ascend');
        yData(:,j) = yData(loc,j);
        
        X_vals = unique(xData(:,j));
        mean_Y = zeros(length(X_vals), 1);
        mean_X = zeros(length(X_vals), 1);
        err = zeros(length(X_vals), 1);
        
        for k = 1:length(X_vals)
           mean_X(k) = nanmean(xData(xData(:,j) == X_vals(k), j)); 
           mean_Y(k) = nanmean(yData(xData(:,j) == X_vals(k), j)); 
           err(k) = nanstd(yData(xData(:,j) == X_vals(k), j));
        end
                    
        figure; hold on; grid on;
%         scatter(xData(:,j), yData(:,j),50, colorMat(j,:));
        scatter(mean_X, mean_Y, 60, [0 0 0], 'x', 'LineWidth', 3);
        errorbar(mean_X(1:3), mean_Y(1:3), err(1:3), 'LineWidth', 3, 'Color',  colorMat(j,:))
        plot(mean_X(1:3), mean_Y(1:3), 'LineWidth', 3, 'Color',[0 0 0])
%         axis([0.1 0.4 min(yData(:,j)) max(yData(:,j))])
        title([globalData(1,i) 'vs Obstacle Height Ratio'])
    end

end