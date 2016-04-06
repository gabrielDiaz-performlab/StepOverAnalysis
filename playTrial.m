function [] = playTrial(ETG_VidObj, sessionData, trIdx)

trStart = sessionData.processedData_tr(trIdx).ETG.tr_Start;
trStop = sessionData.processedData_tr(trIdx).ETG.tr_Stop;
B_POR = sessionData.processedData_tr(trIdx).ETG.B_POR;
ETG_ts = sessionData.processedData_tr(trIdx).ETG.ETG_ts;
angSeperation = sessionData.processedData_tr(trIdx).ETG.angSeparation;

vid = read(ETG_VidObj,round(ETG_VidObj.FrameRate*[trStart trStop]));
no_of_frames = size(vid,4);
no_of_samples = length(ETG_ts);

figure;
subplot(1,2,1)
Im1 = imshow(zeros(ETG_VidObj.Height, ETG_VidObj.Width, 3));hold on;
P1 = plot(0,0,'rx','LineWidth',3);hold off
subplot(1,2,2)
plot(ETG_ts, angSeperation); hold on; 
L1 = plot([0 0],[0 max(angSeperation)],'LineWidth',3); hold off; axis([0 6.5 0 max(angSeperation)])

for i = 1:no_of_samples
    vidFr = ceil(i*no_of_frames/no_of_samples);
    set(Im1, 'Cdata', vid(:,:,:,round(vidFr)));
    set(P1, 'xdata', B_POR(i,1), 'ydata', B_POR(i,2))    
    set(L1, 'xdata', [ETG_ts(i) ETG_ts(i)])
    drawnow
    pause(0.05)
end
end