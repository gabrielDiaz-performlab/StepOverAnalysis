%BROWSER_CB browser callbacks
%   BROWSER_CB called by BROWSER

% $Id: browser_cb.m,v 1.8 2003/01/20 19:35:06 sullivan Exp $
% pskirko 6.21.01

% Note: get rid of "slow mode" stuff. Used to solve thrashing
% problem that no longer exists

function browser_cb(id)

global h_fig;


[h_cbo, h_fig] = gcbo;

if(strcmp(id, 'prev'))
    
  ts = get_timeplot_struct;
  t_step = ts.t_step;
  as = get_curr_axes_struct;
  as.xlim = as.xlim - t_step;

 
  if(as.xlim(1) < ts.t(1))
    return;
  end
  
  
  set_curr_axes_struct(as);
  
  slow_mode = my_get('br_slow_mode');
  
  if(slow_mode)
    browser_plot;
  else
    xlim(as.xlim);
  end
  
  x = get(gca,'XTick');
  set(gca,'XTickLabel',sprintf('%3.0f|',x))
  
elseif(strcmp(id, 'next'))
  ts = get_timeplot_struct;
  t_step = ts.t_step;
  as = get_curr_axes_struct;
  as.xlim = as.xlim + t_step;

  if(as.xlim(2) > ts.t(length(ts.t)))
    return;
  end
  
  set_curr_axes_struct(as);
  
  slow_mode = my_get('br_slow_mode');
  
  if(slow_mode)
    browser_plot;
  else
    xlim(as.xlim);
  end
    
  x = get(gca,'XTick');
  set(gca,'XTickLabel',sprintf('%3.0f|',x))
  
elseif(strcmp(id, 'init'))
   % copy axes struct
   as = get_timeplot_axes_struct;
   set_curr_axes_struct(copy_axes_struct(as));

   % make time lookup table
   ts = get_timeplot_struct;
   t = ts.t;
   t_step = ts.t_step; 
   t_max = t(length(t));
   
   t_lookup = 0:t_step:t_max;
   t_lookup = [t_lookup (max(t_lookup)+t_step)];
   my_set('br_t_lookup', t_lookup);
   
   x = get(gca,'XTick');
   set(gca,'XTickLabel',sprintf('%3.0f|',x))
  
   check_for_slow_mode;
   browser_plot;
   
elseif(strcmp(id, 'jump'))
    
    answer = inputdlg('enter new time (s):', 'jump to time', 1);
    
    if(~isempty(answer))
        new_t = str2num(answer{1});
        if(~isempty(new_t))
            ap = get_curr_axes_struct;
            
            t_range = get_t_range;
            if(new_t < t_range(1) | new_t > t_range(2))
                disp('illegal jump');
                return;
            end
            
            if(new_t < ap.xlim(1) | new_t > ap.xlim(2))
                
                new_t = lookup_t(new_t);
                width = ap.xlim(2) - ap.xlim(1);
                ap.xlim = [new_t (new_t+width)];
                set_curr_axes_struct(ap);
                xlim(ap.xlim);
            end
        end
    end
    
    x = get(gca,'xtick');
    set(gca,'xticklabel',sprintf('%3.0f|',x))
    
elseif(strcmp(id, 'TrialNum'))
    
    answer = inputdlg('enter new trial:', 'jump to trial', 1);
    
    if(isempty(answer))
        return
    end
    
    trialNum = str2num(answer{1});
    ts = get_timeplot_struct;
    bounceFrames_fr = ts.bounceFrames;
   
    if(trialNum >= numel(bounceFrames_fr) )
       beep
       display('Reached last trial')
       return;
    end
    
    new_t = lookup_t(ts.t(bounceFrames_fr(trialNum)-70));
    ap = get_curr_axes_struct;
    width = ap.xlim(2) - ap.xlim(1);
    ap.xlim = [new_t (new_t+width)];
    set_curr_axes_struct(ap);
    xlim(ap.xlim);
    
    x = get(gca,'xtick');
    set(gca,'xticklabel',sprintf('%3.0f|',x))
    
end

%**************************************************************
%*      browser_plot
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function browser_plot

global h_fig;

[h_cbo, h_fig] = gcbo;
figure(h_fig);
axes(my_find('br_axes')); hold on;

lh = []; lt = {}; idx =1;

ts = get_timeplot_struct;
%t_range = get_t_range;

slow_mode = my_get('br_slow_mode');
  as = get_curr_axes_struct;
if(slow_mode)

  t_range = as.xlim;
else
  t_range = get_t_range;
end

% fills
fill_structs = ts.fill_structs;
n = length(fill_structs);

for i=1:n
   fs = fill_structs{i};
   if(~isempty(fs.fill))
     %h = plot_fix(fs.fill, fs.ylim, fs.color, t_range);
     h = plot_fix(fs.fill, fs.ylim, fs.color, t_range);
     if(h ~= -1) % plot warn't empty
       lh = [lh h(1)];
       lt{idx} = fs.legend; idx = idx +1;
     end
   end
end

% plots
plot_structs = ts.plot_structs;
n = length(plot_structs);

for i=1:n
   ps = plot_structs{i};
   if(~isempty(ps.x))
     h = plot(ps.x(:,1), ps.x(:,2), ps.linespec);
     lh = [lh h];
     lt{idx} = ps.legend; idx = idx + 1;
   end
end

%as = get_curr_axes_struct;
%xlim(as.xlim); ylim(as.ylim);
xlim([as.xlim(1) as.xlim(end)]); 
ylim(as.ylim);

legend(lh, lt); 

x = get(gca,'XTick');
set(gca,'XTickLabel',sprintf('%3.0f|',x))

vline(ts.t(ts.bounceFrames),'g',3)


%%
%**************************************************************
%*      check_for_slow_mode
%*  
%*      sees if there are too many fixations (will thrash),
%*      if so, enters slow mode
%* 
%*      pskirko 6.21.01
%**************************************************************

function check_for_slow_mode

ts = get_timeplot_struct;
fs_list = ts.fill_structs;

n = length(fs_list);

tot_size = 0;
for i=1:n
  fs = fs_list{i};
  tot_size = tot_size + size(fs.fill,1); 
end

if(tot_size > 500) % slow mode
  my_set('br_slow_mode', 1);
else % fast mode
  my_set('br_slow_mode', 0);
end

my_set('br_slow_mode', 0); % HACK!

%**************************************************************
%*      copy_axes_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function as_out = copy_axes_struct(as_in)

as_out = new_axes_struct(as_in.xlim, as_in.ylim);


%**************************************************************
%*      get_curr_axes_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function as = get_curr_axes_struct

as = my_get('br_curr_axes_struct');


%**************************************************************
%*      get_timeplot_axes_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function as = get_timeplot_axes_struct

ts = my_get('br_timeplot_struct');
as = ts.axes_struct;


%**************************************************************
%*      get_timeplot_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function ts = get_timeplot_struct

ts = my_get('br_timeplot_struct');


%**************************************************************
%*      get_t_range
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function t_range = get_t_range

ts = get_timeplot_struct;
t = ts.t;
t_range = [min(t), max(t)];


%**************************************************************
%*      lookup_t
%*  
%*      returns t from lookup that is closest (floor) to key
%* 
%*      pskirko 6.21.01
%**************************************************************

function t = lookup_t(key)

if(key <=0)
  t = 0;
  return;
end

t_lookup = my_get('br_t_lookup');
t_idx = max(find(t_lookup < key));

if(t_idx ~= 1)
t_idx = t_idx - 1;  
end

t = t_lookup(t_idx);


%**************************************************************
%*      my_find
%*  
%*      findobj shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function h = my_find(tag)

global h_fig;

h = findobj(h_fig, 'Tag', tag);


%**************************************************************
%*      my_get
%*  
%*      getappdata shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function val = my_get(key)

global h_fig;

val = getappdata(h_fig, key);


%**************************************************************
%*      my_set
%*  
%*      setappdata shortcut
%* 
%*      pskirko 6.21.01
%**************************************************************

function my_set(key, val)

global h_fig;

setappdata(h_fig, key, val);

%**************************************************************
%*      set_curr_axes_struct
%*  
%*      
%* 
%*      pskirko 6.21.01
%**************************************************************

function set_curr_axes_struct(as)

my_set('br_curr_axes_struct', as);