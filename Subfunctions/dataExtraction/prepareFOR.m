function dataOutXYZ = prepareFOR(dataInXZY,subIsWalkingUpAxis)

loadParameters

if( subIsWalkingUpAxis )
    standingBoxPosOnAxis = obsPositionIfWalkingUp;
else
    standingBoxPosOnAxis = obsPositionIfWalkingDown;
end

% Data can be of the format data_fr_mkr_XYZ or RightFoot_fr_XYZ
if( length(size(dataInXZY)) > 2 )
    
    % data_fr_mkr_XYZ
    numMarkers = size(dataInXZY,2);
   
    
    for mIdx = 1:numMarkers
        
        % In matlab coordinates, Z is up
        %dataOutXYZ(:,mIdx,:) = squeeze(dataInXZY(:,mIdx,[1 3 2]));
        dataOutXYZ(:,mIdx,:) = squeeze(dataInXZY(:,mIdx,:));
        
        if(subIsWalkingUpAxis)
           % Subtract box position
           dataOutXYZ(:,mIdx,:) = [dataOutXYZ(:,mIdx,1), (dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];
        else
            % Subtract box position and flip walking direction
           dataOutXYZ(:,mIdx,:) = [-dataOutXYZ(:,mIdx,1), -(dataOutXYZ(:,mIdx,2) - standingBoxPosOnAxis),dataOutXYZ(:,mIdx,3)];
        end
        
    end
    
else
    
    % In matlab coordinates, Z is up
    %dataOutXYZ = dataInXZY(:,[1 3 2]);
    dataOutXYZ = dataInXZY;
    
    if(subIsWalkingUpAxis)
        % Subtract box position
        dataOutXYZ = [dataOutXYZ(:,1), (dataOutXYZ(:,2) - standingBoxPosOnAxis),dataOutXYZ(:,3)];
    else
        % Subtract box position and flip walking direction
        dataOutXYZ = [-dataOutXYZ(:,1), -(dataOutXYZ(:,2) - standingBoxPosOnAxis),dataOutXYZ(:,3)];
    end
    
end

