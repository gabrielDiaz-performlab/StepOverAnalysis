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
thresh_lvl = mean(filt_audioData);

if dispData == 1
   figure;
   plot(t,filt_audioData);hold on
   plot([t(1) t(end)],[thresh_lvl thresh_lvl],'r')
end

spike_down = -ones(round(1000),1); 
spike_down(end/2:end) = 1; 

spikes = double(filt_audioData > thresh_lvl);
spikes = conv(spikes,ones(100,1));
beep_up = conv(spikes, spike_down, 'same'); 

[heights,idx,~,p] = findpeaks(abs(beep_up));
heights = heights/max(heights); p = p/max(p);
Param_Spike = heights.*p; 
[~,loc] = sort(Param_Spike, 'descend'); loc = loc(1:NumTrials*4); %Because each trials = 4 spikes

SoundPeaksLoc = idx(loc);
Y_line = repmat([min(audioData) max(audioData)],[length(SoundPeaksLoc) 1]);

figure;
plot(t,audioData);hold on;
line([t(SoundPeaksLoc) t(SoundPeaksLoc)]',Y_line','LineWidth',2,'LineStyle','--')

beeps = t(SoundPeaksLoc); beeps = sort(beeps);
beep_up = beeps(1:2:end);
beep_down = beeps(2:2:end);

beep_time = beep_down - beep_up;

if sum(beep_time < 0.7*t_beep) > 0
    loc = unique(ceil(find(beep_time < 0.7*t_beep)/2));
    display(['Faulty beep time at ' mat2str(loc) ' trials; Redo current participant'])
    
    for i = 1:length(loc)
        sessionData.rawData_tr(loc(i)).info.excludeTrial = 1;
        sessionData.rawData_tr(loc(i)).info.excludeTrialExplanation = [sessionData.rawData_tr(loc(i)).info.excludeTrialExplanation '; Faulty beep time'];
    end
end

beep_mean = (beep_up + beep_down)/2;

for i = 1:NumTrials
    if ~sessionData.rawData_tr(i).info.excludeTrial
        sessionData.rawData_tr(i).ETG.tr_Start = beep_mean(2*i - 1) - 0.5*t_beep;
        sessionData.rawData_tr(i).ETG.tr_Stop = beep_mean(2*i) - 0.5*t_beep;
    else
        sessionData.rawData_tr(i).ETG.tr_Start = NaN;
        sessionData.rawData_tr(i).ETG.tr_Stop = NaN;
    end
end

end