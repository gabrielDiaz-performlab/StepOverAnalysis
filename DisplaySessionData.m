function [] = DisplaySessionData(sessionData, ax, i)

LFoot = sessionData.rawData_tr(i).lFoot;
RFoot = sessionData.rawData_tr(i).rFoot;
Glasses = sessionData.rawData_tr(i).glasses;
Spine = sessionData.rawData_tr(i).spine;

%Plot Rigid body phase space data
LFoot_rb_xyz = LFoot.rbPos_mFr_xyz;
LFoot_rb_time = LFoot.rbPosSysTime_mFr_xyz;

RFoot_rb_xyz = RFoot.rbPos_mFr_xyz;
RFoot_rb_time = RFoot.rbPosSysTime_mFr_xyz;

Glasses_rb_xyz = Glasses.rbPos_mFr_xyz;
Glasses_rb_time = Glasses.rbPosSysTime_mFr_xyz;

Spine_rb_xyz = Spine.rbPos_mFr_xyz;
Spine_rb_time = Spine.rbPosSysTime_mFr_xyz;

figure;
plot(LFoot_rb_time, LFoot_rb_xyz(:,ax),'r','LineWidth',1); hold on
plot(RFoot_rb_time, RFoot_rb_xyz(:,ax),'g','LineWidth',1); 
plot(Glasses_rb_time, Glasses_rb_xyz(:,ax),'b','LineWidth',1);
plot(Spine_rb_time, Spine_rb_xyz(:,ax),'k','LineWidth',1); hold off
xlabel('Time [S]'); ylabel('Distance [M]');
title(['Rigid body, Phase space ' num2str(ax) ' axis data with time'])
legend('Left foot','Right foot','Glasses','Spine')

%Plot Vizard data
fr_time = sessionData.rawData_tr(i).info.sysTime_fr; 
LFoot_fr_xyz = LFoot.pos_fr_xyz;
RFoot_fr_xyz = RFoot.pos_fr_xyz;
Glasses_fr_xyz = Glasses.pos_fr_xyz;

figure;
plot(fr_time, LFoot_fr_xyz(:,ax), 'r','LineWidth',1); hold on 
plot(fr_time, RFoot_fr_xyz(:,ax), 'g','LineWidth',1);
plot(fr_time, Glasses_fr_xyz(:,ax), 'b','LineWidth',1);
xlabel('Time [S]'); ylabel('Distance [M]'); 
title(['Vizard data ' num2str(ax) ' axis data with time'])
legend('Left foot','Right foot','Glasses','Spine')

figure;
subplot(2,2,1); 
plot(LFoot_rb_time, LFoot_rb_xyz(:,ax),'r','LineWidth',1); hold on;
plot(fr_time, LFoot_fr_xyz(:,ax), '--r','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Left foot')
subplot(2,2,2);
plot(RFoot_rb_time, RFoot_rb_xyz(:,ax),'g','LineWidth',1); hold on;
plot(fr_time, RFoot_fr_xyz(:,ax), '--g','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Right foot')
subplot(2,2,3)
plot(Glasses_rb_time, Glasses_rb_xyz(:,ax),'b','LineWidth',1); hold on;
plot(fr_time, Glasses_fr_xyz(:,ax), '--b','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Glasses')
subplot(2,2,4)
plot(Spine_rb_time, Spine_rb_xyz(:,ax),'k','LineWidth',1); %hold on;
% plot(fr_time, Spine_fr_xyz(:,ax), '--k','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Spine')
suptitle('Comparing Vizard and Rigid body data')

end