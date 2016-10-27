function sessionData = decodeTimeStamps(sessionData, ETG_T)

%% Get ETG time stamps

% Continue from here. Recreate the export data based on Video files. 
vidTime_ETG = ETG_T.VideoTime_h_m_s_ms_;

absTime_ETG = ETG_T.TimeOfDay_h_m_s_ms_;
absTime_ETG = cell2mat(absTime_ETG);
temp = zeros(size(absTime_ETG,1), 1);

for i = 1:length(absTime_ETG)
    temp1 = sscanf(absTime_ETG(i, :), '%f:%f:%f:%f');
    temp(i) = temp1(1)*60*60 + temp1(2)*60 + temp1(3) + temp1(4)/1000;
end

absTime_ETG = temp;

TS = absTime_ETG - absTime_ETG(1);

% Get the POR for the Cyclopean, Left and Right
B_POR = [ETG_T.PointOfRegardBinocularX_px_ ETG_T.PointOfRegardBinocularY_px_];
R_POR = [ETG_T.PointOfRegardRightX_px_ ETG_T.PointOfRegardRightY_px_];
L_POR = [ETG_T.PointOfRegardLeftX_px_ ETG_T.PointOfRegardLeftY_px_];

L_GVEC = [ETG_T.GazeVectorLeftX ETG_T.GazeVectorLeftY ETG_T.GazeVectorLeftZ];
R_GVEC = [ETG_T.GazeVectorRightX ETG_T.GazeVectorRightY ETG_T.GazeVectorRightZ];

% Interpolate through blinking period
B_POR = blinkCorrection(B_POR, TS); L_POR = blinkCorrection(L_POR, TS); R_POR = blinkCorrection(R_POR, TS);

% Remove points where eye is looking inward
loc1 = L_GVEC(:,3) < 0 | R_GVEC(:,3) < 0; 

C_GVEC = L_GVEC + R_GVEC; C_GVEC = normr(C_GVEC);
dotProd = dot(C_GVEC(1:end-1,:)',C_GVEC(2:end,:)');
dotProd(dotProd < -1) = -1; dotProd(dotProd > 1) = 1;

angDisp = acosd(dotProd); angDisp = [0 angDisp]; loc2 = angDisp > 15; % Because for a 60Hz ETG, angular disp cannot exceed 15 degrees
loc = loc1 | loc2';
% All locations where the angular dispacement exceeds 15 degrees are to be
% replaced by the closest valid sample.

list_bad = find(loc); list_good = find(~loc);

for i = 1:length(list_bad)
    [~,temp] = min(abs(list_good - list_bad(i)));
    
    L_GVEC(list_bad(i),:) = L_GVEC(list_good(temp),:);
    R_GVEC(list_bad(i),:) = R_GVEC(list_good(temp),:);
    C_GVEC(list_bad(i),:) = C_GVEC(list_good(temp),:);  
end


%% 
eleList = {'rFoot','lFoot','glasses','spine'};

for trIdx = 1:sessionData.expInfo.numTrials
     time = [];
    for eleIdx = 1:length(eleList)
       
        rbSysTime = sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbPosSysTime_mFr_xyz;
        rbSysTime = datetime(rbSysTime, 'ConvertFrom', 'posixtime','TimeZone','America/New_York');
        rbSysTime = rbSysTime.Hour*60*60 + rbSysTime.Minute*60 + rbSysTime.Second;
        
        time = unique([time rbSysTime]);
        
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbPosSysTime_mFr_xyz = rbSysTime;
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbQuatSysTime_mFr = rbSysTime;  
        
        mkrTime = sessionData.rawData_tr(trIdx).(eleList{eleIdx}).mkrSysTime_mIdx_Cfr;
        
        for mkrIdx = 1:length(mkrTime)
            temp = datetime(mkrTime{mkrIdx}, 'ConvertFrom', 'posixtime','TimeZone','America/New_York');
            temp = temp.Hour*60*60 + temp.Minute*60 + temp.Second;
%             mkrTime(mkrIdx) = {temp};
            
            time = unique([time temp']);
        end
        
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).mkrSysTime_mIdx_Cfr = mkrTime;
        
    end
    
    sysTime = sessionData.rawData_tr(trIdx).info.sysTime_fr;  
    sysTime = datetime(sysTime, 'ConvertFrom', 'posixtime','TimeZone','America/New_York');
    sysTime = sysTime.Hour*60*60 + sysTime.Minute*60 + sysTime.Second;
    time = unique([time sysTime']);
    
    sessionData.rawData_tr(trIdx).ETG.B_POR = interp1(absTime_ETG, B_POR, time, 'pchip'); 
    sessionData.rawData_tr(trIdx).ETG.L_POR = interp1(absTime_ETG, L_POR, time, 'pchip'); 
    sessionData.rawData_tr(trIdx).ETG.R_POR = interp1(absTime_ETG, R_POR, time, 'pchip'); 
    sessionData.rawData_tr(trIdx).ETG.L_GVEC = interp1(absTime_ETG, L_GVEC, time, 'pchip'); 
    sessionData.rawData_tr(trIdx).ETG.R_GVEC = interp1(absTime_ETG, R_GVEC, time, 'pchip');
    sessionData.rawData_tr(trIdx).ETG.ETG_ts = time;
    
    
%     % Assign unique time stamp values
%     sessionData.rawData_tr(trIdx).info.sysTime_fr = sysTime;
%     for eleIdx = 1:length(eleList)
% 
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbPosSysTime_mFr_xyz = rbSysTime;
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).rbQuatSysTime_mFr = rbSysTime;  
% 
%         for mkrIdx = 1:length(mkrTime)
%             mkrTime(mkrIdx) = {time};    
%         end
% 
%         sessionData.rawData_tr(trIdx).(eleList{eleIdx}).mkrSysTime_mIdx_Cfr = mkrTime;
end
end