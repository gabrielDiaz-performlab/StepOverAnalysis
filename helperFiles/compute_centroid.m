%COMPUTE_CENTROID
%   CENTROID = COMPUTE_CENTROID(fixMS_idx_onOff, T, X) computes the centroids
%   of the fixations in fixMS_idx_onOff by using the spatial information in X.
%
%   The centroid formula is the mean of all points within the
%   fixation's time region

% $Id: compute_centroid.m,v 1.3 2003/01/20 19:35:06 sullivan Exp $
% pskirko 8.16.01

function [centroid, centroid_frames]= compute_centroid(fixMS_idx_onOff, fix_frames, t, x)

if(isempty(fixMS_idx_onOff))
    centroid = [];
    centroid_frames = [];
    return;
end

n = size(fixMS_idx_onOff, 1);
m = size(x,2);

centroid = zeros(n, m);

for i=1:n %for each fixation
    
    t_start = fixMS_idx_onOff(i,1);
    t_end = fixMS_idx_onOff(i,2);
    
    t_startFr = t(fix_frames(i,1));
    t_endFr = t(fix_frames(i,2));
    
    tmp = find(t >= t_start & t <= t_end);
    
    if(~isempty(tmp))
        centroid(i,:) = mean(x(tmp, :), 1);
    else
        centroid(i,:) = zeros(1, m);
    end
    
    tmp2= find(t >= t_startFr & t <= t_endFr);
    
    if(~isempty(tmp2))
        centroid_frames(i,:) = mean(x(tmp2, :), 1);
    else
        centroid_frames(i,:) = zeros(1, m);
    end
    
end
