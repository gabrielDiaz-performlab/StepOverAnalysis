function [sessionData] = avgCOMVelocity(sessionData, trIdx)
%avgCOMVelocity calculates the average velocity of the center of mass of
%the subject (as determined by findCOM.m). 
%Fix: UNITS of velocity to m/second instead of m/frame.

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);
frameTime = 1/60; %60 fps

try
    COM = sessionData.COM;
catch 
    COM = findCOM(sessionData,trIdx);
end

%velocity = distance / time
%First, "push" x locations forward/backward so the first starts at 0...
 if COM(1) < 0
    COM_X = COM(:,1) + min(COM(:,1));
 else
     COM_X = COM(:,1) + min(COM(:,1));
 end
 
 vel = zeros(1,length(COM_X)).';
 for idx = 2:length(COM_X)
     vel(idx) = (COM_X(idx)-COM_X(idx-1))/frameTime;
 end
 
 sessionData.processedData_tr(trIdx).avgCOMVelocity = vel;
 
end