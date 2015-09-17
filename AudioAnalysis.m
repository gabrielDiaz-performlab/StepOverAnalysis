clear all
close all
clc

%signal = Audio data
%Fs = Samples / second
%Tmax = Length of the audio file

[signal,Fs] = audioread('F:\Eyetracking\CheckAudio 11-09-2015 16 24 13\Rakshit-[4c4a482c-75e0-4e72-a9a1-3b2f1f2eef15]\Rakshit-1-recording.wav');

N = length(signal);
Tmax = N/Fs;
dT = 1/Fs;

t = (0:dT:Tmax - dT)';

dF = Fs/N;                        % hertz
f = -Fs/2:dF:Fs/2 - dF; f = f';         % hertz

f_signal = fftshift(fft(signal));
f_signal = abs(f_signal)/N;

[~,ind,~,p] = findpeaks(f_signal,'SortStr','descend');
pts(:,1) = f(ind(1:2)); pts(:,2) = f_signal(ind(1:2));

figure;
plot(f,f_signal); hold on
plot(pts(:,1),pts(:,2),'rx')
xlabel('Frequency (in hertz)');
title('Magnitude Response');




