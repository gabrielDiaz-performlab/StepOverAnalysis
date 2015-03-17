function Distance = FindStepOverDistance( SessionData, trIdx,  leftFootCrossingFr, leftFootMkrIdx)

    trialStruct = SessionData.RawData_tr(trIdx);
        
    Obstacle_X = trialStruct.Obstacle_XYZ(1);
    
    CalculateMinimumDistance(SessionData.RawData_tr(trIdx))
    
    
end
