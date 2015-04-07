function [sessionData] = avgTrialDuration(sessionData)
%avgCOMVelocity calculates the average velocity of the center of mass of
%the subject (as determined by findCOM.m). 
%Fix: UNITS of velocity to m/second instead of m/frame.


%%
for trIdx = 1:sessionData.expInfo.numTrials
    
    sessionData.rawData_tr(trIdx).timeElapsed_fr = ...
        sessionData.rawData_tr(trIdx).frameTime_fr - sessionData.rawData_tr(trIdx).frameTime_fr(1);
    
    sessionData.rawData_tr(trIdx).trialDuration = sessionData.rawData_tr(trIdx).timeElapsed_fr(end);

end

sessionData.expInfo.meanTrialDuration = mean([sessionData.rawData_tr.trialDuration]);

