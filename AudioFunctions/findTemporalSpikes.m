function sessionData = findTemporalSpikes(sessionData, audioData, fAudio, Fs, dispData)

loadParameters

ch = input('Would you like to amplify the sound at 5Khz? Enter the amplification percent or else, press 0: ');

N = length(audioData);
Tmax = N/Fs;
dT = 1/Fs;

t = (0:dT:Tmax - dT)';

dF = Fs/N;                              % hertz
f = -Fs/2:dF:Fs/2 - dF; f = f';         % hertz

f_signal = fftshift(fft(audioData));

C = 250*dF;
notch_win = exp(-(f - fAudio).^2/(2*C^2)) + exp(-(f + fAudio).^2/(2*C^2));
notch_win = notch_win/max(notch_win);

if ch ~= 0
    C = 10*dF;
    amp_win = exp(-(f - fAudio).^2/(2*C^2)) + exp(-(f + fAudio).^2/(2*C^2));
    amp_win = amp_win/max(amp_win);
    amp_win = amp_win*(ch)/100 + 1;
    f_signal = f_signal.*amp_win;
end

f_filt_signal = f_signal.*notch_win;
filt_audioData = real(ifft(fftshift(f_filt_signal)));

if dispData == 1
    figure;
    subplot(2,2,1);plot(f,abs(f_signal));
    subplot(2,2,2);plot(f,abs(f_filt_signal))
    subplot(2,2,3);plot(t,audioData);
    subplot(2,2,4);plot(t,filt_audioData);
end

ch = input('Do you wish to doctor the Audio File? Select 2 points. 1 - YES, 0 - NO: ');

while ch
    figure;
    plot(t,audioData)
    
    [xlocs,~] = ginput(2);
    loc = t > xlocs(1) & t < xlocs(2);
    filt_audioData(loc) = 0;
    ch = input('Do you wish to further doctor the Audio File? Select 2 points. 1 - YES, 0 - NO');
end

filt_audioData = abs(filt_audioData);
filt_audioData = filt_audioData/max(filt_audioData);

[~, peaklocs] = DetectPeaks(filt_audioData, sessionData.expInfo.numTrials);

Y_line = repmat([min(filt_audioData) max(filt_audioData)],[length(peaklocs) 1]);

peaklocs = sort(peaklocs);

%% Filter out anomalies during data aquisition

if dispData == 1
    figure;
    plot(t,audioData);hold on;
    line([t(peaklocs) t(peaklocs)]',Y_line','LineWidth',2,'LineStyle','--')
    
    figure;
    plot(t,filt_audioData);hold on;
    line([t(peaklocs) t(peaklocs)]',Y_line','LineWidth',2,'LineStyle','--')
end

t_dur = t(peaklocs(2:2:end)) - t(peaklocs(1:2:end));
display(['Number of offending trails: ' num2str(sum(t_dur < 5 | t_dur > 7))])

ch = input('How many offending beeps do you wish to remove (must be even)? Enter 0 if none. ');

if ch ~= 0
    [xlocs, ~] = ginput(ch);
    beepsToRemove = zeros(1,length(xlocs));
    for i = 1:length(xlocs)
        [~, loc] = min(abs(t(peaklocs) - xlocs(i)));
        beepsToRemove(i) = loc;
    end   

    trialsToRemove = ceil(beepsToRemove(1:2:end)/2);

%% Remove trials which need to be deleted from Analysis 
    sessionData.expInfo.numTrials = sessionData.expInfo.numTrials - length(trialsToRemove);
    sessionData.rawData_tr(trialsToRemove) = [];
    peaklocs(beepsToRemove) = [];

end


%%
t_dur = t(peaklocs(2:2:end)) - t(peaklocs(1:2:end));

display(['Number of offending trails: ' num2str(sum(t_dur < 5 | t_dur > 7))])

beeplocs = t(peaklocs);
start_Beeps = beeplocs(1:2:end);
end_Beeps = beeplocs(2:2:end);

trialTime = end_Beeps - start_Beeps;
goodTrials = trialTime > 5 & trialTime < 7; 

for i = 1:sessionData.expInfo.numTrials
    if ~sessionData.rawData_tr(i).info.excludeTrial && goodTrials(i)
        sessionData.rawData_tr(i).ETG.tr_Start = start_Beeps(i) - 0.5*beep_Dur - 0.0220833333333333;
        sessionData.rawData_tr(i).ETG.tr_Stop = end_Beeps(i) + 0.5*beep_Dur - 0.0220833333333333;
    else
        sessionData.rawData_tr(i).info.excludeTrial = 1;
        sessionData.rawData_tr(i).ETG.tr_Start = NaN;
        sessionData.rawData_tr(i).ETG.tr_Stop = NaN;
        sessionData.rawData_tr(i).info.excludeTrialExplanation = ...
            [sessionData.rawData_tr(i).info.excludeTrialExplanation ', Extra long trial'];      
    end
end

end