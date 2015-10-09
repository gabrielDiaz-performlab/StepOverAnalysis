%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hand-ball error over time

figure(1021)
clf
hold on    
xlabel('Trial')
ylabel('Hand-to-ball distance')
%plot(handToBallErrM_tr )
set(1021,'Units','Normalized','Position',[0.013 0.44 0.67 0.47]);


for eIdx = 1:numel(elasticityList)
    idx = find(elasticity_tr==elasticityList(eIdx));
    plot( handAtBncToBallDistZ_tr(idx), colorList(eIdx))
    display(sprintf('Standard deviation in hand error e%i: %1.2f',eIdx,std( handAtBncToBallDistZ_tr(idx) )));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix to ball distance

figure(1030)
clf
hold on           
set(1030,'Units','Normalized','Position',[0.061 0.24 0.34 0.67]);
        
for eIdx = 1:numel(elasticityList)
    subplot(2,1,eIdx)
    xlabel('fix-to-ball distance (degrees)')
    ylabel('number of trials')
    hold on
    xlim([0 10])
    ylim([0 30])
    [n,xout] = hist(gca,fix2BallMinDegs_el_cRep{eIdx},0:10);
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fix elevation at minimum

figure(1041)
hold on
clf

histRange = -40:1:-10;

for eIdx = 1:numel(elasticityList)
    subplot(2,1,1)
    xlabel('fix elevation at minimum')
    ylabel('number of trials')
    hold on
    
    [n,xout] = hist(gca,fixPitch_el_cRep{eIdx},histRange );
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
    xlim([-35 -10])
end

for eIdx = 1:numel(elasticityList)
    subplot(2,1,2)
    xlabel('Ball elevation at mean time of minimum')
    ylabel('number of trials')
    hold on
    
    [n,xout] = hist(gca,ballLocationAtMeanMin_el_cRep{eIdx},histRange );
    h = bar(gca,xout-((eIdx-1)*.25),n,.5);
    set(h,'facecolor',colorList(eIdx))
    f1 = ezfit(xout,n,'gauss');
    showfit(f1, 'fitcolor', colorList(eIdx), 'fitlinewidth', 2);
    hold on
    xlim([-35 -10])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Hand locations at bounce

figure(111)
cla
hold on
xlabel('X')
ylabel('Y')
zlabel('Z')
view(2)
axis square equal
axisSize= 2.5;
axis([-axisSize/2 axisSize/2 -.25 axisSize-.25 0 axisSize])
view(200,18)
set(gca,'ZGrid','on')

scatter3( viewPos_fr_xyz(bounceFrame_tr(trIdx),1),viewPos_fr_xyz(bounceFrame_tr(trIdx),2),viewPos_fr_xyz(bounceFrame_tr(trIdx),3),400 ,'k','filled')

plot3( [viewPos_fr_xyz(bounceFrame_tr(trIdx),1) viewPos_fr_xyz(bounceFrame_tr(trIdx),1)],...
    [viewPos_fr_xyz(bounceFrame_tr(trIdx),2) viewPos_fr_xyz(bounceFrame_tr(trIdx),2)],...
    [viewPos_fr_xyz(bounceFrame_tr(trIdx),3) 0],'-','Color','k','LineWidth',10);

idx = find(elasticity_tr==elasticityList(1));
scatter3( ballPos_fr_xyz(passFrame_tr(idx),1),ballPos_fr_xyz(passFrame_tr(idx),2),ballPos_fr_xyz(passFrame_tr(idx),3),50,'*','MarkerFaceColor','r')
scatter3( racqPos_fr_xyz(bounceFrame_tr(idx),1),racqPos_fr_xyz(bounceFrame_tr(idx),2),racqPos_fr_xyz(bounceFrame_tr(idx),3) ,100,'or','LineWidth',2)

idx = find(elasticity_tr==elasticityList(2));
scatter3( ballPos_fr_xyz(passFrame_tr(idx),1),ballPos_fr_xyz(passFrame_tr(idx),2),ballPos_fr_xyz(passFrame_tr(idx),3),50,'*','MarkerFaceColor','g')
scatter3( racqPos_fr_xyz(bounceFrame_tr(idx),1),racqPos_fr_xyz(bounceFrame_tr(idx),2),racqPos_fr_xyz(bounceFrame_tr(idx),3) ,100,'og','LineWidth',2)

% % Plot hand
% for plotHandFr = [ passFrame_tr(trIdx):12:passFrame_tr(trIdx) bounceFrame_tr(trIdx) passFrame_tr(trIdx)]%passFrame_tr(trIdx):20:passFrame_tr(trIdx)
%     
%     if( plotHandFr  == bounceFrame_tr(trIdx)  )
%         racColor = 'b';
%         alphaVal = 1;
%     elseif(plotHandFr  == passFrame_tr(trIdx) )
%         racColor = 'r';
%         alphaVal = 1;
%     else
%         racColor = 'c';
%         alphaVal = .3;
%     end
%     
%     racRotMatTemp_d1_d2 = quaternion2matrix(racqQuat_fr_quat(plotHandFr,:));
%     racRotMatTemp_d1_d2 = racRotMatTemp_d1_d2(1:3,1:3);
%     piData = 0:pi/8:2*pi;
%     racCircle = [cos(piData); sin(piData); zeros(1,numel(piData)) ] * racquetSize_whd(1);
%     newData_XYZ_circPt =  repmat(racqPos_fr_xyz(plotHandFr,:)',1,size(racCircle,2)) + (racRotMatTemp_d1_d2 * racCircle);
%     handCirc = patch(newData_XYZ_circPt(1,:),newData_XYZ_circPt(2,:),newData_XYZ_circPt(3,:), racColor );
%     alpha(handCirc,alphaVal);
%     
% end

%racqPos_fr_xyz(passFrame_tr(trIdx),1)  + racRotMatTemp_d1_d2 * [cos(0:pi/8:2*pi) 0 sin(0:pi/8:2*pi)  ]
%
% 
% if( elasticity_tr(trIdx) == elasticityList(1) )
%     plot3( ballPos_fr_xyz(passFrame_tr(trIdx),1),ballPos_fr_xyz(passFrame_tr(trIdx),2),ballPos_fr_xyz(passFrame_tr(trIdx),3),'ro-')
% elseif(elasticity_tr(trIdx) == elasticityList(2))
%     plot3( ballPos_fr_xyz(passFrame_tr(trIdx),1),ballPos_fr_xyz(passFrame_tr(trIdx),2),ballPos_fr_xyz(passFrame_tr(trIdx),3),'go-')
% elseif(elasticity_tr(trIdx) == elasticityList(3))
%     plot3( ballPos_fr_xyz(passFrame_tr(trIdx),1),ballPos_fr_xyz(passFrame_tr(trIdx),2),ballPos_fr_xyz(passFrame_tr(trIdx),3),'bo-')
% else
%     plot3( ballPos_fr_xyz(passFrame_tr(trIdx),1),ballPos_fr_xyz(passFrame_tr(trIdx),2),ballPos_fr_xyz(passFrame_tr(trIdx),3),'ko-')
% end
% 
% plot3( ballPos_fr_xyz(passFrame_tr(trIdx),1),ballPos_fr_xyz(passFrame_tr(trIdx),2),zeros(numel(passFrame_tr(trIdx)),1),'Color',[.2 .2 .2])



