
figure(2)
cla
hold on
set(gcf,'Renderer','OpenGL')
xlabel('X')
ylabel('Y')
zlabel('Z')
view(2)
axis square equal
axisSize= 2.5;
axis([-axisSize/2 axisSize/2 -.25 5  0 axisSize])
view(200,18)
set(gca,'ZGrid','on')

%a = -100:1:100;
%surf(a,a,zeros(numel(a),numel(a)));

%  Plot hand at specific times
plot3( racqPos_fr_xyz(plotFr,1),racqPos_fr_xyz(plotFr,2),racqPos_fr_xyz(plotFr,3) ,'b')

scatter3( racqPos_fr_xyz(plotFr(1),1), racqPos_fr_xyz(plotFr(1),2),racqPos_fr_xyz(plotFr(1),3),100,'s','MarkerFaceColor','g')
scatter3( racqPos_fr_xyz(plotFr(end),1),racqPos_fr_xyz(plotFr(end),2),racqPos_fr_xyz(plotFr(end),3),50,'o','MarkerFaceColor','r')
scatter3( racqPos_fr_xyz(bounceFrame_tr(trIdx),1),racqPos_fr_xyz(bounceFrame_tr(trIdx),2),racqPos_fr_xyz(bounceFrame_tr(trIdx),3),50,'*','MarkerFaceColor','k')

% Plot hand at time intervals
for plotHandFr = [ plotFr(1):12:plotFr(end) bounceFrame_tr(trIdx) plotFr(end)]%plotFr(1):20:plotFr(end)
    
    if( plotHandFr  == bounceFrame_tr(trIdx)  )
        racColor = 'b';
        alphaVal = 1;
    elseif(plotHandFr  == plotFr(end) )
        racColor = 'r';
        alphaVal = 1;
    else
        racColor = 'c';
        alphaVal = .3;
    end
    
    racRotMatTemp_d1_d2 = quaternion2matrix(paddleQUAT_WXYZ(plotHandFr,:));
    racRotMatTemp_d1_d2 = racRotMatTemp_d1_d2(1:3,1:3);
    piData = 0:pi/8:2*pi;
    
    %racCircle = [cos(piData); sin(piData); zeros(1,numel(piData)) ] * racquetSize_whd(1);
    
    racCircle = [ sin(piData)* racquetSize(2); cos(piData)* racquetSize(2); repmat(-racquetSize(1),1,length(piData))];
    
    newData_XYZ_circPt =  repmat(racqPos_fr_xyz(plotHandFr,:)',1,size(racCircle,2)) + (racRotMatTemp_d1_d2 * racCircle);
    handCirc = patch(newData_XYZ_circPt(1,:),newData_XYZ_circPt(2,:),newData_XYZ_circPt(3,:), racColor );
    alpha(handCirc,alphaVal);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Plot ball trajectory
% plot pursuit
pursId = [];

if( foundPur_tr(trIdx))
    for i = 1:numel( posBouncePursuit_tr_ConOff{trIdx,1})
        pursId = posBouncePursuit_tr_ConOff{trIdx,1}(i):posBouncePursuit_tr_ConOff{trIdx,2}(i);
        plot3( ballPos_fr_xyz(pursId,1),ballPos_fr_xyz(pursId,2),ballPos_fr_xyz(pursId,3),'o-','Color',[0 .6 0])
    end
end

ballTrajFr =  setdiff( plotFr,pursId);

if( elasticity_tr(trIdx) == elasticityList(1) )
    plot3( ballPos_fr_xyz(ballTrajFr ,1),ballPos_fr_xyz(ballTrajFr ,2),ballPos_fr_xyz(ballTrajFr ,3),'ro-')
elseif(elasticity_tr(trIdx) == elasticityList(2))
    plot3( ballPos_fr_xyz(ballTrajFr ,1),ballPos_fr_xyz(ballTrajFr ,2),ballPos_fr_xyz(ballTrajFr ,3),'go-')
elseif(elasticity_tr(trIdx) == elasticityList(3))
    plot3( ballPos_fr_xyz(ballTrajFr ,1),ballPos_fr_xyz(ballTrajFr ,2),ballPos_fr_xyz(ballTrajFr ,3),'bo-')
else
    plot3( ballPos_fr_xyz(ballTrajFr ,1),ballPos_fr_xyz(ballTrajFr ,2),ballPos_fr_xyz(ballTrajFr ,3),'ko-')
end


plot3( ballPos_fr_xyz(plotFr,1),ballPos_fr_xyz(plotFr,2),zeros(numel(plotFr),1),'Color',[.2 .2 .2])
scatter3( ballPos_fr_xyz(bounceFrame_tr(trIdx),1),ballPos_fr_xyz(bounceFrame_tr(trIdx),2),ballPos_fr_xyz(bounceFrame_tr(trIdx),3),100,'*','MarkerFaceColor','k')


%%
%  Plot gaze vector at each frame of fixation
for fixFr = fixFrames_tr_cFr{trIdx}
    
    gazePosOnThisFrame_xyz = leftEyeInWorld_fr_xyz(fixFr,:) + (gazeDir_fr_xyz(fixFr,:)  .* 4);
    
    line([leftEyeInWorld_fr_xyz(fixFr,1) gazePosOnThisFrame_xyz(1)],...
    [leftEyeInWorld_fr_xyz(fixFr,2) gazePosOnThisFrame_xyz(2)],...
    [leftEyeInWorld_fr_xyz(fixFr,3) gazePosOnThisFrame_xyz(3)],...
    'Color',[.3 .3 .3]);

end

if( foundPredFix_tr(trIdx) )
    
    %  Plot gaze vector at minimum
    gazePosAtMin_xyz = leftEyeInWorld_fr_xyz(fix2BallMinFr_tr(trIdx),:) + (gazeDir_fr_xyz(fix2BallMinFr_tr(trIdx),:)  .* 4);
    
    line([leftEyeInWorld_fr_xyz(fix2BallMinFr_tr(trIdx),1) gazePosAtMin_xyz(1)],...
        [leftEyeInWorld_fr_xyz(fix2BallMinFr_tr(trIdx),2) gazePosAtMin_xyz(2)],...
        [leftEyeInWorld_fr_xyz(fix2BallMinFr_tr(trIdx),3) gazePosAtMin_xyz(3)], 'LineWidth',3);
    
    plot3( ballPos_fr_xyz(fixFrames_tr_cFr{trIdx},1), ballPos_fr_xyz(fixFrames_tr_cFr{trIdx},2), ballPos_fr_xyz(fixFrames_tr_cFr{trIdx},3),'ok-')
    
    % Mark ball trajectory when fixaiton starts
    scatter3( ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(1),1),ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(1),2),ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(1),3),200,'o','MarkerFaceColor','none','MarkerEdgeColor','g','LineWidth',3)
    % Mark ball trajectory when fixaiton ends
    scatter3( ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(end),1),ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(end),2),ballPos_fr_xyz(fixFrames_tr_cFr{trIdx}(end),3),200,'o','MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',3)
    % Mark ball trajectory at time of min
    scatter3( ballPos_fr_xyz(fix2BallMinFr_tr(trIdx),1),ballPos_fr_xyz(fix2BallMinFr_tr(trIdx),2),ballPos_fr_xyz(fix2BallMinFr_tr(trIdx),3),200,'*','MarkerFaceColor','b','MarkerEdgeColor','b','LineWidth',3)
    
    %  Plot head and stick figure body during fixation
    meanHeadPosAtFix_xyz = mean( leftEyeInWorld_fr_xyz(fixFrames_tr_cFr{trIdx},:),1);
    scatter3( meanHeadPosAtFix_xyz(1),meanHeadPosAtFix_xyz(2),meanHeadPosAtFix_xyz(3),800 ,[.3 .3 .3],'filled');
    
    plot3( [meanHeadPosAtFix_xyz(1) meanHeadPosAtFix_xyz(1)],...
        [meanHeadPosAtFix_xyz(2) meanHeadPosAtFix_xyz(2)],...
        [meanHeadPosAtFix_xyz(3) 0],'-','Color',[.3 .3 .3],'LineWidth',10);

end




%%

%set(11,'Units','Normalized','Position',[0.36 0.018 0.63 0.89]);
