function sessionData = synchronizeData(sessionData)

for i = 1:sessionData.expInfo.numTrials
    
    fr_time = sessionData.rawData_tr(i).info.sysTime_fr; 
    [fr_time,loc,~] = unique(fr_time);
          
    LFoot = sessionData.rawData_tr(i).lFoot;
    RFoot = sessionData.rawData_tr(i).rFoot;
    Glasses = sessionData.rawData_tr(i).glasses;
    Spine = sessionData.rawData_tr(i).spine;

    LFoot_fr_xyz = LFoot.pos_fr_xyz; LFoot_fr_xyz = LFoot_fr_xyz(loc,:);
    RFoot_fr_xyz = RFoot.pos_fr_xyz; RFoot_fr_xyz = RFoot_fr_xyz(loc,:);
    Glasses_fr_xyz = Glasses.pos_fr_xyz; Glasses_fr_xyz = Glasses_fr_xyz(loc,:);
    Spine_fr_xyz = Spine.pos_fr_xyz; Spine_fr_xyz = Spine_fr_xyz(loc,:);
           
    LFoot_rb_time = cell2mat(LFoot.rbPosSysTime_mFr_xyz); [LFoot_rb_time, loc1, ~] = unique(LFoot_rb_time);
    RFoot_rb_time = cell2mat(RFoot.rbPosSysTime_mFr_xyz); [RFoot_rb_time, loc2, ~] = unique(RFoot_rb_time);
    Glasses_rb_time = cell2mat(Glasses.rbPosSysTime_mFr_xyz); [Glasses_rb_time, loc3, ~] = unique(Glasses_rb_time);
    Spine_rb_time = cell2mat(Spine.rbPosSysTime_mFr_xyz); [Spine_rb_time, loc4, ~] = unique(Spine_rb_time);

    LFoot_rb_xyz = cell2mat(LFoot.rbPos_mFr_xyz); LFoot_rb_xyz = LFoot_rb_xyz(loc1,:);
    RFoot_rb_xyz = cell2mat(RFoot.rbPos_mFr_xyz); RFoot_rb_xyz = RFoot_rb_xyz(loc2,:);
    Glasses_rb_xyz = cell2mat(Glasses.rbPos_mFr_xyz); Glasses_rb_xyz = Glasses_rb_xyz(loc3,:);
    Spine_rb_xyz = cell2mat(Spine.rbPos_mFr_xyz); Spine_rb_xyz = Spine_rb_xyz(loc4,:);
    
    LFoot_mkr_xyz = LFoot.mkrPos_mIdx_Cfr_xyz;
    RFoot_mkr_xyz = RFoot.mkrPos_mIdx_Cfr_xyz;
    Glasses_mkr_xyz = Glasses.mkrPos_mIdx_Cfr_xyz;
    Spine_mkr_xyz = Spine.mkrPos_mIdx_Cfr_xyz; 
    
    LFoot_mkr_time = unique(cell2mat(LFoot.mkrSysTime_mIdx_Cfr));
    RFoot_mkr_time = unique(cell2mat(RFoot.mkrSysTime_mIdx_Cfr));
    Glasses_mkr_time = unique(cell2mat(Glasses.mkrSysTime_mIdx_Cfr));
    Spine_mkr_time = unique(cell2mat(Spine.mkrSysTime_mIdx_Cfr));
    
    fTS = min([fr_time(1) LFoot_rb_time(1) RFoot_rb_time(1) Glasses_rb_time(1) Spine_rb_time(1)...
        LFoot_mkr_time(1) RFoot_mkr_time(1) Glasses_mkr_time(1) Spine_mkr_time(1)]);
    
    %Zeroing different time stamps
    fr_time = fr_time - fTS;
    LFoot_rb_time = LFoot_rb_time - fTS; LFoot_mkr_time = LFoot_mkr_time - fTS;
    RFoot_rb_time = RFoot_rb_time - fTS; RFoot_mkr_time = RFoot_mkr_time - fTS;
    Glasses_rb_time = Glasses_rb_time - fTS; Glasses_mkr_time = Glasses_mkr_time - fTS;
    Spine_rb_time = Spine_rb_time - fTS; Spine_mkr_time = Spine_mkr_time - fTS;
    
    CTS1 = unique([LFoot_rb_time; RFoot_rb_time; Glasses_rb_time; Spine_rb_time; fr_time;...
        LFoot_mkr_time; RFoot_mkr_time; Glasses_mkr_time; Spine_mkr_time]);
    
    CTS = linspace(CTS1(1),CTS1(end),10000)';
               
    % Interpolate Rigid body and Vizard values and assign values before start and end to 0
    LFoot_rb_xyz = interp1(LFoot_rb_time, LFoot_rb_xyz, CTS,'spline','extrap');
    loc = CTS > LFoot_rb_time(end) | CTS < LFoot_rb_time(1);
    LFoot_rb_xyz(loc,:) = 0;

    RFoot_rb_xyz = interp1(RFoot_rb_time, RFoot_rb_xyz, CTS,'spline','extrap');
    loc = CTS > RFoot_rb_time(end) | CTS < RFoot_rb_time(1);
    RFoot_rb_xyz(loc,:) = 0;

    Glasses_rb_xyz = interp1(Glasses_rb_time, Glasses_rb_xyz, CTS,'spline','extrap');
    loc = CTS > Glasses_rb_time(end) | CTS < Glasses_rb_time(1);
    Glasses_rb_xyz(loc,:) = 0;

    Spine_rb_xyz = interp1(Spine_rb_time, Spine_rb_xyz, CTS,'spline','extrap');
    loc = CTS > Spine_rb_time(end) | CTS < Spine_rb_time(1);
    Spine_rb_xyz(loc,:) = 0;
    
    LFoot_fr_xyz = interp1(fr_time, LFoot_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    LFoot_fr_xyz(loc,:) = 0;
    
    RFoot_fr_xyz = interp1(fr_time, RFoot_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    RFoot_fr_xyz(loc,:) = 0;
    
    Glasses_fr_xyz = interp1(fr_time, Glasses_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    Glasses_fr_xyz(loc,:) = 0;
    
    Spine_fr_xyz = interp1(fr_time, Spine_fr_xyz, CTS,'spline','extrap');
    loc = CTS > fr_time(end) | CTS < fr_time(1);
    Spine_fr_xyz(loc,:) = 0;

    % Interpolate LFoot Marker data & Assign time stamp
    for j = 1:length(LFoot_mkr_xyz)
       [mkr_TS,loc,~] = unique(LFoot.mkrSysTime_mIdx_Cfr{j}); 
       LFoot_mkr_xyz{j} = interp1(mkr_TS, LFoot_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       LFoot.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate RFoot Marker data
    for j = 1:length(RFoot_mkr_xyz)
       [mkr_TS,loc,~] = unique(RFoot.mkrSysTime_mIdx_Cfr{j}); 
       RFoot_mkr_xyz{j} = interp1(mkr_TS, RFoot_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       RFoot.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate Glasses Marker data
    for j = 1:length(Glasses_mkr_xyz)
       [mkr_TS,loc,~] = unique(Glasses.mkrSysTime_mIdx_Cfr{j}); 
       Glasses_mkr_xyz{j} = interp1(mkr_TS, Glasses_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       Glasses.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Interpolate Spine Marker data
    for j = 1:length(Spine_mkr_xyz)
       [mkr_TS,loc,~] = unique(Spine.mkrSysTime_mIdx_Cfr{j}); 
       Spine_mkr_xyz{j} = interp1(mkr_TS, Spine_mkr_xyz{j}(loc,:), CTS,'spline','extrap'); 
       Spine.mkrSysTime_mIdx_Cfr{j} = CTS;
    end
    
    % Assign Marker data
    LFoot.mkrPos_mIdx_Cfr_xyz = LFoot_mkr_xyz;
    RFoot.mkrPos_mIdx_Cfr_xyz = RFoot_mkr_xyz;
    Glasses.mkrPos_mIdx_Cfr_xyz = Glasses_mkr_xyz;
    Spine.mkrPos_mIdx_Cfr_xyz = Spine_mkr_xyz;
    
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

    LFoot.pos_fr_xyz = LFoot_fr_xyz;
    RFoot.pos_fr_xyz = RFoot_fr_xyz;
    Glasses.pos_fr_xyz = Glasses_fr_xyz;
    Spine.pos_fr_xyz = Spine_fr_xyz;
    
    % Commit changes into sessionData
    sessionData.rawData_tr(i).lFoot = LFoot;
    sessionData.rawData_tr(i).rFoot = RFoot;
    sessionData.rawData_tr(i).glasses = Glasses;
    sessionData.rawData_tr(i).spine = Spine;

end
end