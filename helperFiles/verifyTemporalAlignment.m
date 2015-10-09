
%[yi] = interp1( sceneTime_fr,gazePixelNormX_fr,eyeDataTime_fr,'nearest');

%[yi] = interp1( sceneTime_fr,gazePixelNormX_fr,eyeDataTime_fr,'nearest');
%[yi] = interp1( eyeDataTime_fr,gazePixelNormX_fr,sceneTime_fr,'nearest');

% [uniqueEyeTime uniqueEyeDataFr J] = unique(eyeDataTime_fr);
% 
% [shiftedEyeTime_fr] = interp1( uniqueEyeTime, uniqueEyeTime,sceneTime_fr,'nearest');
% [gazePixelNormX_fr] = interp1( uniqueEyeTime, gazePixelNormX_fr,sceneTime_fr,'nearest');
% [gazePixelNormY_fr] = interp1( uniqueEyeTime, gazePixelNormY_fr,sceneTime_fr,'nearest');
% eyeDataTime_fr = shiftedEyeTime_fr;

%%

figure(10000)
hold on
title('Red=Framerate;  Blue=SceneTime-EyeDataTime')
set(10000,'Units','Normalized','Position',[0.017 0.51 0.69 0.39]);
ylabel({'SceneTIme-EyeTime' 'Frames (assuming 1/60 sec/frame)'})
xlabel('Frames (skipped frames outside of trails)')

trialStartFr_tr = find(eventFlag_fr == 1);
trialEndFr_tr =   union( find(eventFlag_fr == 2), find(eventFlag_fr == 3));

%ylim([0 3])
numTrials = numel(trialEndFr_tr);
showEvery = numTrials-1;

trStart = 1;
trStop = trStart +showEvery;
xlim([ trialStartFr_tr(trStart)  trialEndFr_tr(trStop)])

frList = 1;
frameStart = 1;

sceneDur_fr = diff(sceneTime_fr);

for trIdx = 1:numTrials
    
    trFrList = trialStartFr_tr(trIdx):trialEndFr_tr(trIdx);
    tempAlignment_trFr   = (sceneTime_fr(trFrList ) - eyeDataTime_fr(trFrList)) ./ (1/60);
    %tempAlignment_trFr   = (sceneTime_fr(trFrList ) - shiftedEyeTime_fr(trFrList)) ./ (1/60);
    
    sceneDur_frFr = sceneDur_fr(trFrList)./ (1/60);
    
    if( rem(trIdx,2) == 0)
        plColor = 'r';
    else
        plColor = 'b';
    end
    
    %vline(frList(end))
    
    frList = frList(end)+1;
    frList = frList:frList+numel(trFrList)-1;
    plot( frList, tempAlignment_trFr)
    %plot( frList, sceneDur_frFr,'r')
     
    xlim([1 frList(end)])
    
    if( rem(trIdx,showEvery ) == 0 )

        tempAlignment_trFr = [];
        trStart = trStop +1;
        trStop = trStart +showEvery;
        frList = 1;
        keyboard
        cla
        
    end
    
    
end