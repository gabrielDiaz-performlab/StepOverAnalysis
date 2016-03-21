function [sessionData] = avgCOMVelocity(sessionData, trIdx)
%avgCOMVelocity calculates the average velocity of the center of mass of
%the subject (as determined by findCOM.m). 
%Fix: UNITS of velocity to m/second instead of m/frame.

COM_fr_XYZ = sessionData.processedData_tr(trIdx).COM_fr_XYZ;

%% Here's a more automated way to differentiate, and divide by frame duration
% The 0 0 0 padding reflects the fact that differentiating nuemrically will
% always produce a vector that is slightly smaller than the larger vector -1
COMVelocity_fr_XYZ = [0 0 0; diff(COM_fr_XYZ)] ./ sessionData.expInfo.meanFrameDur;

sessionData.dependentMeasures_tr(trIdx).avgCOMVelocity = COMVelocity_fr_XYZ;
 
end