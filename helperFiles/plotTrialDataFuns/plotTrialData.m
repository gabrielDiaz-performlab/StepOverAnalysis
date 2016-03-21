% Draw trial figure!
%%
fprintf('\nTrial #%1.0f\n',trIdx)

startFr = bounceFrame_tr(trIdx)-40; %trialStartFr_tr(trIdx);

if( successfulCatch_tr(trIdx) )
    display('Ball caught')
    endFr = catchFr_tr(trIdx);
else
    endFr = passFrame_tr(trIdx)+5;
end
% if( ballCaught_tr(trIdx)
%     startFr = bounceFrame_tr(trIdx)-40; %trialStartFr_tr(trIdx);
%     endFr = passFr;
% else
%     startFr = bounceFrame_tr(trIdx)-40; %trialStartFr_tr(trIdx);
%     endFr = bounceFrame_tr(trIdx)+40;  %trialEndFr_tr(trIdx);
% end

plotFr = startFr : endFr;
plotID = movieID_fr(startFr:endFr);
plotBounce = find( plotFr  == bounceFrame_tr(trIdx) );

figure(100)
subplot(2,1,1);
cla
hold on
%fixIdList = movieID_fr(fixStartFr:fixEndFr);

axis( [plotID(1) plotID(end) -40 150])

% vel thresh
hline(vel_thresh,'y')

%%%%%%%%%%%%
% Gaze velocity

%plot(plotID,rawGazeVelDegsSec_fr(startFr:endFr),'Color','g','LineWidth',4);
plot(plotID,gazeVelDegsSec_fr(startFr:endFr),':','Color','k','LineWidth',4);

%%%%%%%%%%%%
% Predictive saccade
if( foundSacc_tr(trIdx) )
    % Saccade
    if( ~isempty(saccPeakFr) )
        if( ~isempty(saccStartFr_tr(trIdx)) && ~isempty(saccEndFr_tr(trIdx)) )
            plot( movieID_fr( saccStartFr_tr(trIdx):saccEndFr_tr(trIdx)), gazeVelDegsSec_fr(saccStartFr_tr(trIdx):saccEndFr_tr(trIdx)),'Color','r','LineWidth',12);
        end
    end
end

%%%%%%%%%%%%
% Plot Gaze2ball distance
%plot(plotID,10.*g2BallDegs_fr(startFr:endFr),'Color',[.5 0 0],'LineWidth',2);
hline(0)

if( foundPredFix_tr(trIdx) )
    
    fixIdList = movieID_fr(fixStartFr:fixEndFr);

      % Color fixation green
    l1 = plot(movieID_fr(fixStartFr:fixEndFr),gazeVelDegsSec_fr(fixStartFr:fixEndFr),'Color','g','LineWidth',12);
    
    % The minimum
    scatter( movieID_fr(fix2BallMinFr ), gazeVelDegsSec_fr(fix2BallMinFr ),150,'b','filled')
    scatter( movieID_fr(fix2BallMinFr ), fix2BallMinFr ,150,'b','filled')
    
end

%%
% 
% if( foundSaccAndFix_tr(trIdx) == 1)
%     
%     
%     %endFr = bounceFrame_tr(trIdx)+round((ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,2)/-ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,2)) / (1/60));
%     %startFr = -120 + endFr;
%     %hitRacquFr_tr(trIdx); %+40; % min( [ bounceFrame_tr(trIdx)+40 hitRacquFr_tr(trIdx)]+10 );
%     
%     plotID = movieID_fr(startFr:endFr);
%     fixIdList = movieID_fr(fixStartFr:fixEndFr);
% 
%     % Color fixation green
%     l1 = plot(movieID_fr(fixStartFr:fixEndFr),gazeVelDegsSec_fr(fixStartFr:fixEndFr),'Color','g','LineWidth',12);
%     
%     % The minimum
%     scatter( movieID_fr(fix2BallMinFr ), gazeVelDegsSec_fr(fix2BallMinFr ),150,'b','filled')
%     scatter( movieID_fr(fix2BallMinFr ), fix2BallMinFr ,150,'b','filled')
%     
%     % Saccade
%     if( ~isempty(saccPeakFr) )
%         if( ~isempty(saccStartFr_tr(trIdx)) && ~isempty(saccEndFr_tr(trIdx)) )
%             plot( movieID_fr( saccStartFr_tr(trIdx):saccEndFr_tr(trIdx)), gazeVelDegsSec_fr(saccStartFr_tr(trIdx):saccEndFr_tr(trIdx)),'Color','r','LineWidth',12);
%         end
%     end
%     
%     %stopAtXMeters = 1; % stop searching x meters before the ball reaches the room's X axis
%     %cutOffcatchupSearchAt = round(((ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,2)-stopAtXMeters ) / -ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,2))/(1/60));
%     %cutOffcatchupSearchAt = bounceFrame_tr(trIdx) + cutOffcatchupSearchAt  - 1;
%     
% else
%     display('  * No prediction')
%     
%     %endFr = bounceFrame_tr(trIdx)+round((ballPos_fr_xyz(bounceFrame_tr(trIdx)+1,2)/-ballVel_fr_xyz(bounceFrame_tr(trIdx)+1,2)) / (1/60));
%     %startFr = -120 + endFr;
%     plotID = movieID_fr((startFr):(endFr));
%     
%     %min( [ bounceFrame_tr(trIdx)+40 hitRacquFr_tr(trIdx)]+10 );
%     
% end




%plot(plotID,gazeVelDegsSecSaccRem_fr(startFr:endFr),':','Color','k','LineWidth',4);


%% Plot pursuit
if (foundPur_tr(trIdx) == 1)
    
    pursFrames = pursALLStartFr_idx(purIdx):pursALLEndFr_idx(purIdx);
    
    %%% Pursuit gain
    hline( purs_e2bChangeThresh_High*100,'c', 1.5,':')
    hline( purs_e2bChangeThresh_Low*100,'c', 1.5,':')
    vline(movieID_fr(frameCutoff_tr(trIdx)),'y',4 )
    ballPos_fr_xyz(frameCutoff_tr(trIdx),2)
    
    for i = 1:numel( posBouncePursuit_tr_ConOff{trIdx,1} )
        p2ID = movieID_fr( posBouncePursuit_tr_ConOff{trIdx,1}(i):posBouncePursuit_tr_ConOff{trIdx,2}(i));
        plot(p2ID,gazeVelDegsSecSaccRem_fr( posBouncePursuit_tr_ConOff{trIdx,1}(i):posBouncePursuit_tr_ConOff{trIdx,2}(i)),'Color',[0 .3 0],'LineWidth',9);
    end
    
    %%
    if( numCatchUpSacc_tr(trIdx) > 0 )
        
        for sIdx = 1:numCatchUpSacc_tr(trIdx)
            vline( movieID_fr(catchupPeakFr_sc(sIdx)),'m')
%             if( ~isnan(saccStartFr_sc(sIdx)))
%                 vline( movieID_fr(saccStartFr_sc(sIdx)),'g')
%                 vline( movieID_fr(saccEndFr_sc(sIdx)),'r')
%             end
        end
        
    end
    
    %%
else
    display('  * No pursuit')

end

%% Bounce frame
vline( movieID_fr(bounceFrame_tr(trIdx)),'g',4,'--')

% Figure properties
dcmObj = datacursormode(100);
set(dcmObj,'UpdateFcn',@dataTip_callback_racquetball)
datacursormode on

if ( strcmp(get(gcf,'WindowStyle'),'docked')==0)
    set(100,'Units','Normalized','Position',[-0.00297619047619048 0.214980544747082 0.683333333333333 0.692607003891051]);
end

ylimVec = ylim;
set(gca,'YTick',sort( [0:50:ylimVec(2) vel_thresh ]));
x = get(gca,'XTick');
set(gca,'XTickLabel',sprintf('%3.0f|',x))


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Legend for pursExclusionCode_fr
%0: distance violation (light red)
%1: pursuit (dark green)
%2: gain violation (dark red)
%3: fixation (light green)
%4: min duration violation (magenta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%
% if( ~isnan(gainWIndow_tr_onOff(trIdx,1)))
%     vline( movieID_fr(gainWIndow_tr_onOff(trIdx,1)),'c',4);
%     vline( movieID_fr(gainWIndow_tr_onOff(trIdx,2)),'c',4);
% end

%%
% plot(plotID,100*pursuitGain_fr(startFr:endFr),'c','LineWidth',2)

% pursColors = {[.5 0 0],[0 .3 0],'c',[0 1 0],'m'};
% 
% for i = 0:4
%     idx = find(pursExclusionCode_fr(startFr:endFr) == i);
%     scatter(plotID(idx),10*purs_degThresh*ones(1,numel(idx)),60,pursColors{i+1},'MarkerFaceColor',pursColors{i+1})
% end
% 
% hline(10*purs_degThresh,'g');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Accel based saccade detetction

subplot(2,1,2);
cla
hold on
axis( [plotID(1) plotID(end) -50 50])

accelWin = 80;

%temp1 = diff( gazeVelDegsSec_fr((saccPeakFr-accelWin):(saccPeakFr+accelWin)) );
temp2 = diff( convGazeVelDegsSec_fr((saccPeakFr-accelWin):(saccPeakFr+accelWin)) );

%figure(102)
hold on

%plot(movieID_fr((saccPeakFr-accelWin+1):(saccPeakFr+accelWin)),temp1,'Color','b','LineWidth',3);
plot(movieID_fr((saccPeakFr-accelWin+1):(saccPeakFr+accelWin)),temp2,'Color','m','LineWidth',3);

%plot(plotID,g2BallDegs_fr(startFr:endFr),'Color','k','LineWidth',2);

vline( movieID_fr(bounceFrame_tr(trIdx)),'g',4,'--')
vline(movieID_fr( saccPeakFr ),'m');

if( ~isempty(saccStartFr_tr(trIdx)) )
    vline( movieID_fr( saccStartFr_tr(trIdx)),'g' )
end
if( ~isempty(saccEndFr_tr(trIdx)) )
    vline( movieID_fr( saccEndFr_tr(trIdx)),'r' )
end

ylimVec = ylim;
set(gca,'YTick',0:20:ylimVec(2));
x = get(gca,'XTick');
set(gca,'XTickLabel',sprintf('%3.0f|',x))

hline(0)

set(gcf,'WindowStyle','docked');

if( ~strcmp(get(gcf,'WindowStyle'),'docked') )
    set(100,'Units','Normalized','Position',[0.0196428571428571 0.0321011673151751 0.661309523809524 0.875486381322957]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  SubpLot gaze locations

if(foundPredFix_tr(trIdx) == 1 && showFIxDist ==1 )
    
    figure(110)
    cla
    hold on
    set(gcf,'Renderer','zbuffer')
    title('o=Min.  sq=bounce')
    set(110,'Units','Normalized','Position',[0.661979166666667 0.785446009389671 0.205208333333333 0.169953051643192]);
    
    axis([-12 12 -18 2]);
    axis square
    
    xlimVal = xlim;
    set(gca,'xtick',xlimVal(1):3:xlimVal(2));
    yLimVal = ylim;
    set(gca,'ytick',yLimVal(1):3:yLimVal(2));
    grid on
    
    caxis([.2 .8])
    
    vline(0,'k',2)
    hline(0,'k',2)
    
    curcolmap = colormap;
    cspec = [.8 .45 .1];
    
    scatter( fix2BallMinTheta_tr(trIdx), fix2BallMinPhi_tr(trIdx),80,cspec(2),'o','Filled','MarkerEdgeColor','k');
    scatter( fix2BounceTheta_tr(trIdx), fix2BouncePhi_tr(trIdx),80,cspec(2),'s','Filled','MarkerEdgeColor','k');
    
end


%%  HAND POSITION AND VELOCITY

figure(10)
clf

handVelTemp = sqrt( sum(racqVel_fr_xyz(plotFr,:).^2,2) );
handPlanarVelTemp = sqrt( sum(racqVel_fr_xyz(plotFr,[1 2]).^2,2) );

filter = fspecial('gaussian',[5 1], 2);  % gaussian kernel where s= size of contour
handVelTempFilt  = conv(handVelTemp ,filter,'same');
handPlanarVelTempFilt   = conv(handPlanarVelTemp   ,filter,'same');

subplot(2,1,1)
cla
hold on
xlabel('time')
ylabel('hand vel')
plot(plotID,handPlanarVelTempFilt,'Color','k','LineWidth',2);
vline( movieID_fr(bounceFrame_tr(trIdx)),'g',2)
vline(movieID_fr( passFrame_tr(trIdx) ) );

subplot(2,1,2)
cla
hold on
ylim([-1 1])
xlabel('time')
ylabel('hand vel')
plot(plotID,[1 diff(handPlanarVelTempFilt)'],'Color','k','LineWidth',2);
vline( movieID_fr(bounceFrame_tr(trIdx)),'g',2)
vline(movieID_fr( passFrame_tr(trIdx) ) );
hline(0,'r')

%%
% rotAmount = 3;
% keepOnRotating = true;
% 
% while( keepOnRotating )
% 
%     
%     camorbit(rotAmount,0)
%     drawnow
%     pause(.05)
%     
% end

if( plot3dTraj )
    plotTrial3DTraj
end

%%

set(10,'Units','Normalized','Position',[0.37 -0.071 0.58 0.37]);


    
