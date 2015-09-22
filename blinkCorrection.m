function op = blinkCorrection(ip, T)

loc = ip == 0;
loc = mean(loc,2); loc = loc ~= 0;

T1 = T; T1(loc) = [];
ip1 = ip; ip1(loc,:) = [];

op = interp1(T1,ip1,T);
end