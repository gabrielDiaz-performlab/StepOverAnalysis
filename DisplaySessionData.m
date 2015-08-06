function [] = DisplaySessionData(sessionData, ax)

LFoot = sessionData.rawData_tr(3).lFoot;
RFoot = sessionData.rawData_tr.rFoot;
Glasses = sessionData.rawData_tr.glasses;
Spine = sessionData.rawData_tr.spine;

%Plot Rigid body phase space data
LFoot_rb_xyz = cell2mat(LFoot.rbPos_mFr_xyz);
LFoot_rb_time = cell2mat(LFoot.rbPosSysTime_mFr_xyz);

RFoot_rb_xyz = cell2mat(RFoot.rbPos_mFr_xyz);
RFoot_rb_time = cell2mat(RFoot.rbPosSysTime_mFr_xyz);

Glasses_rb_xyz = cell2mat(Glasses.rbPos_mFr_xyz);
Glasses_rb_time = cell2mat(Glasses.rbPosSysTime_mFr_xyz);

Spine_rb_xyz = cell2mat(Spine.rbPos_mFr_xyz);
Spine_rb_time = cell2mat(Spine.rbPosSysTime_mFr_xyz);

figure;
plot(LFoot_rb_time, LFoot_rb_xyz(:,ax),'r','LineWidth',1); hold on
% plot(RFoot_rb_time, RFoot_rb_xyz(:,ax),'g','LineWidth',1); 
% plot(Glasses_rb_time, Glasses_rb_xyz(:,ax),'b','LineWidth',1);
% plot(Spine_rb_time, Spine_rb_xyz(:,ax),'k','LineWidth',1);
hold off
title(['Rigid body, Phase space ' num2str(ax) ' axis data with time'])
legend('Left foot','Right foot','Glasses','Spine')
end