%NEW_PLOT_STRUCT initialize plot struct
%   PS = NEW_PLOT_STRUCT initializes the plot struct.
%   See the .m for the parameters needed in the function call.
%
%   A plot struct is one way of representing data in a timeplot
%   (see NEW_TIMEPLOT_STRUCT). Velocities are a good example.
%   Basically a plot struct is a time series.
%
%   Note: when I say plot struct I sometimes mean "the plot 
%   corresponding to data in a plot struct".  Beware.
%
%   Fields:
%
%          - linespec
%               type: Matlab LineSpec
%               line spec
%          - legend
%               type: text
%               text used in graph's legend
%          - x
%               type: n x ndim matrix. e.g. [1 2; 2 -1; 3 1; 4 -1] (ndim=2)
%               ndim is the dimensionality of the data.  time is
%               always included as the first column (this is
%               confusing since time is also stored in the timeplot
%               struct itself; however, i didn't want to assume all 
%               plots in the timeplot had the same time values, so
%               i kept it this way)

% $Id: new_plot_struct.m,v 1.2 2001/08/15 19:26:15 pskirko Exp $
% pskirko 8.15.01

function ps = new_plot_struct(x, linespec, legend)

ps = struct('x', x, 'linespec', linespec, 'legend', legend);
