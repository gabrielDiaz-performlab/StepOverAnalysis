
close all


% saccStruct    = new_fill_struct( pursAllID_idx_onOff,  [0 5], [ 0 0 .7] , 'Pursuit');
% fsFix       = new_fill_struct( saccAllID_idx_onOff,  [5 10], [ 0.7 0 0 ] , 'Saccade');
% pursStruct  = new_fill_struct( fixAllID_idx_onOff,  [10 15], [ 0 .7 0 ] , 'Fixation');

%saccStruct    = new_fill_struct( saccAllID_idx_onOff,  [0 5], [ 0 0 .7] , 'Saccade');
fsFix       = new_fill_struct( fixAllID_idx_onOff,  [5 10], [ 0.7 0 0 ] , 'Fixation');
%pursStruct  = new_fill_struct( pursAllID_idx_onOff,  [10 15], [ 0 .7 0 ] , 'Fixation');

ps      = new_plot_struct([movieID_fr gazeVelDegsSec_fr' ], '-k' , ['eiw', ' vel']);
ps2      = new_plot_struct([movieID_fr rawGazeVelDegsSec_fr' ], '-g' , ['raw eiw', ' vel']);
as      = new_axes_struct([movieID_fr(1) movieID_fr(60*2)], [0, 300]);
%ts      = new_timeplot_struct(movieID_fr, 5, {{ps}}, {{fsFix,pursStruct,saccStruct}}, as);
%ts      = new_timeplot_struct(movieID_fr, 5, {{ps}}, {{fsFix,saccStruct}}, as);
ts      = new_timeplot_struct(movieID_fr, 5, {{ps ps2}}, {{fsFix}}, as);


ts.bounceFrames = bounceFrame_tr;


browser(ts);

%bounceFrame_tr


figure(1)
set(gcf,'Units','Normalized','Position',[0.0130952380952381 0.392023346303502 0.976785714285714 0.496108949416342]);
grid minor
grid on
vline(  movieID_fr(find(eyeQuality==2)),'r',2);
vline(  bounceFrame_tr ,'b',2);
set(gcf,'Renderer','zbuffer')
%x = get(gca,'XTick');
%set(gca,'XTickLabel',sprintf('%3.0f|',x))

dcmObj = datacursormode(1);
set(dcmObj,'UpdateFcn',@dataTip_callback_racquetball)
datacursormode on

