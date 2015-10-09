%NEW_AXES_STRUCT initialize axes struct
%   AS = NEW_AXES_STRUCT initializes the axes struct.
%   See the .m for the parameters needed in the function call.
%
%   An axes structs represents axes formatting for a variety of
%   plots, like timeplots, pupilplots, and eyeplots.
%
%   Fields:
%
%          - xlim
%               type: 1 x 2 matrix; e.g. xlim = [-1, 1];
%               x limits
%          - ylim
%               type: 1 x 2 matrix; e.g. ylim = [-1, 1];
%               specifies the width and placement of this fill
%               y limits

% $Id: new_axes_struct.m,v 1.2 2001/08/15 19:26:10 pskirko Exp $
% pskirko 8.15.01

function as = new_axes_struct(x_lim, y_lim)

if nargin == 0
  x_lim = [];
  y_lim = [];
end

as = struct('xlim', x_lim, 'ylim', y_lim);
