display('* identifying fixations...')


time =  eyeDataTime_fr(1:numel(gazeVelDegsSec_fr)).*1000;

%%% fix finder finds fixations!

[fix, fixAllFr_idx_onOff] = fix_finder_vt(  time, ...
    [eiwFiltDegsX_fr, eiwFiltDegsY_fr],...
    gazeVelDegsSec_fr, ...
    clump_space_thresh, ...
    clump_t_thresh, ...
    t_thresh, ...
    vel_thresh);


fixALLStartFr_idx = fixAllFr_idx_onOff(:,1);
fixALLEndFr_idx = fixAllFr_idx_onOff(:,2);

%dlmwrite(['data/eyedata/' moviename '_fix.txt'], [fix_id fix_id],'precision','%10.0f','delimiter', '\t');
%display('* fixations written to file.')

% movieFrames_fr = movieID_fr(1:numel(gazeVelDegsSec_fr));
% 
% for i = 1:size(fix_frames,1)
%     fix_ID(i,1) = movieFrames_fr(fix_frames(i,1));
%     fix_ID(i,2) = movieFrames_fr(fix_frames(i,2));
% end