function [] = DisplaySessionData(sessionData, ax, i, str, show_mkr)
%% 11/20/2015 - Rakshit Kothari
% This function is used to display at any arbitary point in the code. 

%%  Assign data
LFoot = sessionData.(str)(i).lFoot;
RFoot = sessionData.(str)(i).rFoot;
Glasses = sessionData.(str)(i).glasses;
Spine = sessionData.(str)(i).spine;

%% Plot Rigid body phase space data
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

%% Plot Vizard data
fr_time = sessionData.(str)(i).info.sysTime_fr; 
LFoot_fr_xyz = LFoot.pos_fr_xyz;
RFoot_fr_xyz = RFoot.pos_fr_xyz;
Glasses_fr_xyz = Glasses.pos_fr_xyz;

figure;
plot(fr_time, LFoot_fr_xyz(:,ax), 'r','LineWidth',1); hold on 
plot(fr_time, RFoot_fr_xyz(:,ax), 'g','LineWidth',1);
plot(fr_time, Glasses_fr_xyz(:,ax), 'b','LineWidth',1);
xlabel('Time [S]'); ylabel('Distance [M]'); 
title(['Vizard data ' num2str(ax) ' axis data with time'])
legend('Left foot','Right foot','Glasses')

figure;
subplot(2,2,1); 
plot(LFoot_rb_time, LFoot_rb_xyz(:,ax),'r','LineWidth',1); hold on;
plot(fr_time, LFoot_fr_xyz(:,ax), '--r','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Left foot'); legend('Rigid body', 'Vizard')
subplot(2,2,2);
plot(RFoot_rb_time, RFoot_rb_xyz(:,ax),'g','LineWidth',1); hold on;
plot(fr_time, RFoot_fr_xyz(:,ax), '--g','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Right foot'); legend('Rigid body', 'Vizard')
subplot(2,2,3)
plot(Glasses_rb_time, Glasses_rb_xyz(:,ax),'b','LineWidth',1); hold on;
plot(fr_time, Glasses_fr_xyz(:,ax), '--b','LineWidth',1); hold off;
xlabel('Time [S]'); ylabel('Distance [M]'); title('Glasses'); legend('Rigid body', 'Vizard')
subplot(2,2,4)
plot(Spine_rb_time, Spine_rb_xyz(:,ax),'k','LineWidth',1);
xlabel('Time [S]'); ylabel('Distance [M]'); title('Spine'); legend('Rigid body')
suptitle('Comparing Vizard and Rigid body data')

%% Plot Marker Data
if show_mkr == 1
    color_List = linspecer(length(LFoot.mkrPos_mIdx_Cfr_xyz));
    figure; hold on;
    for j = 1:length(LFoot.mkrPos_mIdx_Cfr_xyz)
        plot(LFoot.mkrSysTime_mIdx_Cfr{j}, LFoot.mkrPos_mIdx_Cfr_xyz{j}(:,ax), 'Color', color_List(j,:), 'LineWidth', 1) 
    end
    hold off;
    title('Left foot marker data')
    
    color_List = linspecer(length(RFoot.mkrPos_mIdx_Cfr_xyz));
    figure; hold on;
    for j = 1:length(RFoot.mkrPos_mIdx_Cfr_xyz)
        plot(RFoot.mkrSysTime_mIdx_Cfr{j}, RFoot.mkrPos_mIdx_Cfr_xyz{j}(:,ax), 'Color', color_List(j,:), 'LineWidth', 1) 
    end
    hold off;
    title('Right foot marker data')
    
    color_List = linspecer(length(Glasses.mkrPos_mIdx_Cfr_xyz));
    figure; hold on;
    for j = 1:length(Glasses.mkrPos_mIdx_Cfr_xyz)
        plot(Glasses.mkrSysTime_mIdx_Cfr{j}, Glasses.mkrPos_mIdx_Cfr_xyz{j}(:,ax), 'Color', color_List(j,:), 'LineWidth', 1) 
    end
    hold off;
    title('Glasses marker data')
    
    color_List = linspecer(length(Spine.mkrPos_mIdx_Cfr_xyz));
    figure; hold on;
    for j = 1:length(Spine.mkrPos_mIdx_Cfr_xyz)
        plot(Spine.mkrSysTime_mIdx_Cfr{j}, Spine.mkrPos_mIdx_Cfr_xyz{j}(:,ax), 'Color', color_List(j,:), 'LineWidth', 1) 
    end
    hold off;
    title('Spine marker data')
end
%% Compare different time stamps

colorMat = linspecer(13);

figure;
hold on
% Left foot
plot(sessionData.(str)(i).lFoot.rbPosSysTime_mFr_xyz,'Color',colorMat(1,:))
% plot(sessionData.(str)(i).lFoot.rbQuatSysTime_mFr,'Color',colorMat(2,:))
plot(cell2mat(sessionData.(str)(i).lFoot.mkrSysTime_mIdx_Cfr'),'Color',colorMat(3,:))
% Right foot
% plot(sessionData.(str)(i).rFoot.rbPosSysTime_mFr_xyz,'--','Color',colorMat(4,:))
% plot(sessionData.(str)(i).rFoot.rbQuatSysTime_mFr,'Color',colorMat(5,:))
% plot(cell2mat(sessionData.(str)(i).rFoot.mkrSysTime_mIdx_Cfr'),'Color',colorMat(6,:),'--')
% Glasses
plot(sessionData.(str)(i).glasses.rbPosSysTime_mFr_xyz,'-.','Color',colorMat(7,:))
plot(sessionData.(str)(i).glasses.rbQuatSysTime_mFr,'-.','Color',colorMat(8,:))
plot(cell2mat(sessionData.(str)(i).glasses.mkrSysTime_mIdx_Cfr'),'-.','Color',colorMat(9,:))
% Spine
% plot(sessionData.(str)(i).spine.rbPosSysTime_mFr_xyz,':','Color',colorMat(10,:))
% plot(sessionData.(str)(i).spine.rbQuatSysTime_mFr,'Color',colorMat(11,:))
% plot(cell2mat(sessionData.(str)(i).spine.mkrSysTime_mIdx_Cfr'),':','Color',colorMat(12,:))
% Vizard
plot(sessionData.(str)(i).info.sysTime_fr,':','Color',colorMat(13,:))
hold off
drawnow

keyboard
end