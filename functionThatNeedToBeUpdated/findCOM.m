%Carrie Griffo, Andrew Smith
%Modified 2/23/15

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
size(tempVar)
sessionData.COM  = tempVar;

end