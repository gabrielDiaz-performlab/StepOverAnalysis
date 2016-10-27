function sessionData = getTimeStamps(sessionData, ETG_T)

absTime_ETG = ETG_T.TimeOfDay_h_m_s_ms_;
absTime_ETG = cell2mat(absTime_ETG);
temp = zeros(size(absTime_ETG,1), 1);

for i = 1:length(absTime_ETG)
    temp1 = sscanf(absTime_ETG(i, :), '%f:%f:%f:%f');
    temp(i) = temp1(1)*60*60 + temp1(2)*60 + temp1(3) + temp1(4)/1000;
end

absTime_ETG = temp;



end