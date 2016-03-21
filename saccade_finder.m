function loc_saccades = saccade_finder(angVel, angDisp, TS, plotOn)

common_slopes = zeros(1,length(angVel));
slope_saccades = zeros(1,length(angVel));

minSaccadeDur = 0.02; % in seconds
initialWin = round(minSaccadeDur/mean(diff(TS)));

loc = 1;
sacc_num = 1;

while loc < length(angVel) - initialWin

    dispWin = angDisp(loc:loc + initialWin); 
    velWin = angVel(loc:loc + initialWin);
    TSWin = TS(loc:loc + initialWin);
    
    slope = diff(dispWin)./diff(TSWin);
    m_slope = mean(slope);
    sigma_slope = std(slope);
    
    if m_slope == 0 || sigma_slope == 0 || isnan(m_slope) || isnan(sigma_slope)
        common_slopes(loc:loc + initialWin) = NaN;
        loc = loc + initialWin;
        continue
    end
    
    count = 1;
    missCount = 0;
    st = 1;
    while count < length(angVel) && missCount < initialWin && st < length(angVel)

       st = loc + initialWin + count - 1;
       m_temp = (angDisp(st) - angDisp(st - 1))/(TS(st) - TS(st - 1)); 
        
       if abs(m_temp - m_slope) < 50 % if the new mean is lesser than a STD from the current scheme, include it
            dispWin = [dispWin; angDisp(st)];
            TSWin = [TSWin; TS(st)];
            slope = diff(dispWin)./diff(TSWin);
            m_slope = mean(slope);
            sigma_slope = std(slope);
            
       else
           missCount = missCount + 1;
       end

        count = count + 1;
    end

    if missCount >= initialWin && missCount == count
        common_slopes(loc) = NaN;
        slope_saccades(loc) = NaN;
        loc = loc + 1;
        break 
    end
    
    common_slopes(loc:st) = sacc_num;
    slope_saccades(loc:st) = (dispWin(end) - dispWin(1))/(TSWin(end) - TSWin(1));
    slope_points(2*sacc_num - 1:2*sacc_num,:) = [TSWin(1) dispWin(1); TSWin(end) dispWin(end)];
    loc = st; 
    sacc_num = sacc_num + 1;
end

loc_saccades = slope_saccades > 220;

if plotOn == 1
%     figure;
%     plot(TS, angVel/max(angVel), 'r'); hold on
%     plot(TS, angDisp/max(angDisp), 'b');
%     plot(TS, common_slopes/max(common_slopes), 'k');hold off

    display(['The number lines fit: ' num2str(sacc_num)])
    
    figure;
    plot(TS, angVel, 'r'); hold on
    plot(TS, angDisp, 'b');
    plot(slope_points(:,1),slope_points(:,2),'k'); hold off
    
    figure;
    plot(TS, angVel, 'r'); hold on
    plot(TS, angDisp, 'b');
    plot(slope_points(:,1),slope_points(:,2),'k'); 
    plot(TS, 700*loc_saccades);hold off
end


end