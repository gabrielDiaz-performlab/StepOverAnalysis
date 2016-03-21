%0FIX_FINDER_VT comprehensive fixation finder
%  [fixMS_idx_onOff, fix_frames] = FIX_FINDER_VT is a fixation finder built around the velocity
%  threshold fixation algorithm, and also corrects for track loss
%  and performs clumping
%
%  This is the process:
%
%  1) identify track losses
%     uses the inputs PUPIL and TL_PUPIL_THRESH to correct for
%     track losses.  see the function CORRECT_VEL_FOR_TRACK_LOSS
%     for more details.  if TL_PUPIL_THRESH is [], this step is
%     skipped.
%
%  2) compute fixations
%     uses the inputs VT_VEL_THRESH to compute 
%     fixations.  see the function COMPUTE_FIX_VT for more details
%     (this function will be passed in 0 for its t_thresh b/c
%     removing short fixations will be performed after clumping).
%     both inputs must be specified, there are no defaults.
%
%  3) clump
%     uses the inputs CLUMP_SPACE_THRESH and CLUMP_T_THRESH to perform
%     clumping. see the function COMPUTE_CLUMPED_FIX for more details.
%     if CLUMP_SPACE_THRESH or CLUMP_T_THRESH are [], this step is
%     skipped
%
%  4) remove short fixations
%     uses the input VT_T_THRESH to remove short fixations. see the 
%     function REMOVE_SHORT_FIXATIONS for more details. this
%     parameter must be specified

% $Id: fix_finder_vt.m,v 1.6 2003/01/27 17:31:44 sullivan Exp $
% pskirko 8.16.01

function [fixMS_idx_onOff, fix_frames] = fix_finder_vt(t, ...
    xy, ...
    vel, ...
    clump_space_thresh, ...
    clump_t_thresh, ...
    t_thresh, ...
    v_thresh)


%%
% compute fixMS_idx_onOff


[fixMS_idx_onOff,  fix_frames] = compute_fix_vt(t, vel, v_thresh, t_thresh);

% %clump fixations
if(~isempty(clump_space_thresh) && ~isempty(clump_t_thresh))

    [fixMS_idx_onOff, fix_frames] = compute_clumped_fix(fixMS_idx_onOff, fix_frames, t, xy, ...
			    clump_space_thresh, clump_t_thresh);
            
end

% remove short fixations
[fixMS_idx_onOff, fix_frames] = remove_short_fixations(fixMS_idx_onOff, fix_frames, t_thresh, t);

% %find average x,y position and place in Eye in head Angle
%fix_frames = average_pos(fix_frames, x);



