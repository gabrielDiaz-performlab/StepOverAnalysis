% COMPUTE_FIX_VT fixation finder that uses velocity threshold (VT)
%   FIX = COMPUTE_FIX_VT(T, VEL, VEL_THRESH, T_THRESH) returns the
%   fixations associated with (T, VEL) in FIX
%
%   T is time vector, VEL is velocity vector, VEL_THRESH is the
%   minimum velocity required for fixation, and T_THRESH is the
%   minimum time required for fixation
%
%   NOTE: clumping or track loss is not handled here. for clumping,
%   see COMPUTE_CLUMPED_FIX

% $Id: compute_fix_vt.m,v 1.4 2004/04/20 20:44:25 sullivan Exp $
% pskirko 7.23.01

function [fix, fix_frames] = compute_fix_vt(t, vel, vel_thresh, t_thresh)

fix = []; idx = 1;

n = length(vel); %feature = zeros(n,1);

t_start = -1;

for i=1:n
    
    v = vel(i);
    t_ = t(i);
    
    if( v < vel_thresh ) %begin new fixations
        
        if(t_start == -1) %start fixation
            t_start = t_;  % start time of this fix
            frame_i = i;  % start frame of this fix
        end
        
    else
        
        % above vel thresh.
        
        if(t_start ~= -1) %end fixation
            %fix = [fix; t_start t_];
            
            % If fix lasts for t_thresh ms or more, record it
            if(t_ - t_start > t_thresh)
                
                frame_f = i-1;  % end frame of this fix
                
                fix(idx, :) = [t_start t_];
                fix_frames(idx, :) = [frame_i frame_f];
                
                idx = idx + 1;
                
            end
            
            % end of fix
            t_start = -1;
            
        end
        
    end
end

return
