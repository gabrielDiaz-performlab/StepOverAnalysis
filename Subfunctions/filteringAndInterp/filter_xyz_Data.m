function out = filter_xyz_Data(in, f)
%% Rakshit Kothari
% Filters the data using the filter f
out = zeros(size(in));
[~,b,~] = size(in);
for i = 1:b
   out(:,i) = conv(in(:,i), f, 'same'); 
end
end