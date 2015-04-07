%Carrie Griffo, Andrew Smith
%Modified 3/29/15

% This is a placeholder function that calculates the center of mass form
% motion capture data.

% This currently relies on a set of markers placed at the spine
% In the future, this will rely on whole-body motion capture data

function [sessionData] = findCOM(sessionData, trIdx)
%findCOM calculates the COM for all frames in the data set.
%Output COM has dimensions [#frames, 3]

rawTrialStruct = sessionData.rawData_tr(trIdx);

spine = rawTrialStruct.spine_fr_mkr_XYZ;

for idx = 1:length(spine)
    averageX(idx) = mean(spine(idx,:,1));
    averageY(idx) = mean(spine(idx,:,2));
    averageZ(idx) = mean(spine(idx,:,3));
end

tempVar = [averageX; averageY; averageZ];
sessionData.processedData_tr(trIdx).COM_fr_XYZ  = tempVar';

end