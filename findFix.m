display('* identifying fixations...')



% Time must be converted into milliseconds
% timeStampMS_fr =  timestamp in MILLIseconds

% eiwFiltDegsX_fr = Gaze-in-world azimuth

% eiwFiltDegsX_fr = Gaze-in-world elevation

% gazeVelDegsSec_fr = gaze velocity in degrees per second

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% clump_space_thresh  and clump_t_thresh: 

% Fixations that are sepearated by less than clump_t_thresh millseconds and 
% clump_space_thresh visual degrees of one another 
% will be clumped / treated as 1 fixation

% clump_t_thresh = adacent fixations withing X millseconds of one another
% will be clumped / treated as 1 fixation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t_thresh = fixations must be longer than X milliseconds

% vel_thresh = fixations cannot exeed a velocity of X degs/sec (try 30/40)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% fix finder finds fixations! %%%%%%%%%%%%

timeStampMS_fr =  eyeDataTime_fr(1:numel(gazeVelDegsSec_fr)) * 1000;
 
[fix, fixAllFr_fixIdx_onOff] = fix_finder_vt( ... 
    timeStampMS_fr, ...
    [eiwFiltDegsX_fr, eiwFiltDegsY_fr],...
    gazeVelDegsSec_fr, ...
    clump_space_thresh, ...
    clump_t_thresh, ...
    t_thresh, ...
    vel_thresh);


%fixALLStartFr_idx = fixAllFr_fixIdx_onOff(:,1);
%fixALLEndFr_idx = fixAllFr_fixIdx_onOff(:,2);

