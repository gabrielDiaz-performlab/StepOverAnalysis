function dataOutXYZ = prepareFOR(dataInXYZ,subIsWalkingUpAxis)

loadParameters

if( subIsWalkingUpAxis )
    standingBoxPosOnAxis = obsPositionIfWalkingUp;
else
    standingBoxPosOnAxis = obsPositionIfWalkingDown;
end

% keyboard


% UP: dataOutXYZ(:,mIdx,:) = [dataOutXYZ(:,mIdx,1), (dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];
% DOWN: dataOutXYZ(:,mIdx,:) = [-dataOutXYZ(:,mIdx,1), -(dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];

if subIsWalkingUpAxis
    dataOutXYZ = [dataInXYZ(:,1), dataInXYZ(:,2) - standingBoxPosOnAxis, dataInXYZ(:,3)];
else
    dataOutXYZ = [-dataInXYZ(:,1), -(dataInXYZ(:,2) - standingBoxPosOnAxis), dataInXYZ(:,3)];
end

end

