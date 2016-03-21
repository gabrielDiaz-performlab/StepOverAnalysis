
close all


% saccStruct    = new_fill_struct( pursAllID_idx_onOff,  [0 5], [ 0 0 .7] , 'Pursuit');
% fsFix       = new_fill_struct( saccAllID_idx_onOff,  [5 10], [ 0.7 0 0 ] , 'Saccade');
% pursStruct  = new_fill_struct( fixAllID_idx_onOff,  [10 15], [ 0 .7 0 ] , 'Fixation');

%saccStruct    = new_fill_struct( saccAllID_idx_onOff,  [0 5], [ 0 0 .7] , 'Saccade');


fsFix       = new_fill_struct( [sceneTime_fr(fixAllFr_idx_onOff(:,1)) sceneTime_fr(fixAllFr_idx_onOff(:,2))],  [5 10], [ 0.7 0 0 ] , 'Fixation');
%pursStruct  = new_fill_struct( pursAllID_idx_onOff,  [10 15], [ 0 .7 0 ] , 'Fixation');

fs      = new_plot_struct([sceneTime_fr rawGazeVelDegsSec_fr], '-y' , ['eiw', ' vel']);
ps      = new_plot_struct([sceneTime_fr gazeVelDegsSec_fr], '-k' , ['eiw', ' vel']);
as      = new_axes_struct([sceneTime_fr(1) sceneTime_fr(60*3)], [0, 150]);
%ts      = new_timeplot_struct(movieID_fr, 5, {{ps}}, {{fsFix,pursStruct,saccStruct}}, as);
%ts      = new_timeplot_struct(movieID_fr, 5, {{ps}}, {{fsFix,saccStruct}}, as);
ts      = new_timeplot_struct(sceneTime_fr, 5, {{ps, fs}}, {{fsFix}}, as);


ts.bounceFrames = bounceFrame_tr;


browser(ts);

%bounceFrame_tr
%%

figure(1)
set(gcf,'Units','Normalized','Position',[0.0130952380952381 0.392023346303502 0.976785714285714 0.496108949416342]);
grid minor
grid on
vline(  sceneTime_fr(find(eyeQuality==2)),'r',2);
vline(  bounceFrame_tr ,'b',2);
set(gcf,'Renderer','zbuffer')
%x = get(gca,'XTick');
%set(gca,'XTickLabel',sprintf('%3.0f|',x))

dcmObj = datacursormode(1);
set(dcmObj,'UpdateFcn',@dataTip_callback_racquetball)
datacursormode on

