function sessionData = generateStepFlow(sessionData)

for trIdx = 1:sessionData.expInfo.numTrials
    
%     if trIdx == 5
%         keyboard
%     end
    
    if ~sessionData.processedData_tr(trIdx).info.isBlankTrial && ~sessionData.processedData_tr(trIdx).info.excludeTrial
        StepModel = cell(1);
        lFootToeOff = sessionData.dependentMeasures_tr(trIdx).lFoot.toeOff_idx;  
        lFootHealStrike = sessionData.dependentMeasures_tr(trIdx).lFoot.heelStrike_idx;
        
        rFootToeOff = sessionData.dependentMeasures_tr(trIdx).rFoot.toeOff_idx;  
        rFootHealStrike = sessionData.dependentMeasures_tr(trIdx).rFoot.heelStrike_idx;
        
        [~, firstLegOff] = min([lFootToeOff(1); rFootToeOff(1)]);
        if firstLegOff == 1
            firstLegOff = 'Left';
        else
            firstLegOff = 'Right';
        end
        
        legToCross = sessionData.dependentMeasures_tr(trIdx).firstCrossingFoot;
        stepToCross = sessionData.dependentMeasures_tr(trIdx).StepToCross;
        
        lFootStepNumber = 1;
        rFootStepNumber = 1;
        currentFoot = firstLegOff;
        
        m = 1;
        while 1 
            if strcmp(currentFoot,'Left')         
                
                StepModel(m,1) = {m};
                StepModel(m,2) = {currentFoot};
                StepModel(m,3) = {[lFootToeOff(lFootStepNumber) lFootHealStrike(lFootStepNumber)]};
                StepModel(m,4) = (sessionData.dependentMeasures_tr(trIdx).lFoot.footTrajectory(lFootStepNumber, 1));
                StepModel(m,5) = (sessionData.dependentMeasures_tr(trIdx).lFoot.footTrajectory(lFootStepNumber, 2));
                StepModel(m,6) = (sessionData.dependentMeasures_tr(trIdx).lFoot.footTrajectory(lFootStepNumber, 3));
                if strcmp(currentFoot,legToCross) && lFootStepNumber == stepToCross;  
                    break;
                end
                currentFoot = 'Right';
                lFootStepNumber = lFootStepNumber + 1;
                
            elseif strcmp(currentFoot,'Right')        
                
                StepModel(m,1) = {m};
                StepModel(m,2) = {currentFoot};
                StepModel(m,3) = {[rFootToeOff(rFootStepNumber) rFootHealStrike(rFootStepNumber)]};
                StepModel(m,4) = (sessionData.dependentMeasures_tr(trIdx).rFoot.footTrajectory(rFootStepNumber, 1));
                StepModel(m,5) = (sessionData.dependentMeasures_tr(trIdx).rFoot.footTrajectory(rFootStepNumber, 2));
                StepModel(m,6) = (sessionData.dependentMeasures_tr(trIdx).rFoot.footTrajectory(rFootStepNumber, 3));  
                if strcmp(currentFoot,legToCross) && rFootStepNumber == stepToCross;
                    break;
                end
                currentFoot = 'Left';
                rFootStepNumber = rFootStepNumber + 1;
                
            else
                keyboard
            end 
            m = m + 1;
        end
        sessionData.dependentMeasures_tr(trIdx).stepFlow = StepModel;
        sessionData.dependentMeasures_tr(trIdx).objStepDist = size(StepModel, 1) - 1;
    end          
end
end
