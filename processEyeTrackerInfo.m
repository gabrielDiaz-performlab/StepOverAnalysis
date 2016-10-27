function sessionData = processEyeTrackerInfo(sessionData, trIdx, plotOn)

ETG_SamplingRate = 60;
ETG_FrameTime = 1/ETG_SamplingRate;

%% Generate Cyclopean GV by vector addition
inHead_L_GV = sessionData.processedData_tr(trIdx).ETG.L_GVEC;
inHead_R_GV = sessionData.processedData_tr(trIdx).ETG.R_GVEC;

% Normalize the GV to a unit vector
cycEIH_fr_vec = inHead_L_GV + inHead_R_GV; cycEIH_fr_vec = normr(cycEIH_fr_vec);

%% Bring it into MATlab coordinates

cycEIH_fr_vec(:,[1 2 3]) = cycEIH_fr_vec(:,[1 3 2]);
cycEIH_fr_vec(:,1) = -cycEIH_fr_vec(:,1);

sessionData.processedData_tr(trIdx).ETG.cycEIH_fr_vec = cycEIH_fr_vec;
sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec  = quatrotate(sessionData.processedData_tr(trIdx).glasses.quat_fr_wxyz,cycEIH_fr_vec);

% %% Find Fixations
% 
% timeStampMS_fr = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
% GIW = sessionData.processedData_tr(trIdx).ETG.cycGIW_fr_vec;
% 
% SamplingRate = 1./mean(diff(timeStampMS_fr));
% 
% theta_X = atand(GIW(:,1)./GIW(:,2));
% theta_Y = atand(GIW(:,3)./GIW(:,2));
% 
% % Remove NaNs by replacing it to the closest non NaN value
% nanlocX = find(isnan(theta_X)); nonnanlocX = find(~isnan(theta_X));
% nanlocY = find(isnan(theta_Y)); nonnanlocY = find(~isnan(theta_Y));
% 
% for i = 1:length(nanlocX)
%    [~,loc] = min(nonnanlocX - nanlocX(i)); 
%    theta_X(nanlocX(i)) = theta_X(nonnanlocX(loc));
% end
% 
% for i = 1:length(nanlocY)
%    [~,loc] = min(nonnanlocY - nanlocY(i)); 
%    theta_Y(nanlocY(i)) = theta_Y(nonnanlocY(loc));
% end
% 
% % Find Angular velocity and Absolute Displacement
% vel_X = [0; abs(diff(theta_X))./diff(timeStampMS_fr)];
% vel_Y = [0; abs(diff(theta_Y))./diff(timeStampMS_fr)];
% 
% % T = ClusterFix({[theta_X'; theta_Y']},1/SamplingRate);
% 
% saccades_T = T{1}.saccadetimes;   
% 
% saccades_loc = zeros(length(theta_X),1);
% 
% for i = 1:size(saccades_T,2)
%     if timeStampMS_fr(saccades_T(2,i)) - timeStampMS_fr(saccades_T(1,i)) > 2*ETG_FrameTime
%         saccades_loc(saccades_T(1,i):saccades_T(2,i)) = 1; 
%     else
%         saccades_T(:,i) = 0;
%     end
% end
% 
% saccades_T(:,saccades_T(1,:) == 0) = [];
% %% Plot data
% 
% sx = max(theta_X - min(theta_X));
% sy = max(theta_Y - min(theta_Y));
% 
% if plotOn
%    figure;
%    subplot(1,2,1);hold on;plot(timeStampMS_fr, theta_X - min(theta_X));plot(timeStampMS_fr, sx*saccades_loc); hold off;title('X DVA')
%    subplot(1,2,2);hold on;plot(timeStampMS_fr, theta_Y - min(theta_Y));plot(timeStampMS_fr, sy*saccades_loc); hold off;title('Y DVA')
%    suptitle('Saccade locations'); xlabel('Time (S)'); ylabel('DVA') 
% 
%     figure;hold on;
%     plot(timeStampMS_fr, (theta_X - min(theta_X))/sx); plot(timeStampMS_fr, vel_X/max(vel_X));plot(timeStampMS_fr, saccades_loc); hold off;
%     
%     figure;hold on;
%     plot(timeStampMS_fr, (theta_Y - min(theta_Y))/sy); plot(timeStampMS_fr, vel_Y/max(vel_Y));plot(timeStampMS_fr, saccades_loc); hold off;
% end
% 
% %% Previous saccade finder
% % Beta_fr = acosd(dot(GIW(1:end-1,:),GIW(2:end,:),2)); 
% 
% % Beta_fr(isnan(Beta_fr)) = 0;
% % 
% % % angDisp_fr = cumsum([0; Beta_fr]);
% % % angVel_fr = [0; Beta_fr./diff(timeStampMS_fr)];
% % 
% % % angVel_fr(isnan(angVel_fr)) = 0;
% % 
% % velThresh = 300; % deg/sec
% % slopeThresh = 0.5; % Slope of displacement vs time
% % 
% % % Not using the old Saccade finder
% % % loc = saccade_finder(angVel_fr, angDisp_fr, timeStampMS_fr, 1);
% 
% %  Plot figures
% % if plotOn == 1
% %     figure;
% %     plot(timeStampMS_fr, angVel_fr);
% %     xlabel('Time (s)'); ylabel('Angular Velocity (deg/sec)')
% %     title('Angular eye velocity in deg/sec')
% %     
% %     figure;
% %     plot(timeStampMS_fr, angVel_fr/max(angVel_fr));hold on;
% %     plot(timeStampMS_fr, angDisp_fr/max(angDisp_fr)); hold off;
% %     xlabel('Time (s)'); ylabel('Plots')
% %     legend('Normalized Angular Velocity','Normalized Angular Displacement')
% % end
% 
% % angVelFreq_fr = fftshift(fft(angVel_fr));
% % Fs = 1/mean(diff(timeStampMS_fr)); % Sampling rate
% % N = length(timeStampMS_fr);
% % dF = Fs/N;
% % angFreq = -Fs/2:dF:Fs/2 - dF;
% % 
% % figure;
% % plot(angFreq, abs(angVelFreq_fr))
% % 
% % clump_space_thresh = 2;
% % clump_t_thresh = 50;
% % t_thresh = 20;
% % vel_thresh = 40;
% % 
% % [fix, fixAllFr_fixIdx_onOff] = fix_finder_vt( ... 
% %     timeStampMS_fr, ...
% %     [giwFiltDegsX_fr, giwFiltDegsY_fr],...
% %     gazeVelDegsSec_fr, ...
% %     clump_space_thresh, ...
% %     clump_t_thresh, ...
% %     t_thresh, ...
% %     vel_thresh);
% % 
% sessionData.processedData_tr(trIdx).ETG.Saccade_loc = 1;
% sessionData.processedData_tr(trIdx).ETG.NumOfSaccades = length(saccades_T);
% sessionData.processedData_tr(trIdx).ETG.Saccade_T = saccades_T;
end