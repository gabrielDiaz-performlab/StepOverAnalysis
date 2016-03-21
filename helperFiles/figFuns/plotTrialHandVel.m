%%  HAND POSITION AND VELOCITY
% 
% 
% hand_VelThresh = 10; %racquetSize(2) * 2;%
% hand_DurThresh = 50;
% hand_clump_t_thresh = 100;
% predictiveHand_t_thresh = 100;
% 
% %%
% trIdx = 13
% 
% fprintf('\nTrial #%1.0f\n',trIdx)

startFr = bounceFrame_tr(trIdx)-45; %trialStartFr_tr(trIdx);
endFr = bounceFrame_tr(trIdx)+30;
plotFr = startFr :endFr ;
startTime = sceneTime_fr(startFr);
endTime = sceneTime_fr(endFr );

% plTime = sceneTime_fr( startFr:endFr);
% 
% 
% %%
% clear handVelTemp_fr_xyz
% 
% handVelTemp_fr_xyz(:,1) = diff( rballDataFilter(racqPos_fr_xyz(:,1)) ./ sceneDur_fr');
% handVelTemp_fr_xyz(:,2) = diff( rballDataFilter(racqPos_fr_xyz(:,2)) ./ sceneDur_fr');
% handVelTemp_fr_xyz(:,3) = diff( rballDataFilter(racqPos_fr_xyz(:,3)) ./ sceneDur_fr');
% 
% handVelTemp_fr = sqrt( sum(handVelTemp_fr_xyz .^2 ,2) );
% 
% filter = fspecial('gaussian',[5 1], 2);  % gaussian kernel where s= size of contour
% handVelTempFilt_fr  = conv(handVelTemp_fr ,filter,'same');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Find period of hand stillness
% 
% handVelCode_fr = zeros(1,size(handVelTempFilt_fr,1));
% handVelCode_fr(find( handVelTempFilt_fr < hand_VelThresh )) = 1; % 1 is below threshold
% 
% %%% Clump pursuits within clump_t_thresh of one another
% lastStill = find( handVelCode_fr== 1,1,'first');
% 
% for idx = (lastPur+1):numel(handVelCode_fr)
% 
%     if( handVelCode_fr(idx) == 1)       
%         if( (sceneTime_fr(idx) - sceneTime_fr(lastPur)) <= (purs_clump_t_thresh/1000) )
%             handVelCode_fr(lastPur:idx) = 1;
%         end
%         
%         lastPur = idx;
%         
%     end
% end
% 
% %% Find contiguous runs of 1's (below thresh)
% 
% handAllFr_idx_onOff = zeros(numel(handVelCode_fr),1);
% handAllFr_idx_onOff( handVelCode_fr  ~= 1 ) = 0;
% handAllFr_idx_onOff( handVelCode_fr == 1 ) = 1;
%     
% %%% Pursuit must last for purs_durThresh
% 
% handAllFr_idx_onOff = contiguous(handAllFr_idx_onOff,1); % This converts handAllFr_idx_onOff into the format handAllFr_idx_onOff(:,1) = start frames, and (:,2) = stop frames
% handAllFr_idx_onOff = handAllFr_idx_onOff{2};
% 
% handBelowDurThresIdx = find( 1000*(sceneTime_fr(handAllFr_idx_onOff(:,2)) - sceneTime_fr(handAllFr_idx_onOff(:,1))) < hand_DurThresh );
% 
% % for xx= 1:numel(pursBelowDurThresIdx )
% %     handVelCode_fr( handAllFr_idx_onOff(handBelowDurThresIdx(xx),1):handAllFr_idx_onOff(handBelowDurThresIdx(xx),2)) = 4;
% % end
% 
% handAllFr_idx_onOff(handBelowDurThresIdx,:)=[];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Look for still period of the hand that is predictive
% 
% timeOfBounce = sceneTime_fr( bounceFrame_tr(trIdx) );
% predictiveCutoff = timeOfBounce + (predictiveHand_t_thresh/1000);
% 
% % Find last hand-still to start before the cutoff
% predictveHandIdx = find( sceneTime_fr(handAllFr_idx_onOff(:,1)) <= predictiveCutoff,1,'last');
% 
% % Did the hand-still end after the bounce, or just before the bounce?
% predictiveCutoff = timeOfBounce-(predictiveHand_t_thresh/1000);
% timeThatHandStillEnds = sceneTime_fr(handAllFr_idx_onOff(predictveHandIdx,2));
% 
% if(  timeThatHandStillEnds   >= predictiveCutoff )
%     
%     display 'Found hand still'
%     foundPredHandStill_tr(trIdx) = 1;
%     predHandStillIdx_tr(trIdx) = predictveHandIdx;
%     
% else
%     display 'Hand does not end after bounce'
%     sceneTime_fr(handAllFr_idx_onOff(predictveHandIdx,:))
%     sceneTime_fr(bounceFrame_tr(trIdx))
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

figure(10)
clf

subplot(2,1,1)
cla
hold on
xlabel('time')
ylabel('hand vel')

plot( sceneTime_fr(plotFr) ,handVelTempFilt_fr(plotFr),'Color','b','LineWidth',2);


if( foundPredHandAdj_tr(trIdx) )
    
    handAdjFr = adjStartFr_tr(trIdx):adjEndFr_tr(trIdx);
     %handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),1) : handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),2);
    plot( sceneTime_fr(handAdjFr ) ,handVelTempFilt_fr(handAdjFr ),'Color','r','LineWidth',3);
    
end

% 
% if( foundPredHandStill_tr(trIdx) )
%     
%     handStillFr = handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),1) : handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),2);
%     plot( sceneTime_fr(handStillFr) ,handVelTempFilt_fr(handStillFr),'Color','g','LineWidth',3);
%     
% end

% handFrTrial_idx = intersect( find( handAllFr_idx_onOff(:,1) > trialStartFr_tr(trIdx)) ,find( handAllFr_idx_onOff (:,2)< trialEndFr_tr(trIdx)) );
% 
% for idx = 1:size(handFrTrial_idx,1)
%     
%     handStillFr = (handAllFr_idx_onOff(handFrTrial_idx(idx),1):handAllFr_idx_onOff(handFrTrial_idx(idx),2));
%     plot( sceneTime_fr(handStillFr) ,handVelTempFilt_fr(handStillFr),'Color','g','LineWidth',3);
%     % handAllFr_idx_onOff
% end

vline( sceneTime_fr(bounceFrame_tr(trIdx)),'g',2)
vline( sceneTime_fr(passFrame_tr(trIdx)) );

predThreshTime = sceneTime_fr( bounceFrame_tr(trIdx)) + (t_threshAdjMSAfterBounce/1000) ;
vline( predThreshTime,[.3 .3 .3],1.5,':')

% subplot(2,1,2)
% cla
% hold on
% ylim([-1 1])
% xlabel('time')
% ylabel('eye vel')
% %plot(sceneTime_fr(plotFr),[1 diff(handPlanarVelTempFilt)'],'Color','k','LineWidth',2);
% plot(sceneTime_fr(plotFr),handVelTempFilt_fr(plotFr),'Color','k','LineWidth',2);
% vline( sceneTime_fr(bounceFrame_tr(trIdx)),'g',2)
% vline( sceneTime_fr(passFrame_tr(trIdx)) );
% hline(0,'r')

keyboard
