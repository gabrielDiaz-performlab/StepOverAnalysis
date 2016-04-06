function sessionData = decodeTimeStamps(sessionData)

eleList = {'rFoot','lFoot','glasses','spine'};

for trIdx = 1:sessionData.expInfo.numTrials
    for eleIdx = 1:length(eleList)
        rbSysTime = sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbPosSysTime_mFr_xyz;
        rbSysTime = datetime(rbSysTime, 'ConvertFrom', 'posixtime');
        rbSysTime = rbSysTime.Hour*60*60 + rbSysTime.Minute*60 + rbSysTime.Second;
        
        sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbPosSysTime_mFr_xyz = rbSysTime;
        sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbQuatSysTime_mFr = rbSysTime;  
        
        mkrTime = sessionData.rawData_tr(trIdx).(eleList{eleIdx}).mkrSysTime_mIdx_Cfr;
        
        for mkrIdx = 1:length(mkrTime)
            temp = datetime(mkrTime{mkrIdx}, 'ConvertFrom', 'posixtime');
            temp = temp.Hour*60*60 + temp.Minute*60 + temp.Second;
            mkrTime(mkrIdx) = {temp};
        end
        
        sessionData.rawData_tr(trIdx).(eleList{eleIdx}).mkrSysTime_mIdx_Cfr = mkrTime;
        
    end
    
    sysTime = sessionData.rawData_tr(trIdx).info.sysTime_fr;  
    sysTime = datetime(sysTime, 'ConvertFrom', 'posixtime');
    sysTime = sysTime.Hour*60*60 + sysTime.Minute*60 + sysTime.Second;
    sessionData.rawData_tr(trIdx).info.sysTime_fr = sysTime;
    
end
end