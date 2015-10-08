%REMOVE_SHORT_FIXATIONS remove short fixations
%   FIX = REMOVE_SHORT_FIXATIONS(FIX_IN, T_THRESH) returns in FIX those
%   fixations from FIX_IN whose duration is not less than T_THRESH

% $Id: remove_short_fixations.m,v 1.2 2003/01/20 19:35:09 sullivan Exp $
% pskirko 8.16.01
%function fix = remove_short_fixations(fix_in, t_thresh)
function [fix, fix_frames] = remove_short_fixations(fix_in, fix_frames, t_thresh, time)

if(isempty(fix_in))
  fix = [];
  return;
end

dur = fix_in(:,2) - fix_in(:,1);
fix = fix_in(find(dur >= t_thresh), :);

dur = time(fix_frames(:,2)) - time(fix_frames(:,1));
fix_frames = fix_frames(find(dur >= t_thresh), :);