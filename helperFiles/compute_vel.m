%COMPUTE_VEL compute point-to-point velocities
%   VEL = COMPUTE_VEL(T, X) computes point-to-point velocities
%   based on time T and space X.  X is an n x ndim matrix, T is n x 
%   1. ndim refers to number of dimensions of the space data, ndim
%   >= 1.
%
%   This formula is time-efficient in that in involves no
%   for-loops, either for dimensionality, or for computing velocity. 
%
%   formula:
%   v_i = (x_i - x_(i-1))/(t_i - t_(i-1))
%   v_1 = 0; //the first record

% $Id: compute_vel.m,v 1.4 2004/04/20 20:44:25 sullivan Exp $
% pskirko 6.4.01

function vel = compute_vel(t, x) 


n = length(t);
ndim = size(x, 2);

x1 = [t, x];


x2 = x1;
x2(n,:) = []; % remove last row
x1(1,:) = []; % remove first row

x3 = (x1-x2)';

v = sqrt(sum(abs(x3(2:(1+ndim), :)).^2, 1))./x3(1,:);

v = [0, v]'; % 1st velocity is 0


%filter velocity
%v = filter_average( v , 1 );
%v = log( v );v = exp( v );
%v=filter_adaptive_smooth( v,1 );


%v = filter_average( v , 2 );
%v = filter_med( v,1 );
%v = filter_adaptive_smooth( v,1 );

vel = v;
return
