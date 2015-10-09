
set(0, 'DefaultAxesFontName', 'Roboto')
set(0, 'DefaultAxesFontSize', 16)

figSaveDir = ['Figures/' sessionDataString '/']
[junk junk ] = mkdir(figSaveDir)

ballC1 = [197 19 0]./250;
ballC2 = [0 14 120]./250;

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Gaze elevation during fixation
% 
% [avgFix2BouncePhi_el_bl stdFix2BouncePhi_el_bl fix2BouncePhi_Cel_bl_rep] = orgBy_El_Bl_Rep(dataFileString,fix2BouncePhi_tr,0);
% [avgGazePitchDuringFix_el_bl stdGazePitchDuringFix_el_bl gazePitchDuringFix_Cel_bl_rep] = orgBy_El_Bl_Rep(dataFileString,gazePitchDuringFix_tr,0);
% 
% figure(405)
% clf
% hold on
% axis([.75 numBlocks+.25 -35 -10])
% xlabel('Block')
% ylabel({'Gaze elevation during fixation' 'during fix (degs)'})
% set(gca,'XTick',1:numBlocks);
% 
% 
% errorbar( (1:numBlocks)-.05, avgGazePitchDuringFix_el_bl(1,:), stdGazePitchDuringFix_el_bl(1,:),'-o','Color',ballC1)
% errorbar( (1:numBlocks)+.05, avgGazePitchDuringFix_el_bl(2,:), stdGazePitchDuringFix_el_bl(2,:),'-o','Color',ballC2)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Average time of the minimum

[avgFixMinS2B_el_bl stdFixMinS2B_el_bl fixMinS2B_Cel_bl_rep] = orgBy_El_Bl_Rep(dataFileString,1000*fixMinS2B_tr,2.5);

figure(100)
clf
hold on    
xlabel('Block')
ylabel({'Time of the min (ms)'})
axis([.75 numBlocks+.25 -200 300])
set(gca,'XTick',1:numBlocks);
%set(gca,'YTick',-2:.5:2);

errorbar( (1:numBlocks)-.05, avgFixMinS2B_el_bl(1,:), stdFixMinS2B_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)+.05, avgFixMinS2B_el_bl(2,:), stdFixMinS2B_el_bl(2,:),'-o','Color',ballC2)

hline(0,[.3 .3 .3],1.5,':')

plot2svg([figSaveDir 'avgFixMinS2B_el_bl.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Avg min distance
set(0, 'DefaultAxesFontName', 'Roboto')

[avgfix2BallMinDegs_el_bl stdFix2BallMinDegs_el_bl  fix2BallMinDegs_Cel_bl_rep] = orgBy_El_Bl_Rep(dataFileString,fix2BallMinDegs_tr,2.5);

figure(91)
clf
hold on    
xlabel('block')
ylabel({'min ball-to-fixation','distance (degrees)'})
set(gca,'XTick',1:numBlocks);
 axis([.75 numBlocks+.25 0 10])
 
errorbar( (1:numBlocks)-.05, avgfix2BallMinDegs_el_bl (1,:), stdFix2BallMinDegs_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)+.05, avgfix2BallMinDegs_el_bl (2,:), stdFix2BallMinDegs_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'avgFix2BallDegs.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Average time of movement initiation

[avgSaccStartS2B_el_bl stdSaccStartS2B_el_bl saccStartS2B_el_bl_reps] = orgBy_El_Bl_Rep(dataFileString,saccStartS2B_tr*1000,2.5);

figure(90)
clf
hold on    
xlabel('Block')
axis([.75 numBlocks+.25 -400 100])
set(gca,'XTick',1:numBlocks);
ylabel({'Initiation time of' 'predictive movements (ms)'})
hline(0,[.3 .3 .3],1.5,':')

idx = find( isnan(adjStartFr_tr) == 0 );
adjTimeRelBounce_tr =  NaN(numTrials ,1);
adjTimeRelBounce_tr(idx) = sceneTime_fr(adjStartFr_tr(idx)) - sceneTime_fr( bounceFrame_tr(idx ));

[ avgAdjTimeRelBounce_el_bl  stdAdjTimeRelBounce_el_bl  adjTimeRelBounce_Cel_bl_reps  ] = orgBy_El_Bl_Rep(dataFileString,adjTimeRelBounce_tr *1000,2.5);

errorbar( (1:numBlocks)-.05, avgAdjTimeRelBounce_el_bl  (1,:), stdAdjTimeRelBounce_el_bl(1,:),':o','Color',ballC1)
errorbar( (1:numBlocks)+.05, avgAdjTimeRelBounce_el_bl  (2,:), stdAdjTimeRelBounce_el_bl(2,:),':o','Color',ballC2)

errorbar( (1:numBlocks)-.05, avgSaccStartS2B_el_bl(1,:), stdSaccStartS2B_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)+.05,avgSaccStartS2B_el_bl(2,:), stdSaccStartS2B_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'movementInitiation.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distance from gaze to the bouncepoint at minimum

[avgFix2BounceDegs_el_bl stdFix2BounceDegs_el_bl fix2BounceDegs_Cel_bl_rep] = orgBy_El_Bl_Rep(dataFileString,fix2BounceDegs_tr,2.5);

figure(80)
clf
hold on    
xlabel('Block')
ylabel({'Distance from fixation' 'to bouncepoint (degrees)'})
set(gca,'XTick',1:numBlocks);
 axis([.75 numBlocks+.25 0 10])
 
errorbar( (1:numBlocks)-.05, avgFix2BounceDegs_el_bl(1,:), stdFix2BounceDegs_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)+.05, avgFix2BounceDegs_el_bl(2,:), stdFix2BounceDegs_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'avgFix2BounceDegs.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Percent predictive eye movements

[foundPredFix_el_bl] = orgPctBy_El_Bl_Rep(dataFileString,foundPredFix_tr);

figure(70)
clf
hold on    
xlabel('Block')
ylabel('Percent predictive fixations')
axis([.25 numBlocks+.75 0 100 ])
set(gca,'XTick',1:numBlocks);

plot( (1:numBlocks)-.05, foundPredFix_el_bl(1,:),'-o','Color',ballC1)
plot( (1:numBlocks)+.05, foundPredFix_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'foundPredFix_el_bl.svg'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hand Height Vs Ball height Scatter

figure(60)
clf
hold on    
xlabel('Final ball height')
ylabel('Predictive ball height')

colorList = [ballC1; ballC2]

axis square equal
axis([.75 2.25 .75 2.25])



for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(foundPredHandAdj_tr==1));
    scatter( ballHeightAtArrival_tr(idx),adjEndPoint_tr_xyz(idx,3),'SizeData',80,'Marker','o','MarkerFaceColor',colorList(eIdx,:),'MarkerEdgeColor',colorList(eIdx,:))
    %scatter( ballHeightAtArrival_tr(idx),adjEndPoint_tr_xyz(idx,3),80,[shapeList(1+eIdx)],'filled','LineWidth',2,'MarkerFaceColor',colorList(eIdx,:))
    
end

line([0 5],[0 5],'LineStyle',':','Color',[.3 .3 .3],'LineWidth',1.5)
line([0 5],[racquetSize(2) 5+racquetSize(2)],'LineStyle',':','Color',[.6 .6 .6],'LineWidth',1.5)
line([0 5],[-racquetSize(2) 5-racquetSize(2)],'LineStyle',':','Color',[.6 .6 .6],'LineWidth',1.5)

plot2svg([figSaveDir 'ballHeightAtArrival.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Location of predictive hand placement over blocks

handPredErrorRaqRad_tr = (adjEndPoint_tr_xyz(:,3) - ballHeightAtArrival_tr) ./ (racquetSize(2));

[avgHandPredErrorRaqRad_el_bl stdHandPredErrorRaqRad_el_bl  avgHandPredErrorRaqRad_Cel_bl_reps ] = orgBy_El_Bl_Rep(dataFileString,abs(handPredErrorRaqRad_tr),0);

figure(50)
clf
hold on    
xlabel('Block')
set(gca,'XTick',1:numBlocks);
set(gca,'YTick',-2:.5:2);
ylabel({'Accuracy of Hand Placement' '(units of paddle radii)'})
axis([.75 numBlocks+.25 0 2])
set(gca,'XTick',1:numBlocks);
set(gca,'YTick',-2:.5:2);
hline(1,[.3 .3 .3],1.5,':')

errorbar( (1:numBlocks)-.05, avgHandPredErrorRaqRad_el_bl(1,:), stdHandPredErrorRaqRad_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)+.05, avgHandPredErrorRaqRad_el_bl(2,:), stdHandPredErrorRaqRad_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'accHandPlacement.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ball arrival location vs hand arrival location

[avgBallHeightAtArrival_el_bl stdBallHeightAtArrival_el_bl  ballHeightAtArrivalCel_bl_reps ] = orgBy_El_Bl_Rep(dataFileString,ballHeightAtArrival_tr,0);
[avgHandHeightAtPredStill_el_bl  stdHandHeightAtPredStill_el_bl  handHeightAtPredStillCel_bl_reps] = orgBy_El_Bl_Rep(dataFileString,adjEndPoint_tr_xyz(:,3),0);


figure(40)
clf
hold on    
xlabel('Block')
set(gca,'XTick',1:numBlocks);
set(gca,'YTick',-2:.5:3);
ylabel({'Hand height vs' ,'Ball height at arrival (m)'})
axis([.75 numBlocks+.25 .75 2.5])

errorbar( (1:numBlocks)-.03, avgBallHeightAtArrival_el_bl(1,:), stdBallHeightAtArrival_el_bl(1,:),'-o','Color',ballC1)
errorbar( (1:numBlocks)-.03, avgBallHeightAtArrival_el_bl(2,:), stdBallHeightAtArrival_el_bl(2,:),'-o','Color',ballC2)

errorbar( (1:numBlocks)+.03, avgHandHeightAtPredStill_el_bl(1,:), stdHandHeightAtPredStill_el_bl(1,:),'--^','Color',ballC1)
errorbar( (1:numBlocks)+.03, avgHandHeightAtPredStill_el_bl(2,:), stdHandHeightAtPredStill_el_bl(2,:),'--^','Color',ballC2)

plot2svg([figSaveDir 'handVsBallHeight.svg'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Percent predictive hand movements

[foundPredHandAdj_el_bl] = orgPctBy_El_Bl_Rep(dataFileString,foundPredHandAdj_tr);

figure(30)
clf
hold on    
xlabel('Block')
ylabel('Percent predictive hand movements')
set(gca,'XTick',1:numBlocks);
axis([.75 numBlocks+.25 0 100 ])

plot( (1:numBlocks)-.05, foundPredHandAdj_el_bl(1,:),'-o','Color',ballC1)
plot( (1:numBlocks)+.05, foundPredHandAdj_el_bl(2,:),'-o','Color',ballC2)

plot2svg([figSaveDir 'pctPredHandAdj.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Percent caught

[pctCaught_el_bl] = orgPctBy_El_Bl_Rep(dataFileString,successfulCatch_tr);

figure(20)
clf
hold on    
xlabel('Block')
ylabel('Percent Caught')

axis([.5 numBlocks+.5 0 100 ])
bar_h = bar(pctCaught_el_bl','grouped')
set(bar_h(1),'facecolor',ballC1)
set(bar_h(2),'facecolor',ballC2)

plot2svg([figSaveDir 'pctCaught.svg'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Duration from bounce to arrival

[avgDurBounceToArrivalSec_el_bl stdDurBounceToArrivalSec_el_bl  durBounceToArrivalSec_Cel_bl_reps ] = orgBy_El_Bl_Rep(dataFileString,durBounceToArrivalSec_tr*1000,0);

figure(10)
clf
hold on    
xlabel('Block')
%set(gca,'XTick',1:numBlocks);
%set(gca,'YTick',-2:.5:2);
ylabel({'Duration from bounce', 'to arrival (ms)'})
axis([.75 numBlocks+.25 250 400])
set(gca, 'LineWidth', 3);
errorbar( (1:numBlocks)-.05, avgDurBounceToArrivalSec_el_bl (1,:), stdDurBounceToArrivalSec_el_bl(1,:),'r','LineWidth',3)
errorbar( (1:numBlocks)+.05, avgDurBounceToArrivalSec_el_bl (2,:), stdDurBounceToArrivalSec_el_bl(2,:),'b','LineWidth',3)


plot2svg([figSaveDir 'postBounceDur.svg'])

%%
