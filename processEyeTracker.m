function sessionData = processEyeTracker(sessionData, ETG_T, len_audioData_s)

TS = linspace(0, len_audioData_s, length(ETG_T.Time));

% ETG_VidDim = [720 960];

% Get the POR for the Cyclopean, Left and Right
B_POR = [ETG_T.BPORX_px_ ETG_T.BPORY_px_];
L_POR = [ETG_T.LPORX_px_ ETG_T.LPORY_px_];
R_POR = [ETG_T.RPORX_px_ ETG_T.RPORY_px_];

L_GVEC = [ETG_T.LGVECX ETG_T.LGVECY ETG_T.LGVECZ];
R_GVEC = [ETG_T.RGVECX ETG_T.RGVECY ETG_T.RGVECZ];

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
        sessionData.rawData_tr(i).ETG.ETG_ts = TS(loc);
    else
        sessionData.rawData_tr(i).ETG.B_POR = NaN; 
        sessionData.rawData_tr(i).ETG.L_POR = NaN; 
        sessionData.rawData_tr(i).ETG.R_POR = NaN; 
        sessionData.rawData_tr(i).ETG.L_GVEC = NaN; 
        sessionData.rawData_tr(i).ETG.R_GVEC = NaN;     
        sessionData.rawData_tr(i).ETG.ETG_ts = NaN;
    end
end
end