%BROWSER simple eye data visualizer
%   BROWSER(TS) runs the 'browser' visualizer, and takes a timeplot 
%   struct TS as a parameter (help NEW_TIMEPLOT_STRUCT for more info).

% $Id: browser.m,v 1.4 2001/08/15 16:25:17 pskirko Exp $
% pskirko 8.14.01

function browser(timeplot_struct)

h = figure;
set(h, 'Tag', 'br_figure',  'Renderer', 'painters', 'DoubleBuffer', ...
       'on');

setappdata(h, 'br_timeplot_struct', timeplot_struct);

% axes
axes('Position', [0.06 0.10 0.92 0.78], 'Tag', 'br_axes', ...
     'CreateFcn', 'browser_cb(''init'')', 'NextPlot', ...
     'replacechildren');

% prev button
uicontrol(h, 'Style', 'pushbutton', ...
	  'Callback', 'browser_cb(''prev'')', ...
	  'Units', 'normalized', ...
	  'Position', [0.02 0.90 0.08 0.08], ...
	  'String', 'prev', ...
          'Tag', 'br_prev');

% next button
uicontrol(h, 'Style', 'pushbutton', ...
	  'Callback', 'browser_cb(''next'')', ...
	  'Units', 'normalized', ...
	  'Position', [0.10 0.90 0.08 0.08], ...
	  'String', 'next', ...
          'Tag', 'br_next');

% jump
uicontrol(h, 'Style', 'pushbutton', ...
	  'Callback', 'browser_cb(''jump'')', ...
	  'Units', 'normalized', ...
	  'Position', [0.18 0.90 0.08 0.08], ...
	  'String', 'jump', ...
          'Tag', 'br_jump');
      
      % jump
uicontrol(h, 'Style', 'pushbutton', ...
	  'Callback', 'browser_cb(''TrialNum'')', ...
	  'Units', 'normalized', ...
	  'Position', [0.26 0.90 0.08 0.08], ...
	  'String', 'TrialNum', ...
          'Tag', 'br_TrialNum');
