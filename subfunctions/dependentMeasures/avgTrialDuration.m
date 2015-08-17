function [sessionData] = avgTrialDuration(sessionData)
%avgCOMVelocity calculates the average velocity of the center of mass of
%the subject (as determined by findCOM.m). 
%Fix: UNITS of velocity to m/second instead of m/frame.


%%
for trIdx = 1:sessionData.expInfo.numTrials
    
    timeElapsed_fr = sessionData.rawData_tr(trIdx).info.sysTime_fr - sessionData.rawData_tr(trIdx).info.sysTime_fr(1);
    sessionData.rawData_tr(trIdx).trialDuration = timeElapsed_fr(end);

end

sessionData.expInfo.meanTrialDuration = mean([sessionData.rawData_tr.trialDuration]);

