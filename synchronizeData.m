function sessionData = synchronizeData(sessionData)

for i = 1:sessionData.expInfo.numTrials
    
    LFoot = sessionData.rawData_tr(i).lFoot;
    RFoot = sessionData.rawData_tr(i).rFoot;
    Glasses = sessionData.rawData_tr(i).glasses;
    Spine = sessionData.rawData_tr(i).spine;

    LFoot_rb_xyz = cell2mat(LFoot.rbPos_mFr_xyz);
    RFoot_rb_xyz = cell2mat(RFoot.rbPos_mFr_xyz);
    Glasses_rb_xyz = cell2mat(Glasses.rbPos_mFr_xyz);
    Spine_rb_xyz = cell2mat(Spine.rbPos_mFr_xyz);

    LFoot_rb_time = cell2mat(LFoot.rbPosSysTime_mFr_xyz);
    RFoot_rb_time = cell2mat(RFoot.rbPosSysTime_mFr_xyz);
    Glasses_rb_time = cell2mat(Glasses.rbPosSysTime_mFr_xyz);
    Spine_rb_time = cell2mat(Spine.rbPosSysTime_mFr_xyz);

    rb_CTS = unique([LFoot_rb_time; RFoot_rb_time; Glasses_rb_time; Spine_rb_time]);
    size(rb_CTS)
    % Interpolate values and assign values before start and end to 0
    LFoot_rb_xyz = interp1(LFoot_rb_time, LFoot_rb_xyz, rb_CTS);
    loc = rb_CTS > LFoot_rb_time(end) | rb_CTS < LFoot_rb_time(1);
    LFoot_rb_xyz(loc,:) = 0;

    RFoot_rb_xyz = interp1(RFoot_rb_time, RFoot_rb_xyz, rb_CTS);
    loc = rb_CTS > RFoot_rb_time(end) | rb_CTS < RFoot_rb_time(1);
    RFoot_rb_xyz(loc,:) = 0;

    Glasses_rb_xyz = interp1(Glasses_rb_time, Glasses_rb_xyz, rb_CTS);
    loc = rb_CTS > Glasses_rb_time(end) | rb_CTS < Glasses_rb_time(1);
    Glasses_rb_xyz(loc,:) = 0;

    Spine_rb_xyz = interp1(Spine_rb_time, Spine_rb_xyz, rb_CTS);
    loc = rb_CTS > Spine_rb_time(end) | rb_CTS < Spine_rb_time(1);
    Spine_rb_xyz(loc,:) = 0;

    % Assign new time stamp
    LFoot.rbPosSysTime_mFr_xyz = {rb_CTS};
    RFoot.rbPosSysTime_mFr_xyz = {rb_CTS};
    Glasses.rbPosSysTime_mFr_xyz = {rb_CTS};
    Spine.rbPosSysTime_mFr_xyz = {rb_CTS};

    % Assign interpolated values
    LFoot.rbPos_mFr_xyz = {LFoot_rb_xyz};
    RFoot.rbPos_mFr_xyz = {RFoot_rb_xyz};
    Glasses.rbPos_mFr_xyz = {Glasses_rb_xyz};
    Spine.rbPos_mFr_xyz = {Spine_rb_xyz};

    % Commit changes into sessionData
    sessionData.rawData_tr(i).lFoot = LFoot;
    sessionData.rawData_tr(i).rFoot = RFoot;
    sessionData.rawData_tr(i).glasses = Glasses;
    sessionData.rawData_tr(i).spine = Spine;

end
end