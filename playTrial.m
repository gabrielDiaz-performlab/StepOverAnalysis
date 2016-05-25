function [] = playTrial(ETG_VidObj, sessionData, trIdx, writeToFile)

% keyboard

eventFlag = sessionData.processedData_tr(trIdx).info.eventFlag_fr;

%% ETG data
trStart = sessionData.processedData_tr(trIdx).ETG.tr_Start;
trStop = sessionData.processedData_tr(trIdx).ETG.tr_Stop;
B_POR = sessionData.processedData_tr(trIdx).ETG.B_POR;
ETG_ts = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
angSeperation = sessionData.processedData_tr(trIdx).ETG.angSeparation;

%% Marker data 
glasses_ts = sessionData.processedData_tr(trIdx).glasses.mkrSysTime_mIdx_Cfr;
glasses = sessionData.processedData_tr(trIdx).glasses.mkrPos_mIdx_Cfr_xyz;

%% Video object
vid = read(ETG_VidObj,round(ETG_VidObj.FrameRate*[trStart - 1.325 trStop - 1.325]));
no_of_frames = size(vid,4);
% no_of_samples = length(ETG_ts);
% 
% if writeToFile == 1
%     v = VideoWriter(['C:\Users\Rakshit\Documents\MATLAB\StepOverAnalysis\figures\Trial video\Trial_no ' num2str(trIdx) '.avi']);
%     v.FrameRate = 45;
%     open(v)
% end
% 
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(2,2,1);title('ETG Video Feed')
% Im1 = imshow(zeros(ETG_VidObj.Height, ETG_VidObj.Width, 3));hold on;
% P1 = plot(0,0,'rx','LineWidth',3);hold off
% subplot(2,2,2);title('Angular seperation')
% plot(ETG_ts, angSeperation); hold on; 
% L1 = plot([0 0],[0 max(angSeperation)],'LineWidth',3); hold off; axis([0 6.5 0 max(angSeperation)])
% xlabel('Time (S)'); ylabel('Angular seperation (Degrees)');
% subplot(2,2,3); title('Glasses'); hold on
% for j = length(glasses)
%     plot(glasses_ts{j}, glasses{j}(:,3), 'LineWidth', 3)
% end
% L2 = plot([0 0],[0 2],'LineWidth',3); xlabel('Time (S)'); ylabel('Height (M)'); hold off; axis([0 6.5 0 2])
% subplot(2,2,4); title('Feet. R -> Right. L -> Blue'); hold on
% plot(ETG_ts, sessionData.processedData_tr(trIdx).lFoot.rbPos_mFr_xyz(:,3),'b')
% plot(ETG_ts, sessionData.processedData_tr(trIdx).rFoot.rbPos_mFr_xyz(:,3),'r'); 
% L3 = plot([0 0],[0 0.6], 'LineWidth', 3); xlabel('Time (S)'); ylabel('Height (M)'); hold off; axis([0 6.5 0 0.6])
% 
% % set(fig,'KeyPressFcn',@pause_exec);
% % 
% % function [] = pause_exec(fig_obj)
% %     K = get(fig_obj, 'CurrentKey');
% %     if K == 'p'
% %         pause
% %     end
% % end
% 
% for i = 1:no_of_samples
%     vidFr = round(i*no_of_frames/no_of_samples);
%     if vidFr == 0
%         vidFr = 1;     
%     end
%     set(Im1, 'Cdata', vid(:,:,:,vidFr));
%     set(P1, 'xdata', B_POR(i,1), 'ydata', B_POR(i,2))    
%     set(L1, 'xdata', [ETG_ts(i) ETG_ts(i)])
%     set(L2, 'xdata', [ETG_ts(i) ETG_ts(i)])
%     set(L3, 'xdata', [ETG_ts(i) ETG_ts(i)])
%     
%     if writeToFile == 1
%         writeVideo(v, getframe(fig));
%     end
%     drawnow
% %     pause(0.05)
% end
% if writeToFile == 1
%     close(v)
% end


%% Play raw data

eventFlag = sessionData.rawData_tr(trIdx).info.eventFlag_fr;
sysTime = sessionData.rawData_tr(trIdx).info.sysTime_fr;
sysTime = sysTime - sysTime(1);
no_of_samples = length(sysTime);

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,2,1);title('ETG Video Feed')
Im1 = imshow(zeros(ETG_VidObj.Height, ETG_VidObj.Width, 3));
subplot(1,2,2);title('Raw event data')
plot(sysTime, eventFlag); hold on; 
L1 = plot([0 0],[0 max(eventFlag)],'LineWidth',3); hold off; axis([0 6.5 0 max(eventFlag)])
xlabel('Time (S)'); ylabel('Raw event Flag');
for i = 1:no_of_samples
    vidFr = round(i*no_of_frames/no_of_samples);
    if vidFr == 0
        vidFr = 1;     
    end
    set(Im1, 'Cdata', vid(:,:,:,vidFr));
    set(L1, 'xdata', [sysTime(i) sysTime(i)])
    drawnow;
    pause(0.1)
end
end