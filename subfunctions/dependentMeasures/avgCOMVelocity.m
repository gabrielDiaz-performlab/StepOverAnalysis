function [sessionData] = avgCOMVelocity(sessionData, trIdx)
%avgCOMVelocity calculates the average velocity of the center of mass of
%the subject (as determined by findCOM.m). 
%Fix: UNITS of velocity to m/second instead of m/frame.

rawTrialStruct = sessionData.rawData_tr(trIdx);
proTrialStruct = sessionData.processedData_tr(trIdx);

COM_fr_XYZ = sessionData.processedData_tr.COM_fr_XYZ;

%% This pushing isn't necessary.  
% %velocity = distance / time
% %First, "push" x locations forward/backward so the first starts at 0...
%  if COM_fr_XYZ(1) < 0
%     COM_X = COM_fr_XYZ(:,1) + min(COM_fr_XYZ(:,1));
%  else
%      COM_X = COM_fr_XYZ(:,1) + min(COM_fr_XYZ(:,1));
%  end

%% Here's a more automated way to differentiate, and divide by frame duration
% The 0 0 0 padding reflects the fact that differentiating nuemrically will
% always produce a vector that is slightly smaller than the larger vector -1
COMVelocity_fr_XYZ = [0 0 0; diff(COM_fr_XYZ,1)] ./ sessionData.expInfo.meanFrameDur;

%  vel = zeros(1,length(COM_X)).';
%  for idx = 2:length(COM_X)
%      vel(idx) = (COM_X(idx)-COM_X(idx-1))/frameTime;
%  end
%  
 sessionData.dependentMeasures_tr(trIdx).avgCOMVelocity = COMVelocity_fr_XYZ;
 
end