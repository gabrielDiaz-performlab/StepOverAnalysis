function sessionData = synchronizeData(sessionData)

sessionData.rawData = sessionData.rawData_tr;

for i = 1:sessionData.expInfo.numTrials

    fr_time = sessionData.rawData_tr(i).info.sysTime_fr; 
    [fr_time,loc,~] = unique(fr_time);
          
    LFoot = sessionData.rawData_tr(i).lFoot;
    RFoot = sessionData.rawData_tr(i).rFoot;
    Glasses = sessionData.rawData_tr(i).glasses;
    Spine = sessionData.rawData_tr(i).spine;
    ETG = sessionData.rawData_tr(i).ETG;

    LFoot_fr_xyz = LFoot.pos_fr_xyz; LFoot_fr_xyz = LFoot_fr_xyz(loc,:);
    RFoot_fr_xyz = RFoot.pos_fr_xyz; RFoot_fr_xyz = RFoot_fr_xyz(loc,:);
    Glasses_fr_xyz = Glasses.pos_fr_xyz; Glasses_fr_xyz = Glasses_fr_xyz(loc,:);
    Glasses_fr_Quat = Glasses.quat_fr_wxyz; Glasses_fr_Quat = Glasses_fr_Quat(loc,:);
    
    LFoot_rot_xyz = LFoot.rot_fr_d1_d2; LFoot_rot_xyz = LFoot_rot_xyz(loc,:,:);
    RFoot_rot_xyz = RFoot.rot_fr_d1_d2; RFoot_rot_xyz = RFoot_rot_xyz(loc,:,:);
    Glasses_rot_xyz = Glasses.rot_fr_d1_d2; Glasses_rot_xyz = Glasses_rot_xyz(loc,:,:);
           
    LFoot_rb_time = LFoot.rbPosSysTime_mFr_xyz; [LFoot_rb_time, loc1, ~] = unique(LFoot_rb_time);
    RFoot_rb_time = RFoot.rbPosSysTime_mFr_xyz; [RFoot_rb_time, loc2, ~] = unique(RFoot_rb_time);
    Glasses_rb_time = Glasses.rbPosSysTime_mFr_xyz; [Glasses_rb_time, loc3, ~] = unique(Glasses_rb_time);
    Spine_rb_time = Spine.rbPosSysTime_mFr_xyz; [Spine_rb_time, loc4, ~] = unique(Spine_rb_time);

    LFoot_rb_xyz = LFoot.rbPos_mFr_xyz; LFoot_rb_xyz = LFoot_rb_xyz(loc1,:);
    RFoot_rb_xyz = RFoot.rbPos_mFr_xyz; RFoot_rb_xyz = RFoot_rb_xyz(loc2,:);
    Glasses_rb_xyz = Glasses.rbPos_mFr_xyz; Glasses_rb_xyz = Glasses_rb_xyz(loc3,:);
    Spine_rb_xyz = Spine.rbPos_mFr_xyz; Spine_rb_xyz = Spine_rb_xyz(loc4,:);
    
    LFoot_mkr_xyz = LFoot.mkrPos_mIdx_Cfr_xyz;
    RFoot_mkr_xyz = RFoot.mkrPos_mIdx_Cfr_xyz;
    Glasses_mkr_xyz = Glasses.mkrPos_mIdx_Cfr_xyz;
    Spine_mkr_xyz = Spine.mkrPos_mIdx_Cfr_xyz; 
    
    LFoot_mkr_time = unique(cell2mat(LFoot.mkrSysTime_mIdx_Cfr));
    RFoot_mkr_time = unique(cell2mat(RFoot.mkrSysTime_mIdx_Cfr));
    Glasses_mkr_time = unique(cell2mat(Glasses.mkrSysTime_mIdx_Cfr));
    Spine_mkr_time = unique(cell2mat(Spine.mkrSysTime_mIdx_Cfr));
    
    [Glasses_Quat_time, loc,~] = unique(Glasses.rbQuatSysTime_mFr); 
    Glasses_rb_Quat = Glasses.rbQuat_mFr_xyz; Glasses_rb_Quat = Glasses_rb_Quat(loc,:);
    
    fTS = min([fr_time(1) LFoot_rb_time(1) RFoot_rb_time(1) Glasses_rb_time(1) Spine_rb_time(1)...
        LFoot_mkr_time(1) RFoot_mkr_time(1) Glasses_mkr_time(1) Spine_mkr_time(1) Glasses_Quat_time(1)]);
    
    %Zeroing different time stamps
    fr_time = fr_time - fTS;
    LFoot_rb_time = LFoot_rb_time - fTS; LFoot_mkr_time = LFoot_mkr_time - fTS;
    RFoot_rb_time = RFoot_rb_time - fTS; RFoot_mkr_time = RFoot_mkr_time - fTS;
    Glasses_rb_time = Glasses_rb_time - fTS; Glasses_mkr_time = Glasses_mkr_time - fTS;
    Spine_rb_time = Spine_rb_time - fTS; Spine_mkr_time = Spine_mkr_time - fTS;
    Glasses_Quat_time = Glasses_Quat_time - fTS;
    
    CTS = unique([LFoot_rb_time'; RFoot_rb_time'; Glasses_rb_time'; Spine_rb_time'; fr_time;...
        LFoot_mkr_time; RFoot_mkr_time; Glasses_mkr_time; Spine_mkr_time]);    
    
    % Zeroing ETG time stamp and Interpolate ETG data to CTS
    ETG.ETG_ts = ETG.ETG_ts - ETG.ETG_ts(1);
    
    ETG.B_POR = interp1(ETG.ETG_ts, ETG.B_POR, CTS, 'spline', 'extrap');
    loc = CTS > ETG.ETG_ts(end) | CTS < ETG.ETG_ts(1);
    ETG.B_POR(loc,:) = NaN;
    
    ETG.L_POR = interp1(ETG.ETG_ts, ETG.L_POR, CTS, 'spline', 'extrap');
    loc = CTS > ETG.ETG_ts(end) | CTS < ETG.ETG_ts(1);
    ETG.L_POR(loc,:) = NaN;
    
    ETG.R_POR = interp1(ETG.ETG_ts, ETG.R_POR, CTS, 'spline', 'extrap');
    loc = CTS > ETG.ETG_ts(end) | CTS < ETG.ETG_ts(1);
    ETG.R_POR(loc,:) = NaN;

    ETG.L_GVEC = interp1(ETG.ETG_ts, ETG.L_GVEC, CTS, 'spline', 'extrap');
    loc = CTS > ETG.ETG_ts(end) | CTS < ETG.ETG_ts(1);
    ETG.L_GVEC(loc,:) = NaN;
    
    ETG.R_GVEC = interp1(ETG.ETG_ts, ETG.R_GVEC, CTS, 'spline', 'extrap');
    loc = CTS > ETG.ETG_ts(end) | CTS < ETG.ETG_ts(1);
    ETG.R_GVEC(loc,:) = NaN;
    
    ETG.ETG_ts = CTS;
      
    % Interpolate Quaternions
    Glasses_rb_Quat = interp1(Glasses_Quat_time', Glasses_rb_Quat, CTS, 'spline', 'extrap');
    loc = CTS > Glasses_Quat_time(end) | Glasses_Quat_time(1);
    Glasses_rb_Quat(loc,:) = NaN;
    
    % Interpolate Rigid body and Vizard values and assign values before start and end to 0
    LFoot_rb_xyz = interp1(LFoot_rb_time, LFoot_rb_xyz, CTS,'spline','extrap');
    loc = CTS > LFoot_rb_time(end) | CTS < LFoot_rb_time(1);
    LFoot_rb_xyz(loc,:) = NaN;

    RFoot_rb_xyz = interp1(RFoot_rb_time, RFoot_rb_xyz, CTS,'spline','extrap');
    loc = CTS > RFoot_rb_time(end) | CTS < RFoot_rb_time(1);
    RFoot_rb_xyz(loc,:) = NaN;

    Glasses_rb_xyz = interp1(Glasses_rb_time, Glasses_rb_xyz, CTS,'spline','extrap');
    loc = CTS > Glasses_rb_time(end) | CTS < Glasses_rb_time(1);
    Glasses_rb_xyz(loc,:) = NaN;

    Spine_rb_xyz = interp1(Spine_rb_time, Spine_rb_xyz, CTS,'spline','extrap');
    loc = CTS > Spine_rb_time(end) | CTS < Spine_rb_time(1);
    Spine_rb_xyz(loc,:) = NaN;
    
    LFoot_fr_xyz = interp1(fr_time, LFoot_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    LFoot_fr_xyz(loc,:) = NaN;
    
    RFoot_fr_xyz = interp1(fr_time, RFoot_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    RFoot_fr_xyz(loc,:) = NaN;
    
    Glasses_fr_xyz = interp1(fr_time, Glasses_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    Glasses_fr_xyz(loc,:) = NaN;
    
    Glasses_fr_Quat = interp1(fr_time, Glasses_fr_Quat, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    Glasses_fr_Quat(loc,:) = NaN;
    
    LFoot_rot_xyz = reshape(LFoot_rot_xyz, [length(LFoot_rot_xyz) 16]);
    LFoot_rot_xyz = interp1(fr_time, LFoot_rot_xyz, CTS,'spline','extrap');
    LFoot_rot_xyz = reshape(LFoot_rot_xyz, [length(LFoot_rot_xyz) 4 4]);
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    LFoot_rot_xyz(loc,:,:) = NaN;
    
    RFoot_rot_xyz = reshape(RFoot_rot_xyz, [length(RFoot_rot_xyz) 16]);
    RFoot_rot_xyz = interp1(fr_time, RFoot_rot_xyz, CTS,'spline','extrap');
    RFoot_rot_xyz = reshape(RFoot_rot_xyz, [length(RFoot_rot_xyz) 4 4]);
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    RFoot_rot_xyz(loc,:,:) = NaN;
    
    Glasses_rot_xyz = reshape(Glasses_rot_xyz, [length(Glasses_rot_xyz) 16]);
    Glasses_rot_xyz = interp1(fr_time, Glasses_rot_xyz, CTS,'spline','extrap');
    Glasses_rot_xyz = reshape(Glasses_rot_xyz, [length(Glasses_rot_xyz) 4 4]);
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    Glasses_rot_xyz(loc,:,:) = NaN;
       
%     Spine_fr_xyz = interp1(fr_time, Spine_fr_xyz, CTS,'spline','extrap');
%     loc = CTS > fr_time(end) | CTS < fr_time(1);
%     Spine_fr_xyz(loc,:) = NaN;

    % Interpolate LFoot Marker data & Assign time stamp
    for j = 1:length(LFoot_mkr_xyz)
       [mkr_TS,loc,~] = unique(LFoot.mkrSysTime_mIdx_Cfr{j}); mkr_TS = mkr_TS - fTS;
       temp = interp1(mkr_TS, LFoot_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       loc = CTS > mkr_TS(end) | CTS < mkr_TS(1);
       temp(loc,:) = NaN;
       LFoot_mkr_xyz{j} = temp; 
       LFoot.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate RFoot Marker data & Assign time stamp
    for j = 1:length(RFoot_mkr_xyz)
       [mkr_TS,loc,~] = unique(RFoot.mkrSysTime_mIdx_Cfr{j}); mkr_TS = mkr_TS - fTS;
       temp = interp1(mkr_TS, RFoot_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       loc = CTS > mkr_TS(end) | CTS < mkr_TS(1);
       temp(loc,:) = NaN;
       RFoot_mkr_xyz{j} = temp; 
       RFoot.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate Glasses Marker data & Assign time stamp
    for j = 1:length(Glasses_mkr_xyz)
       [mkr_TS,loc,~] = unique(Glasses.mkrSysTime_mIdx_Cfr{j}); mkr_TS = mkr_TS - fTS;
       temp = interp1(mkr_TS, Glasses_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       loc = CTS > mkr_TS(end) | CTS < mkr_TS(1);
       temp(loc,:) = NaN;
       Glasses_mkr_xyz{j} = temp;
       Glasses.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate Spine Marker data & Assign time stamp
    for j = 1:length(Spine_mkr_xyz)
       [mkr_TS,loc,~] = unique(Spine.mkrSysTime_mIdx_Cfr{j}); mkr_TS = mkr_TS - fTS;
       temp = interp1(mkr_TS, Spine_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       loc = CTS > mkr_TS(end) | CTS < mkr_TS(1);
       temp(loc,:) = NaN;
       Spine_mkr_xyz{j} = temp;
       Spine.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
         
    % Assign Marker data
    LFoot.mkrPos_mIdx_Cfr_xyz = LFoot_mkr_xyz;
    RFoot.mkrPos_mIdx_Cfr_xyz = RFoot_mkr_xyz;
    Glasses.mkrPos_mIdx_Cfr_xyz = Glasses_mkr_xyz;
    Spine.mkrPos_mIdx_Cfr_xyz = Spine_mkr_xyz;
    
    % Assign new time stamp
    LFoot.rbPosSysTime_mFr_xyz = CTS;
    RFoot.rbPosSysTime_mFr_xyz = CTS;
    Glasses.rbPosSysTime_mFr_xyz = CTS;
    Glasses.rbQuatSysTime_mFr = CTS;
    Spine.rbPosSysTime_mFr_xyz = CTS;
    
    sessionData.rawData_tr(i).info.sysTime_fr = CTS;
    
    % Assign interpolated values
    LFoot.rbPos_mFr_xyz = LFoot_rb_xyz;
    RFoot.rbPos_mFr_xyz = RFoot_rb_xyz;
    Glasses.rbPos_mFr_xyz = Glasses_rb_xyz;
    Spine.rbPos_mFr_xyz = Spine_rb_xyz;

    LFoot.pos_fr_xyz = LFoot_fr_xyz;
    RFoot.pos_fr_xyz = RFoot_fr_xyz;
    Glasses.pos_fr_xyz = Glasses_fr_xyz;
%     Spine.pos_fr_xyz = Spine_fr_xyz;
    
    LFoot.rot_fr_d1_d2 = LFoot_rot_xyz;
    RFoot.rot_fr_d1_d2 = RFoot_rot_xyz;
    Glasses.rot_fr_d1_d2 = Glasses_rot_xyz;

    Glasses.rbQuat_mFr_xyz = Glasses_rb_Quat;
    Glasses.quat_fr_wxyz = Glasses_fr_Quat;
    
    % Commit changes into sessionData
    sessionData.rawData_tr(i).lFoot = LFoot;
    sessionData.rawData_tr(i).rFoot = RFoot;
    sessionData.rawData_tr(i).glasses = Glasses;
    sessionData.rawData_tr(i).spine = Spine;
    sessionData.rawData_tr(i).ETG = ETG;

end

sessionData.processedData_tr = sessionData.rawData_tr;
sessionData.rawData_tr = sessionData.rawData;
sessionData = rmfield(sessionData,'rawData');
end