clear all
close all
clc

fAudio = 5000;
dispData = 1;
%signal = Audio data
%Fs = Samples / second
%Tmax = Length of the audio file

[audioData,Fs] = audioread('C:\Users\Rakshit\Documents\MATLAB\StepOverAnalysis\AudioFunctions\1-1-recording.wav');
[beep, ~] = audioread('C:\Users\Rakshit\Documents\MATLAB\StepOverAnalysis\AudioFunctions\beep_Spike.wav');

N = length(audioData);
Tmax = N/Fs;
dT = 1/Fs;

t = (0:dT:Tmax - dT)';

dF = Fs/N;                        % hertz
f = -Fs/2:dF:Fs/2 - dF; f = f';         % hertz

audioData(t<71.50 & t>70.85) = 0.04;

figure;
plot(t,audioData);xlabel('Time')

NumTrials = 30;

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

trialTime = end_Beeps - start_Beeps;
goodTrials = trialTime > 5.5 & trialTime < 7.5; 




