function sessionData = findTemporalSpikes(sessionData, audioData, fAudio, Fs, t_beep, dispData)

NumTrials = sessionData.expInfo.numTrials;

N = length(audioData);
Tmax = N/Fs;
dT = 1/Fs;

t = (0:dT:Tmax - dT)';

dF = Fs/N;                              % hertz
f = -Fs/2:dF:Fs/2 - dF; f = f';         % hertz

f_signal = fftshift(fft(audioData));

C = 50*dF;
notch_win = exp(-(f - fAudio).^2/(2*C^2)) + exp(-(f + fAudio).^2/(2*C^2));
notch_win = notch_win/max(notch_win);

f_filt_signal = f_signal.*notch_win;
filt_audioData = real(ifft(fftshift(f_filt_signal)));

if dispData == 1
    figure;
    subplot(2,2,1);plot(f,abs(f_signal));
    subplot(2,2,2);plot(f,abs(f_filt_signal))
    subplot(2,2,3);plot(t,audioData);
    subplot(2,2,4);plot(t,filt_audioData);
end

filt_audioData = abs(filt_audioData);
filt_audioData = filt_audioData/max(filt_audioData);

[~, peaklocs] = DetectPeaks(filt_audioData, NumTrials);

Y_line = repmat([min(filt_audioData) max(filt_audioData)],[length(peaklocs) 1]);

if dispData == 1
    figure;
    plot(t,audioData);hold on;
    line([t(peaklocs) t(peaklocs)]',Y_line','LineWidth',2,'LineStyle','--')
end

peaklocs = sort(peaklocs);
beeplocs = t(peaklocs);
start_Beeps = beeplocs(1:2:end);
end_Beeps = beeplocs(2:2:end);

for i = 1:NumTrials
    if ~sessionData.rawData_tr(i).info.excludeTrial
        sessionData.rawData_tr(i).ETG.tr_Start = start_Beeps(i) - 0.5*t_beep;
        sessionData.rawData_tr(i).ETG.tr_Stop = end_Beeps(i) - 0.5*t_beep;
    else
        sessionData.rawData_tr(i).ETG.tr_Start = NaN;
        sessionData.rawData_tr(i).ETG.tr_Stop = NaN;
    end
end

end