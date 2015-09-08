function dataOutXYZ = prepareFOR(dataInXYZ,subIsWalkingUpAxis,standingBoxOffset_posZ,standingBoxOffset_negZ)

loadParameters

if( subIsWalkingUpAxis )
    standingBoxPosOnAxis = standingBoxOffset_negZ;
else
    standingBoxPosOnAxis = standingBoxOffset_posZ;
end

% UP: dataOutXYZ(:,mIdx,:) = [dataOutXYZ(:,mIdx,1), (dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];
% DOWN: dataOutXYZ(:,mIdx,:) = [-dataOutXYZ(:,mIdx,1), -(dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];

if subIsWalkingUpAxis
    dataOutXYZ = [dataInXYZ(:,1), dataInXYZ(:,2) - standingBoxPosOnAxis, dataInXYZ(:,3)];
else
    dataOutXYZ = [-dataInXYZ(:,1), -(dataInXYZ(:,2) - standingBoxPosOnAxis), dataInXYZ(:,3)];
end

end

