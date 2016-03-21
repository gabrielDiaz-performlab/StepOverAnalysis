%PLOT_FIX plots "fill struct" data
%   H = PLOT_FIX(FILL, YLIM, COLOR, T_RANGE) should be called 
%   PLOT_FILL; anyways, it plots what I call "fill data"; fixations
%   are the best example.  A fill plot has fixed y thickness and
%   placement, and only varies in the x axis.  Each fill element is 
%   thus a rectangle.
%
%   FILL specifies the fill data, a 2 x 1 matrix where each row is
%   a fill element.  YLIM consists of [YMIN, YMAX] and specifies
%   the width and placement of each rectangle/element w.r.t the
%   y-axis.  COLOR is a Matlab Colorspec specifying the
%   color. T_RANGE is a [T_MIN, T_MAX]--- only fills falling within 
%   this "time range" are drawn (to disable pass in [-Inf, Inf] or
%   something similar).
%
%   PLOT_FIX is time-efficient, it involves no for-loops.  The
%   tradeoff of course is more space.
%
%   If FIX is empty (suppose T_RANGE is [0, 0]) nothing is drawn
%   and -1 is returned.

% $Id: plot_fix.m,v 1.4 2003/01/20 19:35:08 sullivan Exp $
% pskirko 8.16.01

function h = plot_fix(fix, y_lim, color, t_range)

t_min = t_range(1);
t_max = t_range(2);
   
% only look at data pts where:
% - t_start < t_max AND
% - t_end > t_min

cond1 = fix(:,1) <= t_max;
cond2 = fix(:,2) >= t_min;

fix2 = fix(find(cond1 & cond2), :);

clear cond1 cond2;

if(isempty(fix2))
  h = -1;
  return;
end

n = size(fix2, 1);

y_min = y_lim(1);
y_max = y_lim(2);

    
x = [fix2'; [fix2(:,2) fix2(:,1)]'];
y = [y_min y_min y_max y_max]';

h = fill(x, y, color);
%size(h)                        111 1




%global state;
%global t;
%%cycle through identifier
%m = length(t);
%for i=1:m    
%    if state(i,1) == 7
%        x = [t(i,1)-7   t(i,1)+7   t(i,1)+7   t(i,1)-7];
%        y = [0; 0; 49; 49];
%        h = patch(x, y,[0.6 1 0],'EdgeColor', 'none');
%    elseif (state(i,1) >= 1) & (state(i,1) <= 5)
%        x = [t(i,1)-10   t(i,1)+10   t(i,1)+10   t(i,1)-10];
%        y = [0; 0; 10; 10];
%        h = patch(x, y,[0.2 0.6 0],'EdgeColor', 'none');
%    end
%end
