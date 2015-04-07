function newVariable  = removeOutliers(variable,threshold)

% replaces outliers with nan values
newVariable = variable;

outlierIdx = [];
outlierIdx  = [outlierIdx  find( variable > nanmean(variable)+nanstd(variable)*threshold) ];
outlierIdx  = [outlierIdx  find( variable < nanmean(variable)-nanstd(variable)*threshold)];

% fprintf('Removed %u outliers \n',numel(outlierIdx))
newVariable ( outlierIdx) = NaN;