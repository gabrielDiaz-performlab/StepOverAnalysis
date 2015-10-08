function [peakvals, peaklocs] = DetectPeaks(filt_audioData, NumTrials)

f = ones(5000,1); f = f/sum(f);
X = conv(filt_audioData,f,'same');
Y = hilbert(X);

% figure;
% plot(filt_audioData,'--k'); hold on; plot(abs(Y),'-r')

[heights,idx,~,p] = findpeaks(abs(Y));
heights = heights/max(heights); p = p/max(p);
Param_Spike = heights.*p; 
[~,loc] = sort(Param_Spike, 'descend'); loc = loc(1:NumTrials*2); %Because each trials = 4 spikes

peaklocs = idx(loc);
peakvals = filt_audioData(peaklocs);
end