%%  HAND POSITION AND VELOCITY

startFr = bounceFrame_tr(trIdx)-45; %trialStartFr_tr(trIdx);
endFr = catchFrame_tr(trIdx)%bounceFrame_tr(trIdx)+30;

plotFr = startFr :endFr ;
figTime = 1000 * (sceneTime_fr(plotFr) -sceneTime_fr( bounceFrame_tr(trIdx)));

figure(10)
clf


subplot(2,1,1)
hold on
xlabel('time (ms)')
ylabel('gaze velocity')

xlim([figTime(1) figTime(end)])
ylim([0 300])

plot(figTime,gazeVelDegsSec_fr(plotFr),'-','Color','k','LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predictive saccade
if( foundSacc_tr(trIdx) )
    % Saccade
    if( ~isempty(saccPeakFr) )
        if( ~isempty(saccStartFr_tr(trIdx)) && ~isempty(saccEndFr_tr(trIdx)) )
            
            % saccTime = sceneTime_fr( saccStartFr_tr(trIdx):saccEndFr_tr(trIdx));
            saccFr = saccStartFr_tr(trIdx):saccEndFr_tr(trIdx);
            saccTime = 1000 * (sceneTime_fr(saccFr ) - sceneTime_fr(bounceFrame_tr(trIdx)));
            plot( saccTime , gazeVelDegsSec_fr(saccFr),'Color','r','LineWidth',5);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predictive fixation

if( foundPredFix_tr(trIdx) )
    
    fixFr = fixStartFr:fixEndFr;
    fixTime = 1000 * (sceneTime_fr(fixFr ) - sceneTime_fr(bounceFrame_tr(trIdx)));
    
    % Color fixation green
    l1 = plot(fixTime,gazeVelDegsSec_fr(fixFr),'Color','g','LineWidth',12);
    
%     fixMinFr
%     % The minimum
%     scatter( sceneTime_fr(fix2BallMinFr ), gazeVelDegsSec_fr(fix2BallMinFr ),150,'b','filled')
%     scatter( sceneTime_fr(fix2BallMinFr ), fix2BallMinFr ,150,'b','filled')
    
else
    print '** No pred fix'
end


%% Bounce frame

%vline( sceneTime_fr(bounceFrame_tr(trIdx)),'g',4,'--')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
cla
hold on
xlabel('time')
ylabel('hand speed')
xlim([figTime(1) figTime(end)])

plot( figTime ,handVelTempFilt_fr(plotFr),'Color','b','LineWidth',2);


if( foundPredHandAdj_tr(trIdx) )
    
    
    %adjTime = (adjStartS2B_tr(trIdx):adjEndS2B_tr(trIdx))*1000;
    
    adjFr = adjStartFr_tr(trIdx):adjEndFr_tr(trIdx);
    adjTime = 1000 * (sceneTime_fr(adjFr) - sceneTime_fr(bounceFrame_tr(trIdx)));
    
     %handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),1) : handAllFr_idx_onOff( predHandStillIdx_tr(trIdx),2);
    plot( adjTime  ,handVelTempFilt_fr(adjFr  ),'Color','r','LineWidth',5);
    
end

vline( 0 ,'g',2)
vline( sceneTime_fr(passFrame_tr(trIdx)) );
predThreshTime = sceneTime_fr( bounceFrame_tr(trIdx)) + (t_threshAdjMSAfterBounce/1000) ;
vline( predThreshTime,[.3 .3 .3],1.5,':')

%%
set(10,'Units','Normalized','Position',[0.057 0.18 0.71 0.76]);


%plot2svg('speedOverTime.svg')



