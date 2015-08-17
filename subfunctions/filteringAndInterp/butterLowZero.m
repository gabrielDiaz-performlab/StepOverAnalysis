function [smoothedData] = butterLowZero( order, cutoff, sampleRate, x)

[B,A] = butter(order,cutoff/(sampleRate*0.5),'low');

smoothedData = filtfilt(B,A,x);
