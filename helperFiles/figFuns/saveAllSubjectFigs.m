clear all
close all

loadParameters

%for sIdx = 10:numIncluded
for sIdx = 1:numIncluded 
    subNum = includedSubs(sIdx);
    genFigsForSub(subNum);
    %saveFigures
    close all
end
