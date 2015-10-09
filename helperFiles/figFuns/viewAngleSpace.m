q = 0;
figFrames = -40:15;

useBoundedLines = 0;

pcaByGroup = 0;
pcaForAll = 0;

showRecData = 1;

zoomBy = 2.5;
bottomX = -10;
leftSide = -15;

%axisRange  =  [-76/(2*zoomBy) 76/(2*zoomBy) bottomX  (64/zoomBy)+bottomX ];

axisRange  =  [leftSide leftSide+(76/zoomBy) bottomX  bottomX+(64/zoomBy)];

plotBlockList = [4];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  PLOT

figure(2323)
close 2323
figure(2323)
cla
set(2323,'Units','Normalized','Position',[0.018452380952381 0.40272373540856 0.748809523809524 0.47568093385214]);

for eIdx = 1:numel(elasticityList)
    frontLilst  = [];
    
    subplot(1,2,eIdx)
    hold on
    colorString = 'rgb';
    axis equal
    axis(axisRange)
    set(gcf,'Renderer','zbuffer')
    grid on
    hline(0)
    vline(0)
    frontList = [];
    moreFrontList = [];
    
    idx = find( elasticity_tr == elasticityList(eIdx));
    idx = intersect( find(foundPredFix_tr==1),idx);
    
    trInBlockList  = [];
    
    for x = 1:numel(plotBlockList)
        trInBlockList = [trInBlockList  trInBlk_blk(plotBlockList(x),:)];
    end
    
    idx = intersect( idx, trInBlockList);
    
    for  trIdx = idx
        
   
        plFrameList = bounceFrame_tr(trIdx)+figFrames;
    
        % Plot ball trajectory
        plot( (180/pi)*ball2BptBptCentThetaRads_fr(plFrameList ), (180/pi)*ball2BptBptCentPhiRads_fr(plFrameList ),'Color',colorList(eIdx));
    
        % Plot fixation location
        h= scatter( mean(ball2BptBptCentThetaDegs_fr(fixFrames_tr_cFr{trIdx})), mean(ball2BptBptCentPhiDegs_fr(fixFrames_tr_cFr{trIdx})),'MarkerFaceColor','k','MarkerEdgeColor','w');
        
        frontLilst = [frontLilst  h];
        
        trIdx
        keyboard
        cla
    end
    
    %childList = get(gca,'Children');
    %set(gca,'Children',[ frontList setdiff(childList,[frontList]) ] );
    
end


%%

% gazePixX_fr = gazePixelNormX_fr .* arrPixX;
% gazePixY_fr = gazePixelNormY_fr .* arrPixY;
%
% gazePixFiltX_fr  = rballDataFilter(gazePixX_fr);
% gazePixFiltY_fr  = rballDataFilter(gazePixY_fr);
%
% %%
%
% clear lEyeRotandOffsetMat_d1_d2_CplFr
% clear ballBCTheta_tr_CplFr ballBCPhi_tr_CplFr offsetGazeBCTheta_tr_CplFr offsetGazeBCPhi_tr_CplFr gazeBCTheta_tr_CplFr gazeBCPhi_tr_CplFr
% clear evec_tt_zdot  scores_tt_zdot eigenVals_tt_zdot
%
% loadParameters
%
% lEyeOffsetMat = eye(4,4);
% lEyeOffsetMat(1,4) = - eyeOffset;
%
%
%
% ballBCTheta_tr_plFr = nan(numTrials,numel(figFrames));
% ballBCPhi_tr_plFr = nan(numTrials,numel(figFrames));
%
% ballBCThetaEXT_tr_plFr = nan(numTrials,numel(figFrames));
% ballBCPhiEXT_tr_plFr = nan(numTrials,numel(figFrames));
%
% minG2BallDegsExtrap_tr = nan(1,numTrials);
% minExtrapFrAfterBounce_tr = nan(1,numTrials);
% minExtrapFr_tr = nan(1,numTrials);
% extrapGazeTheta_tr = nan(1,numTrials);
% extrapGazePhi_tr= nan(1,numTrials);
%
% for trIdx = 1:numTrials
%
%     frList = bounceFrame_tr(trIdx)+figFrames;
%     frCt = 1;
%
%     for frIdx = frList
%
%         rotateLeftEyeMat = [ cos(eyeRotation) 0 -sin(eyeRotation) 0; 0 1 0 0 ; sin(eyeRotation) 0 cos(eyeRotation) 0; 0 0 0 1];
%         lEyeRotandOffsetMat_d1_d2 = squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat * lEyeOffsetMat;
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Left eye forward
%
%         lEyeForward = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 0 -1 0]';
%         lEyeForwardVecNorm = (lEyeForward./ norm(lEyeForward ))';
%         lEyeForwardVecNorm(4) = [];
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Head up
%
%         headUpVec_xyz   = (squeeze(viewRot_fr_d1_d2(frIdx,:,:)) * rotateLeftEyeMat) * [0 1  0 0]';
%         headUpVecNorm = (headUpVec_xyz ./ norm(headUpVec_xyz ))';
%         headUpVecNorm(4) =[];
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Gaze in world
%
%         gazeHeadSpaceX = ((((2*gazePixFiltX_fr(frIdx))/arrPixX)-1)*tan(arrRadsX/2));
%         gazeHeadSpaceY = -((((2*gazePixFiltY_fr(frIdx))/arrPixY)-1)*tan(arrRadsY/2));
%
%         gazeHeadSpaceDir_xyz =   [gazeHeadSpaceX gazeHeadSpaceY -1]';
%         gazeHeadSpaceDir_xyz = gazeHeadSpaceDir_xyz  ./ norm(gazeHeadSpaceDir_xyz  );
%
%         gazeWorldDir_xyz =   (squeeze(viewRot_fr_d1_d2(frIdx,1:3,1:3))) * rotateLeftEyeMat(1:3,1:3) * gazeHeadSpaceDir_xyz ;
%         gazeVecNorm = gazeWorldDir_xyz ./ norm(gazeWorldDir_xyz );
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Eye to ball
%
%         ballPixX = ballPix_fr_xy(frIdx,1);
%         ballPixY = arrPixY-ballPix_fr_xy(frIdx,2);
%
%         ballHeadSpaceX = ((((2*ballPixX)/arrPixX)-1)*tan(arrRadsX/2));
%         ballHeadSpaceY = -((((2*ballPixY)/arrPixY)-1)*tan(arrRadsY/2));
%
%         ballHeadSpaceDir_xyz =   [ ballHeadSpaceX  ballHeadSpaceY -1 ]';
%         ballHeadSpaceDir_xyz = ballHeadSpaceDir_xyz  ./ norm(ballHeadSpaceDir_xyz  );
%
%         ballWorldDir_xyz = (squeeze(viewRot_fr_d1_d2(frIdx,1:3,1:3))) * rotateLeftEyeMat(1:3,1:3) * ballHeadSpaceDir_xyz;
%         ballVecNorm = (ballWorldDir_xyz ./ norm(ballWorldDir_xyz) );
%
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%% Bouncepoint
%
%         lEyePosRelToView_xyz =  squeeze(lEyeRotandOffsetMat_d1_d2 * [0 0  0 1]');
%         leftEyeInWorld_xyz = lEyePosRelToView_xyz(1:3)' + viewPos_fr_xyz(frIdx,:);
%         leftEyeInWorld_fr_xyz(frIdx,:) = leftEyeInWorld_xyz ;
%
%         bounce_xyz = [ballBounceX_tr(trIdx) ballBounceY_tr(trIdx) ballBounceZ_tr(trIdx)];
%         bptVecNorm = (bounce_xyz - leftEyeInWorld_xyz) ./ norm(bounce_xyz - leftEyeInWorld_xyz);
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%% Project onto unit sphere
%         %%% Bouncepoint centered
%
%         H = cross((bptVecNorm(1:3)),[0 0 1]' ) ./ norm(cross((bptVecNorm(1:3)),[0 0 1]' ));
%         U = cross(H,bptVecNorm(1:3));
%
%         ballBCTheta_tr_CplFr{trIdx}(frCt) =    atan2( dot(ballVecNorm,H),dot(ballVecNorm,bptVecNorm)) * (180/pi);
%         ballBCPhi_tr_CplFr{trIdx}(frCt) =    atan2( dot(ballVecNorm,U),dot(ballVecNorm,bptVecNorm)) * (180/pi);
%
%         ballBCTheta_tr_plFr(trIdx,frCt) =   atan2( dot(ballVecNorm,H),dot(ballVecNorm,bptVecNorm)) * (180/pi);
%         ballBCPhi_tr_plFr(trIdx,frCt) =   atan2( dot(ballVecNorm,U),dot(ballVecNorm,bptVecNorm)) * (180/pi);
%
%         gazeBCTheta_tr_CplFr{trIdx}(frCt) = atan2( dot(gazeVecNorm,H),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);
%         gazeBCPhi_tr_CplFr{trIdx}(frCt) = atan2( dot(gazeVecNorm,U),dot(gazeVecNorm,bptVecNorm(1:3))) * (180/pi);
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Extrapoloated!
%
%         fixFrames = fixFrames_Ctr{trIdx};
%
%         meanViewRotEXT_d1_d2 = squeeze(mean(viewRot_fr_d1_d2(fixFrames ,:,:),1));
%         meanViewPosEXT_xyz = mean(viewPos_fr_xyz(fixFrames,:),1);
%
%         lEyeRotandOffsetEXT_d1_d2 = meanViewRotEXT_d1_d2  * rotateLeftEyeMat * lEyeOffsetMat;
%         lEyePosRelToViewEXT_xyz =  squeeze(lEyeRotandOffsetEXT_d1_d2 * [0 0  0 1]');
%         leftEyeInWorldEXT_xyz = lEyePosRelToViewEXT_xyz(1:3)' + meanViewPosEXT_xyz ;
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Left eye forward
%
%         lEyeForwardEXT = meanViewRotEXT_d1_d2  * rotateLeftEyeMat * [0 0 -1 0]';
%         lEyeForwardVecNormEXT = (lEyeForwardEXT./ norm(lEyeForwardEXT))';
%         lEyeForwardVecNormEXT(4) = [];
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Head up
%
%         headUpVecEXT_xyz   = meanViewRotEXT_d1_d2 * rotateLeftEyeMat * [0 1  0 0]';
%         headUpVecNormEXT = (headUpVecEXT_xyz ./ norm(headUpVecEXT_xyz ))';
%         headUpVecNormEXT(4) =[];
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Eye to ball
%
%         ballPosEXT_xyz = squeeze(ballPos_fr_xyz(frIdx,:));
%         ballVecNormEXT = (ballPosEXT_xyz   - leftEyeInWorldEXT_xyz) ./ norm(ballPosEXT_xyz  - leftEyeInWorldEXT_xyz);
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%% Bouncepoint
%
%         bounceEXT_xyz = [ballBounceX_tr(trIdx) ballBounceY_tr(trIdx) ballBounceZ_tr(trIdx)];
%         bptVecNormEXT = (bounceEXT_xyz - leftEyeInWorldEXT_xyz) ./ norm(bounceEXT_xyz - leftEyeInWorldEXT_xyz);
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%% Project onto unit sphere
%         %%% Bouncepoint centered
%
%         H = cross((bptVecNormEXT(1:3)),[0 0 1]' ) ./ norm(cross((bptVecNormEXT(1:3)),[0 0 1]' ));
%         U = cross(H,bptVecNormEXT(1:3));
%
%         ballBCThetaEXT_tr_CplFr{trIdx}(frCt) =    atan2( dot(ballVecNormEXT,H),dot(ballVecNormEXT,bptVecNormEXT)) * (180/pi);
%         ballBCPhiEXT_tr_CplFr{trIdx}(frCt) =    atan2( dot(ballVecNormEXT,U),dot(ballVecNormEXT,bptVecNormEXT)) * (180/pi);
%
%         ballBCThetaEXT_tr_plFr(trIdx,frCt) =   atan2( dot(ballVecNormEXT,H),dot(ballVecNormEXT,bptVecNormEXT)) * (180/pi);
%         ballBCPhiEXT_tr_plFr(trIdx,frCt) =   atan2( dot(ballVecNormEXT,U),dot(ballVecNormEXT,bptVecNormEXT)) * (180/pi);
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%  fixation locaiton by trial
%         if( foundSaccAndFix_tr(trIdx) == 1 )
%
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%% Mean gaze to ball distance
%
%             avgXPixel = mean(gazePixFiltX_fr(fixFrames_Ctr{trIdx}));
%             avgYPixel =mean(gazePixFiltY_fr(fixFrames_Ctr{trIdx}));
%
%             gazeHeadSpaceExtX = ( ((2*avgXPixel)/arrPixX)-1) * tan(arrRadsX/2);
%             gazeHeadSpaceExtY = -((((2*avgYPixel)/arrPixY)-1)*tan(arrRadsY/2));
%
%             gazeHeadSpaceDirExt_xyz =   [gazeHeadSpaceExtX gazeHeadSpaceExtY -1]';
%             gazeHeadSpaceDirExt_xyz  = gazeHeadSpaceDirExt_xyz   ./ norm(gazeHeadSpaceDirExt_xyz   );
%
%             gazeWorldDirEXT_xyz =   meanViewRotEXT_d1_d2(1:3,1:3) * rotateLeftEyeMat(1:3,1:3) * gazeHeadSpaceDirExt_xyz ;
%             fixVecNormEXT = gazeWorldDirEXT_xyz ./ norm(gazeWorldDirEXT_xyz );
%
%             gazeBCThetaEXT_tr_CplFr{trIdx}(frCt) = atan2( dot(fixVecNormEXT ,H),dot(fixVecNormEXT ,bptVecNormEXT(1:3))) * (180/pi);
%             gazeBCPhiEXT_tr_CplFr{trIdx}(frCt) = atan2( dot(fixVecNormEXT ,U),dot(fixVecNormEXT ,bptVecNormEXT(1:3))) * (180/pi);
%
%             g2BallDegsEXT_tr_CplFr{trIdx}(frCt)  =  acos( dot(ballVecNormEXT,fixVecNormEXT  ) ) .* (180/pi);
%
%         end
%
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%         frCt = frCt+1;
%
%
%
%     end
%
%
%     if( foundSaccAndFix_tr(trIdx) == 1 )
%
%         bounceFrame = find(figFrames==0);
%
%         [minVal minIdx] = min(g2BallDegsEXT_tr_CplFr{trIdx}(bounceFrame:end));
%
%         minIdx = -1;
%
%         minExtrapFrAfterBounce_tr(trIdx) = minIdx;
%         minExtrapFr_tr(trIdx) = bounceFrame + minIdx;
%
%         minFrame  = minIdx+bounceFrame;
%         minG2BallDegsExtrap_tr(trIdx)= minVal;
%
%         %gazePhi_tr(trIdx) =   gazeBCPhi_tr_CplFr{trIdx}(minFrame);
%         %gazeTheta_tr(trIdx) =   gazeBCTheta_tr_CplFr{trIdx}(minFrame);
%
%         extrapGazeTheta_tr(trIdx)= atan2( dot(fixVecNormEXT ,H),dot(fixVecNormEXT ,bptVecNormEXT(1:3))) * (180/pi);
%         extrapGazePhi_tr(trIdx) = atan2( dot(fixVecNormEXT ,U),dot(fixVecNormEXT ,bptVecNormEXT(1:3))) * (180/pi);
%
%     end
%
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Organize data & PCA

fixTheta_tt_zdot_rep = nan(2,3,sum(numRepsType1_bl));
fixPhi_tt_zdot_rep = nan(2,3,sum(numRepsType1_bl));
clear evec_tt_zdot_cD1_D2 scores_tt_zdot_cD1_D2 eigenVals_tt_zdot_cD1_D2
clear meanFixXY_zdot_xy stdFixXY_zdot_xy

fixTheta_tr = nan(numTrials,1);
fixPhi_tr = nan(numTrials,1);



for eIdx = 1:numel(zDotList)
    
    idx = find( elasticity_tr == elasticityList(eIdx));
    idx = intersect( find(foundPredFix_tr==1),idx);
    
    %% Choose frames
    for  repIdx = 1:numel(idx)
        
        trIdx =  idx(repIdx);
        
        clear data nData
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%  Oganize gaze phi and theta
        
        if( foundPredFix_tr(trIdx) == 0 )
            
            fixPhi_tt_zdot_rep(bIdx,eIdx,repIdx)   =  NaN;
            fixTheta_tt_zdot_rep(bIdx,eIdx,repIdx)=  NaN;
            
            fixTheta_tr(trIdx) = NaN;
            fixPhi_tr(trIdx) =  NaN;
            
            fixPhiEXT_tt_zdot_rep(bIdx,eIdx,repIdx)   =  NaN;
            fixThetaEXT_tt_zdot_rep(bIdx,eIdx,repIdx)=  NaN;
            
            fixThetaEXT_tr(trIdx) = NaN;
            fixPhiEXT_tr(trIdx) =  NaN;
            
        else
            
            minFrame  = find(figFrames == 0)+fix2BallMinFr2B_tr(trIdx);
            
            fixTheta_tt_zdot_rep(bIdx,eIdx,repIdx) =   gazeBCTheta_tr_CplFr{trIdx}(minFrame);
            fixPhi_tt_zdot_rep(bIdx,eIdx,repIdx)   =   gazeBCPhi_tr_CplFr{trIdx}(minFrame);
            
            fixTheta_tr(trIdx) = gazeBCTheta_tr_CplFr{trIdx}(minFrame);
            fixPhi_tr(trIdx) =   gazeBCPhi_tr_CplFr{trIdx}(minFrame);
            
            fixThetaEXT_tt_zdot_rep(bIdx,eIdx,repIdx) =   gazeBCThetaEXT_tr_CplFr{trIdx}(minFrame);
            fixPhiEXT_tt_zdot_rep(bIdx,eIdx,repIdx)   =   gazeBCPhiEXT_tr_CplFr{trIdx}(minFrame);
            
            fixThetaEXT_tr(trIdx) = gazeBCThetaEXT_tr_CplFr{trIdx}(minFrame);
            fixPhiEXT_tr(trIdx) =   gazeBCPhiEXT_tr_CplFr{trIdx}(minFrame);
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Remove outliers by condition
    
    %fixTheta_tt_zdot_rep(bIdx,eIdx,:) = removeOutliers(squeeze(fixTheta_tt_zdot_rep(bIdx,eIdx,:)),2);
    %fixPhi_tt_zdot_rep(bIdx,eIdx,:) = removeOutliers(squeeze(fixPhi_tt_zdot_rep(bIdx,eIdx,:)),2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PCA by zdot and elasticity
    
    data = [ squeeze(fixTheta_tt_zdot_rep(bIdx,eIdx,:)) squeeze(fixPhi_tt_zdot_rep(bIdx,eIdx,:))];
    pcaIdx = union(find(isnan(data(:,1))),find(isnan(data(:,2))));
    data(pcaIdx,:) = [];
    
    meanXY_tt_zdot(bIdx,eIdx,:) = mean(data,1);
    
    nData(:,1) = data(:,1);
    nData(:,2) = data(:,2);
    
    [evec ,scoreInNewSpace,eigenVals] = princomp(nData);
    evec(:,2) = -evec(:,2);
    scoreInNewSpace(:,2) = -scoreInNewSpace(:,2);
    
    evec_tt_zdot_cD1_D2(bIdx,eIdx) = {evec};
    scores_tt_zdot_cD1_D2(bIdx,eIdx) = {scoreInNewSpace};
    eigenVals_tt_zdot_cD1_D2(bIdx,eIdx) = {eigenVals};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  Calculate average gaze loc
    
    temp = squeeze(fixPhi_tt_zdot_rep(bIdx,eIdx,:));
    meanFixPhi_tt_zdot(bIdx,eIdx) = nanmean(temp);
    stdFixPhi_tt_zdot(bIdx,eIdx) = nanstd(temp);
    
    temp = squeeze(fixTheta_tt_zdot_rep(bIdx,eIdx,:));
    meanFixTheta_tt_zdot(bIdx,eIdx) = nanmean(temp);
    stdFixTheta_tt_zdot(bIdx,eIdx) = nanstd(temp);
    
    %%%%
    
    temp = squeeze(fixPhiEXT_tt_zdot_rep(bIdx,eIdx,:));
    meanFixPhiEXT_tt_zdot(bIdx,eIdx) = nanmean(temp);
    stdFixPhiEXT_tt_zdot(bIdx,eIdx) = nanstd(temp);
    
    temp = squeeze(fixThetaEXT_tt_zdot_rep(bIdx,eIdx,:));
    meanFixThetaEXT_tt_zdot(bIdx,eIdx) = nanmean(temp);
    stdFixThetaEXT_tt_zdot(bIdx,eIdx) = nanstd(temp);
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PCA by ttype


idx = intersect( find( trialType_tr ==bIdx), find(foundSaccAndFix_tr==1));


% remove outliers
tempMeanX = nanmean(fixTheta_tr(idx));
tempMeanY = nanmean(fixPhi_tr(idx));

distFromMean_tr = sqrt(sum((fixTheta_tr-tempMeanX).^2+(fixPhi_tr-tempMeanY ).^2,2));
distFromMeanZscore_tr =  abs((distFromMean_tr-nanmean(distFromMean_tr)) ./ nanstd(distFromMean_tr));
pcaIdx = setdiff( idx, find(distFromMeanZscore_tr >2) );

data = [  fixTheta_tr(pcaIdx) fixPhi_tr(pcaIdx )];

pcaTrials_tt_Cidx(bIdx) = {pcaIdx};

meanFixTheta_tt(bIdx) = mean(data(:,1));
meanFixPhi_tt(bIdx) = mean(data(:,2));

stdFixTheta_tt(bIdx) = std(data(:,1));
stdFixPhi_tt(bIdx) =std(data(:,2));

[evec ,scoreInNewSpace,eigenVals] = princomp(data);

evec_tt_cD1_D2(bIdx) = {evec};
scores_tt_cD1_D2(bIdx) = {scoreInNewSpace};
eigenVals_tt_cD1_D2(bIdx) = {eigenVals};



end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  PLOT

figure(2323)
close 2323
figure(2323)
cla
set(2323,'Units','Normalized','Position',[0.018452380952381 0.40272373540856 0.748809523809524 0.47568093385214]);
framesAfterBounce = 15;

hold on
colorString = 'rgb';
axis equal
axis(axisRange)
set(gcf,'Renderer','zbuffer')
grid on
hline(0)
vline(0)
frontList = [];
moreFrontList = [];

for eIdx = 1:numel(elastiictyList)
    
    idx = find( elasticity_tr == elasticityList(eIdx));
    idx = intersect( find(foundPredFix_tr==1),idx);
    
    plFrameList = bounceFrame_tr(trIdx)+figFrames;
    plot( g2bounceTheta_fr(plFrameList ), g2bouncePhi_fr(plFrameList ),'Color',colorList(eIdx));
    
    scatter( g2bouncePhi_fr(plFrameList ), g2bounceTheta_fr(plFrameList ),'Color',colorList(eIdx));
    
end

%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%% Plot
%
%     if (pcaByGroup == 1)
%
%         frontList = [frontList scatter( fixTheta_tt_zdot_rep(bIdx,eIdx,:), fixPhi_tt_zdot_rep(bIdx,eIdx,:),30,'filled','MarkerFaceColor',colorString(eIdx), 'MarkerEdgeColor','k','LineWidth',1)];
%
%         X = meanFixTheta_tt_zdot(bIdx,eIdx);
%         Y = meanFixPhi_tt_zdot(bIdx,eIdx);
%         stdX = stdFixTheta_tt_zdot(bIdx,eIdx);
%         stdY = stdFixPhi_tt_zdot(bIdx,eIdx);
%
%         moreFrontList   = [moreFrontList      scatter( X, Y,100,'MarkerFaceColor',colorString(eIdx),'MarkerEdgeColor','k','LineWidth',3)];
%         moreFrontList = [moreFrontList line([X X+std(scoreInNewSpace(:,1))*evec(1,1)],[ Y Y+std(scoreInNewSpace(:,1))*evec(1,2)],'Color','k','LineWidth',3)];
%         moreFrontList = [moreFrontList line([X X+std(scoreInNewSpace(:,2))*evec(2,1)],[ Y Y+std(scoreInNewSpace(:,2))*evec(2,2)],'Color','k','LineWidth',3)];
%
%     end
%
%     if( ~pcaByGroup && pcaForAll )
%         frontList = [frontList scatter( fixTheta_tr(idx), fixPhi_tr(idx),30,'filled','MarkerFaceColor',colorString(eIdx), 'MarkerEdgeColor','k','LineWidth',1)];
%     end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot bounded line

%  Plot the ball location
ballTheta_plFr = ballBCTheta_tr_CplFr{trIdx};
ballPhi_plFr = ballBCPhi_tr_CplFr{trIdx};

% plot bounded line
if( useBoundedLines == true)
    boundedline( nanmean(ballBCTheta_tr_plFr(idx,:),1), nanmean(ballBCPhi_tr_plFr(idx,:),1),nanstd(ballBCPhi_tr_plFr(idx,:),1,1),colorString(eIdx));
else
    plot( ballTheta_plFr , ballPhi_plFr,'Color',colorString(eIdx));
end

end

%     set(gca,'Children',[moreFrontList  frontList setdiff(childList,[ moreFrontList frontList])]);






