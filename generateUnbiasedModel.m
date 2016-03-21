function sessionData = generateUnbiasedModel(sessionData)

m = 1; Time = 0; NumBlankTrials = 0;
for trIdx = 1:sessionData.expInfo.numTrials
    if sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial
        NumBlankTrials = NumBlankTrials + 1;
        temp = sessionData.dependentMeasures_tr(trIdx).lFoot.unbiasedModel;
        Time = [Time; cell2mat(temp(:,2))];
        NumUnbiasedSteps(m) = size(temp,1);
        m = m + 1;
    
    end
end

Time = unique(Time);
NumUnbiasedSteps = floor(mean(NumUnbiasedSteps));
RightFootStepModel = cell(NumUnbiasedSteps - 1, NumBlankTrials, 2);
LeftFootStepModel = cell(NumUnbiasedSteps - 1, NumBlankTrials, 2);

m = 1;
for trIdx = 1:sessionData.expInfo.numTrials
    if sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial
        temp1 = sessionData.dependentMeasures_tr(trIdx).rFoot.unbiasedModel;
        temp2 = sessionData.dependentMeasures_tr(trIdx).lFoot.unbiasedModel;
             
        for i = 1:NumUnbiasedSteps - 1
            temp1
            i
            right_XYZ = interp1(temp1{i,2}, temp1{i,1}, Time);
            left_XYZ = interp1(temp2{i,2}, temp2{i,1}, Time);
            
            [pkvals_r, loc_r] = findpeaks(max(right_XYZ(:,3)) - right_XYZ(:,3));
            [pkvals_l, loc_l] = findpeaks(max(left_XYZ(:,3)) - left_XYZ(:,3));
            
            if isempty(loc_r)
                [~, loc_r] = min(right_XYZ(:,3));
            end
            
            if isempty(loc_l)
                [~, loc_l] = min(left_XYZ(:,3)); 
            end  
            
            if length(loc_r) >= 2
               loc_r = loc_r(pkvals_r == max(pkvals_r));
            end
            
            if length(loc_l) >= 2
               loc_l = loc_l(pkvals_l == max(pkvals_l));
            end
            
            RightFootStepModel(i,m,1) = {[right_XYZ Time]}; 
            RightFootStepModel(i,m,2) = {[Time(loc_r) right_XYZ(loc_r,2) right_XYZ(loc_r,3)]};
            
            LeftFootStepModel(i,m,1) = {[left_XYZ Time]}; 
            LeftFootStepModel(i,m,2) = {[Time(loc_l) left_XYZ(loc_l,2) left_XYZ(loc_l,3)]};
        end
        m = m + 1;
    end
end

sessionData.RightStepModel = RightFootStepModel;
sessionData.LeftStepModel = LeftFootStepModel;
end