function sessionData = filterData(sessionData)
%% Rakshit Kothari
% This function filters out high frequency components by using a Guassian
% Window. Increase in Window Length -> Reduction in High frequency
% components. 

% Define filter
f = gausswin(100);

% Normalize filter
f = f/sum(f);

dataTypes = {'rFoot','lFoot','glasses','spine'};

pData = sessionData.processedData_tr;

for trIdx = 1:sessionData.expInfo.numTrials
    for i = 1:length(dataTypes)
        rb_xyz = pData(trIdx).(dataTypes{i}).rbPos_mFr_xyz;
        mkr_xyz = pData(trIdx).(dataTypes{i}).mkrPos_mIdx_Cfr_xyz;
        
        rb_xyz = filter_xyz_Data( rb_xyz, f);
        
        for mkrIdx = 1:length(mkr_xyz)
           mkr_xyz(mkrIdx) = {filter_xyz_Data( mkr_xyz{mkrIdx}, f)};   
        end
        
        pData(trIdx).(dataTypes{i}).rbPos_mFr_xyz = rb_xyz;
        pData(trIdx).(dataTypes{i}).mkrPos_mIdx_Cfr_xyz = mkr_xyz;
    end
end

sessionData.processedData_tr = pData;

end