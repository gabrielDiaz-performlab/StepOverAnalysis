%NEW_TIMEPLOT_STRUCT initialize timeplot struct
%   TS = NEW_TIMEPLOT_STRUCT initializes the timeplot struct.
%   See the .m for the parameters needed in the function call.
%
%   A timeplot is used by both browser and eyeviz to represent
%   plots with time as the horizontal axis.  A velocity plot is 
%   a good example.  A fixation plot is another one.
%
%          - axes_struct
%               type: single struct
%               see NEW_AXES_STRUCT
%          - fill_structs
%               type: doubly-nested cell array vector (e.g, {{fs1, fs2}})
%               see NEW_FILL_STRUCT
%          - plot_structs
%               type: doubly-nested cell array vector
%               see NEW_PLOT_STRUCT
%          - t
%               type: column vector
%               time values
%          - t_step
%               type: scalar time value
%               used by browser and eyeviz to control step amount.
%               in browser, when you click 'next' or 'prev', xlims
%               move t_step to right or left, respectively.
%               in eyeviz, when you move off the edge of current
%               timeplot (by clicking or by hitting 'next' or
%               'prev' enough times), xlims do same thing.
%               Notice the difference: in browser, every click moves
%               the xlims, but in eyeviz, clicks sometimes just
%               move the internal time marker (the vertical red
%               line); xlims only change when this marker goes "off 
%               the screen"

% $Id: new_timeplot_struct.m,v 1.2 2001/08/15 19:26:20 pskirko Exp $
% pskirko 8.15.01

function ts = new_timeplot_struct(t, t_step, plot_structs, ...
				  fill_structs, axes_struct)

ts = struct('t', t, 'plot_structs', plot_structs,...
	    'fill_structs', fill_structs,...
	    'axes_struct', axes_struct, 't_step', ...
	    t_step, 'axes_params', axes_struct);

% axes_params is there for backwards compatibility. should be
% removed! (oops)