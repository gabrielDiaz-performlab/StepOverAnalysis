%% Carrie Griffo, Andrew Smith
% Modified 3/29/15

% This is a placeholder function that calculates the center of mass form
% motion capture data.

% This currently relies on a set of markers placed at the spine
% In the future, this will rely on whole-body motion capture data

function [sessionData] = findCOM(sessionData, trIdx)
%%
% findCOM calculates the COM for all frames in the data set.
% Output COM has dimensions [#frames, 3]

spine_fr_XYZ_mk = sessionData.processedData_tr(trIdx).spine.mkrPos_mIdx_Cfr_xyz;
spine_fr_XYZ_mk = cell2mat(permute(spine_fr_XYZ_mk,[3 2 1]));

for frIdx = 1:length(spine_fr_XYZ_mk)
    averageX_fr(frIdx) = mean(spine_fr_XYZ_mk(frIdx,1,:));
    averageY_fr(frIdx) = mean(spine_fr_XYZ_mk(frIdx,2,:));
    averageZ_fr(frIdx) = mean(spine_fr_XYZ_mk(frIdx,3,:));
end

tempVar = [averageX_fr; averageY_fr; averageZ_fr];
sessionData.processedData_tr(trIdx).COM_fr_XYZ  = tempVar';

end