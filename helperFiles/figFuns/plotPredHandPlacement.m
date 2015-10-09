
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Percent predictive hand movements


[pctPredHandAdj_tr] = orgPctBy_El_Bl_Rep(foundPredHandAdj_tr);

figure(60)
clf
hold on    
set(gca,'XTick',1:4);
xlabel('Block')
ylabel('Percent predictive hand movements')
axis([.75 numBlocks+.25 0 100 ])

line( (1:numBlocks)-.05, pctPredHandAdj_tr(1,:),'Color','r')
line( (1:numBlocks)+.05, pctPredHandAdj_tr(2,:),'Color','g')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Start time of predictive movements

adjTimeRelBounce_tr= NaN(numTrials ,1);
idx = find( foundPredHandAdj_tr == 1 );

adjTimeRelBounce_tr(idx) = sceneTime_fr(adjStartFr_tr(idx)) - sceneTime_fr( bounceFrame_tr(idx ));

[ avgAdjTimeRelBounce_el_bl  stdAdjTimeRelBounce_el_bl  adjTimeRelBounce_Cel_bl_reps  ] = orgBy_El_Bl_Rep(adjTimeRelBounce_tr *1000,2.5);

figure(70)
clf
hold on
xlabel('Block')
ylabel({'Start time of predictive', 'hand movement (ms)'});
axis([.75 numBlocks+.25 -400 100])
%set(gca,'XTick',1:numBlocks);
set(gca,'YTick',-1000:100:1000);
hline(0,[.3 .3 .3],1.5,':')

errorbar( (1:numBlocks)-.05, avgAdjTimeRelBounce_el_bl  (1,:), stdAdjTimeRelBounce_el_bl(1,:),'r')
errorbar( (1:numBlocks)+.05, avgAdjTimeRelBounce_el_bl  (2,:), stdAdjTimeRelBounce_el_bl(2,:),'g')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hand Height Vs Ball height Scatter


%ballHeightAtArrival_tr = nanmean(adjEndPoint_tr_xyz(:,3));


figure(80)
clf
hold on    
xlabel('Final ball height')
ylabel('Predictive ball height')

axis square equal
axis([.5 2.25 .5 2.25])

line([0 5],[0 5],'LineStyle',':','Color',[.3 .3 .3],'LineWidth',1.5)

for eIdx = 1:numel(elasticityList)
    
    idx = find(elasticity_tr==elasticityList(eIdx));
    idx = intersect( idx, find(foundPredHandAdj_tr==1));
    
    scatter( ballHeightAtArrival_tr(idx),adjEndPoint_tr_xyz(idx,3) ,80,[shapeList(eIdx) colorList(eIdx)],'filled','LineWidth',2)
    
end


