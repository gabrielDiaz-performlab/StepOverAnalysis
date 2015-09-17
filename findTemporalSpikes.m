function sessionData = findTemporalSpikes(sessionData, audioData, fAudio, Fs, dispData)

N = length(audioData);
Tmax = N/Fs;
dT = 1/Fs;

t = (0:dT:Tmax - dT)';

dF = Fs/N;                              % hertz
f = -Fs/2:dF:Fs/2 - dF; f = f';         % hertz

f_signal = fftshift(fft(audioData));

idx = abs(f) > fAudio - 5 & abs(f) < fAudio + 5;

notch_Window = zeros(size(f_signal));
notch_Window(idx) = 1;

f_filt_signal = f_signal.*notch_Window;
filt_audioData = ifft(fftshift(f_filt_signal));

if dispData == 1
    figure;
    subplot(2,2,1);plot(f,abs(f_signal));
    subplot(2,2,2);plot(f,abs(f_filt_signal))
    subplot(2,2,3);plot(t,audioData);
    subplot(2,2,4);plot(t,filt_audioData);
    sound(filt_audioData,Fs)
end

keyboard

end