function sessionData = processEyeTracker(sessionData, ETG_T, len_audioData_s)

TS = linspace(0, len_audioData_s, length(ETG_T.Time));

% Get the POR for the Cyclopean, Left and Right
B_POR = [ETG_T.BPORX_px_ ETG_T.BPORY_px_];
L_POR = [ETG_T.LPORX_px_ ETG_T.LPORY_px_];
R_POR = [ETG_T.RPORX_px_ ETG_T.RPORY_px_];

L_GVEC = [ETG_T.LGVECX ETG_T.LGVECY ETG_T.LGVECZ];
R_GVEC = [ETG_T.RGVECX ETG_T.RGVECY ETG_T.RGVECZ];

% Interpolate through blinking period
B_POR = blinkCorrection(B_POR, TS); L_POR = blinkCorrection(L_POR, TS); R_POR = blinkCorrection(R_POR, TS);
L_GVEC = blinkCorrection(L_GVEC, TS); R_GVEC = blinkCorrection(R_GVEC, TS);

for i = 1:sessionData.expInfo.numTrials
    t1 = sessionData.rawData_tr(i).ETG.tr_Start;
    t2 = sessionData.rawData_tr(i).ETG.tr_Stop;
    if ~isnan(t1) && ~isnan(t2) 
        loc = TS <= t2 & TS >= t1;  
        sessionData.rawData_tr(i).ETG.B_POR = B_POR(loc,:); 
        sessionData.rawData_tr(i).ETG.L_POR = L_POR(loc,:); 
        sessionData.rawData_tr(i).ETG.R_POR = R_POR(loc,:); 
        sessionData.rawData_tr(i).ETG.L_GVEC = L_GVEC(loc,:); 
        sessionData.rawData_tr(i).ETG.R_GVEC = R_GVEC(loc,:);         
    else
        sessionData.rawData_tr(i).ETG.B_POR = NaN; 
        sessionData.rawData_tr(i).ETG.L_POR = NaN; 
        sessionData.rawData_tr(i).ETG.R_POR = NaN; 
        sessionData.rawData_tr(i).ETG.L_GVEC = NaN; 
        sessionData.rawData_tr(i).ETG.R_GVEC = NaN;     
    end
end
end