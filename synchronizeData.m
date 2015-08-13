function sessionData = synchronizeData(sessionData)

for i = 1:sessionData.expInfo.numTrials
    
    fr_time = sessionData.rawData_tr(i).info.sysTime_fr; 
    
    LFoot = sessionData.rawData_tr(i).lFoot;
    RFoot = sessionData.rawData_tr(i).rFoot;
    Glasses = sessionData.rawData_tr(i).glasses;
    Spine = sessionData.rawData_tr(i).spine;

    LFoot_rb_xyz = cell2mat(LFoot.rbPos_mFr_xyz);
    RFoot_rb_xyz = cell2mat(RFoot.rbPos_mFr_xyz);
    Glasses_rb_xyz = cell2mat(Glasses.rbPos_mFr_xyz);
    Spine_rb_xyz = cell2mat(Spine.rbPos_mFr_xyz);

    LFoot_fr_xyz = LFoot.pos_fr_xyz;
    
    LFoot_rb_time = cell2mat(LFoot.rbPosSysTime_mFr_xyz);
    RFoot_rb_time = cell2mat(RFoot.rbPosSysTime_mFr_xyz);
    Glasses_rb_time = cell2mat(Glasses.rbPosSysTime_mFr_xyz);
    Spine_rb_time = cell2mat(Spine.rbPosSysTime_mFr_xyz);

    CTS = unique([LFoot_rb_time; RFoot_rb_time; Glasses_rb_time; Spine_rb_time; fr_time]);
    size(CTS)
    
    % Interpolate values and assign values before start and end to 0
    LFoot_rb_xyz = interp1(LFoot_rb_time, LFoot_rb_xyz, CTS);
    loc = CTS > LFoot_rb_time(end) | CTS < LFoot_rb_time(1);
    LFoot_rb_xyz(loc,:) = 0;

    RFoot_rb_xyz = interp1(RFoot_rb_time, RFoot_rb_xyz, CTS);
    loc = CTS > RFoot_rb_time(end) | CTS < RFoot_rb_time(1);
    RFoot_rb_xyz(loc,:) = 0;

    Glasses_rb_xyz = interp1(Glasses_rb_time, Glasses_rb_xyz, CTS);
    loc = CTS > Glasses_rb_time(end) | CTS < Glasses_rb_time(1);
    Glasses_rb_xyz(loc,:) = 0;

    Spine_rb_xyz = interp1(Spine_rb_time, Spine_rb_xyz, CTS);
    loc = CTS > Spine_rb_time(end) | CTS < Spine_rb_time(1);
    Spine_rb_xyz(loc,:) = 0;
    
    LFoot_fr_xyz = interp1(fr_time, LFoot_fr_xyz, CTS );
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    LFoot_fr_xyz(loc,:) = 0;

    % Assign new time stamp
    LFoot.rbPosSysTime_mFr_xyz = {CTS};
    RFoot.rbPosSysTime_mFr_xyz = {CTS};
    Glasses.rbPosSysTime_mFr_xyz = {CTS};
    Spine.rbPosSysTime_mFr_xyz = {CTS};
    
    sessionData.rawData_tr(i).info.sysTime_fr = CTS;
    
    % Assign interpolated values
    LFoot.rbPos_mFr_xyz = {LFoot_rb_xyz};
    RFoot.rbPos_mFr_xyz = {RFoot_rb_xyz};
    Glasses.rbPos_mFr_xyz = {Glasses_rb_xyz};
    Spine.rbPos_mFr_xyz = {Spine_rb_xyz};

    LFoot.pos_fr.xyz = LFoot_fr_xyz;
    
    % Commit changes into sessionData
    sessionData.rawData_tr(i).lFoot = LFoot;
    sessionData.rawData_tr(i).rFoot = RFoot;
    sessionData.rawData_tr(i).glasses = Glasses;
    sessionData.rawData_tr(i).spine = Spine;

end
end