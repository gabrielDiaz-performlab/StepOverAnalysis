%NEW_FILL_STRUCT initialize fill struct
%   TS = NEW_FILL_STRUCT initializes the fill struct.
%   See the .m for the parameters needed in the function call.
%
%   A fill struct is one way of representing data in a timeplot
%   (see NEW_TIMEPLOT_STRUCT).  Fixations are a good example of a
%   fill struct.  Basically fill structs demarcate regions of time.
%   In a fixation, each plot "element" is a fixation, i.e. a
%   particular start and end time.  All such elements for one plot
%   are drawn with the same horizontal width and placement.
%
%   Note: when I say fill struct I sometimes mean "the plot 
%   corresponding to data in a fill struct".  Beware.
%
%   Fields:
%
%          - color
%               type: Matlab ColorSpec (I think)
%               its color
%          - editable
%               type: 0 or 1
%               default: 0
%               eyeviz allows you to visually edit fill structs
%               (most usually fixations).  0 disables, 1 enables.
%          - fill
%               type: n x 2 matrix
%               the fill data. each element represents a start and
%               end "time" (since time is always the horizontal
%               axis in current usage). example:
%               fill = [1 2; 3 5; 10 100; 1000 2000];
%          - legend
%               type: text
%               text used in graph's legend
%          - output_file
%               type: filename
%               if you make this fill struct editable, you need to 
%               specify an output file; I can't remember what
%               happens if you don't (I think it will ignore, not break)
%          - ylim
%               type: 1 x 2 matrix; e.g. ylim = [-1, 1];
%               specifies the width and placement of this fill
%               struct within the timeplot

% $Id: new_fill_struct.m,v 1.3 2001/08/15 19:26:13 pskirko Exp $
% pskirko 8.15.01

function fill_struct = new_fill_struct(fill, y_lim, color, legend)

fill_struct = struct('fill', fill, 'ylim', y_lim, 'color', color, ...
                     'legend', legend, 'editable', 0, 'output_file', ...
		     []);
