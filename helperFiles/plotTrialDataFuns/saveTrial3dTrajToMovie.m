close all

plotTrial3DTraj

saveOnRotate = 1;
figHandle = 11 ;

screenRes = get(0,'ScreenSize');

figure(figHandle)
axis vis3d
% set(gca,'xtick',[])
% set(gca,'ytick',[])
% set(gca,'ztick',[])

set(gca,'TickLength',[ 0 0 ])
set(gca,'XTickLabel','','YTickLabel','','ZTickLabel','')
xlabel('')
ylabel('')
zlabel('')

picCount = 1;
for i=1:180
    camorbit(2,0,'data',[0 0 1])
    drawnow
    
    
    if(saveOnRotate)
        clear myImage
        
        myImage = frame2im(getframe(figHandle) );
        dirName = ['Figures/RotateFigs/Sub' sprintf('-%1.0f',subNum) '-Trial' sprintf('%1.0f',trIdx) '/'];
        [junk junk] = mkdir(dirName);
        figString = [dirName sprintf('-%1.0f',picCount) '.png'];
        
        myImage = frame2im(getframe(figHandle) );
        imwrite(myImage, figString, 'XResolution',screenRes(3),'YResolution',screenRes(4),'Compression','none');
        
        picCount = picCount +1;
    end
end

display('Done saving figure')

% close all
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Check for left handedness
% 
% reverseLeftHandedness
% 
% if( removedOutliers == 0 )
%     
%     reverseLeftHandedness
%     removedOutliers  = 1;
%     
%     fprintf( '** Throwing out outliers....\n');
%     
%     hitErr_tr( find(abs(hitErr_tr) > nanmean(hitErr_tr)+nanstd(hitErr_tr)*2) ) = NaN;
%     
%     fix2BallMinDegs_tr  = removeOutliers(fix2BallMinDegs_tr,2);
%     fix2BallMinTheta_tr  = removeOutliers(fix2BallMinTheta_tr,2);
%     fix2BallMinPhi_tr  = removeOutliers(fix2BallMinPhi_tr,2);
%     
%     fix2BounceDegs_tr  = removeOutliers(fix2BounceDegs_tr,2);
%     fix2BounceTheta_tr  = removeOutliers(fix2BounceTheta_tr,2);
%     fix2BouncePhi_tr  = removeOutliers(fix2BouncePhi_tr,2);
%     
%     g2bptBptCentPhi  = removeOutliers(g2bptBptCentPhiDegs_fr,2);
%     g2bptBptCentThetaDegs_fr  = removeOutliers(g2bptBptCentThetaDegs_fr,2);
%     
%     outIdx = [];
%     for dim = 1:3
%         temp1 = find( hitLoc_tr_RaquXYZ(:,dim) < nanmean(hitLoc_tr_RaquXYZ(:,dim))-nanstd(hitLoc_tr_RaquXYZ(:,dim))*2);
%         temp2 = find( hitLoc_tr_RaquXYZ(:,dim) > nanmean(hitLoc_tr_RaquXYZ(:,dim))+nanstd(hitLoc_tr_RaquXYZ(:,dim))*2);
%         outIdx = [outIdx; temp1; temp2];
%     end
%     
%     hitLoc_tr_RaquXYZ( unique(outIdx),:) = NaN;
%     
% end
% 
% 
% 
% %% Plot fixaiton points
% 
% plotFix_blk_el( 2,fix2BounceTheta_tr,fix2BouncePhi_tr,'Gaze-to-ball at time of bounce',[-12 12 -18 2]);
% plotFix_blk_el( 3,fix2BallMinTheta_tr,fix2BallMinPhi_tr,'Min Gaze-to-ball during fixation',[-12 12 -18 2]);
% 
% %%
% 
% indAvg_el_zdot(avgFixMinS2BTT1_el_zdot.*1000,stdFixMinS2BTT1_el_zdot.*1000,31,[-50 400],'time relative to bounce (ms)','Time of minimum distance')
% 
% 
% %%
% 
% plotCorr(fix2BallMinDegs_tr, 1000.*(pursStartS2B_tr-fixMinS2B_tr), 500,'fixation accuracy', 'fix to pursuit delay',[0 5 0 500]) %%%
% 
