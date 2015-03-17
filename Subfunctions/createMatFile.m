function createMatFile(structHandler, textFileName)

    fieldNames = fieldnames(structHandler{1,1});
    numberOfLines = numel(fieldNames);

    collision_XYZ = zeros(numberOfLines, 3);

    for i = 1:numberOfLines

      %% ============= Frame Time ==================
      %% ===========================================

      currentLine = structHandler{1,1}.(fieldNames{i});
      refIdx = findstr( currentLine, 'frameTime' );
      tempVar = '';
      currentIdx = refIdx + 10;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      frameTime(i) =   str2num( tempVar );

      %% ============= Event Flag ==================
      %% ===========================================

      refIdx = findstr( currentLine, 'eventFlag' );
      tempVar = '';
      currentIdx = refIdx + 10;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      eventFlag(i) =   str2num( tempVar );

      %% =========== Collision Location ============
      %  Commented out, Because Collision is not being stored correctly yet
      %% ===========================================

%       refIdx = findstr( currentLine, 'Collision Location [' );
%       tempVar = '';
%       currentIdx = refIdx + 21;
%       while( currentLine( currentIdx ) ~= ' ' )
%           tempVar = [tempVar currentLine( currentIdx )];
%           currentIdx = currentIdx + 1;
%       end
%       CollisionX =   str2num( tempVar );
% 
%       currentIdx = currentIdx + 1;
%       tempVar = ''; 
%       while( currentLine( currentIdx ) ~= ' ' )
%           tempVar = [tempVar currentLine( currentIdx )];
%           currentIdx = currentIdx + 1;
%       end
%       CollisionY =   str2num( tempVar );
% 
%       currentIdx = currentIdx + 1;
%       tempVar = ''; 
%       while( currentLine( currentIdx ) ~= ' ' )
%           tempVar = [tempVar currentLine( currentIdx )];
%           currentIdx = currentIdx + 1;
%       end
% 
%       CollisionZ =   str2num( tempVar );
% 
%       collision_XYZ(i,:) = [ CollisionX CollisionY CollisionZ ];

      %% ============= Trial Type ==================
      %% ===========================================  

      refIdx = findstr( currentLine, 'trialType' );
      tempVar = '';
      currentIdx = refIdx + 10;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      trialType(i) = str2num(tempVar(2));

      %% ============= Obstacle_XYZ ================
      %% ===========================================  

      refIdx = findstr( currentLine, 'Obstacle_XYZ' );
      tempVar = '';
      currentIdx = refIdx + 13;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      ObstacleX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      ObstacleY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      ObstacleZ =   str2num( tempVar );

      obstacle_XYZ(i,:) = [ ObstacleX ObstacleY  ObstacleZ ];

      %% ============= Shutter Glass ===============
      %% ===========================================  

      refIdx = findstr( currentLine, 'G0 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      GZ =   str2num( tempVar );

      G0_XYZ(i,:) = [ GX GY GZ];

      refIdx = findstr( currentLine, 'G1 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      GZ =   str2num( tempVar );

      G1_XYZ(i,:) = [ GX GY GZ];


      refIdx = findstr( currentLine, 'G2 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      GZ =   str2num( tempVar );

      G2_XYZ(i,:) = [ GX GY GZ];

      refIdx = findstr( currentLine, 'G3 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      GZ =   str2num( tempVar );

      G3_XYZ(i,:) = [ GX GY GZ];

      refIdx = findstr( currentLine, 'G4 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      GY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      GZ =   str2num( tempVar );

      G4_XYZ(i,:) = [ GX GY GZ];  

      %% ============= Right_Foot_XYZ ==============
      %% ===========================================  

      refIdx = findstr( currentLine, 'R0 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      RZ =   str2num( tempVar );

      R0_XYZ(i,:) = [ RX RY RZ];

      refIdx = findstr( currentLine, 'R1 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      RZ =   str2num( tempVar );

      R1_XYZ(i,:) = [ RX RY RZ];


      refIdx = findstr( currentLine, 'R2 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      RZ =   str2num( tempVar );

      R2_XYZ(i,:) = [ RX RY RZ];

      refIdx = findstr( currentLine, 'R3 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      RY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      RZ =   str2num( tempVar );

      R3_XYZ(i,:) = [ RX RY RZ];


      %% ============= Left_Foot_XYZ ==============
      %% ===========================================  

      refIdx = findstr( currentLine, 'L0 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      LZ =   str2num( tempVar );

      L0_XYZ(i,:) = [ LX LY LZ];

      refIdx = findstr( currentLine, 'L1 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      LZ =   str2num( tempVar );

      L1_XYZ(i,:) = [ LX LY LZ];


      refIdx = findstr( currentLine, 'L2 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      LZ =   str2num( tempVar );

      L2_XYZ(i,:) = [ LX LY LZ];

      refIdx = findstr( currentLine, 'L3 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      LY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      LZ =   str2num( tempVar );

      L3_XYZ(i,:) = [ LX LY LZ];

      %% ============== Spinal_XYZ =================
      %% ===========================================  

      refIdx = findstr( currentLine, 'S0 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      SZ =   str2num( tempVar );

      S0_XYZ(i,:) = [ SX SY SZ];

      refIdx = findstr( currentLine, 'S1 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      SZ =   str2num( tempVar );

      S1_XYZ(i,:) = [ SX SY SZ];


      refIdx = findstr( currentLine, 'S2 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      SZ =   str2num( tempVar );

      S2_XYZ(i,:) = [ SX SY SZ];

      refIdx = findstr( currentLine, 'S3 [' );
      tempVar = '';
      currentIdx = refIdx + 5;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SX =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      SY =   str2num( tempVar );

      currentIdx = currentIdx + 1;
      tempVar = ''; 
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end  
      SZ =   str2num( tempVar );

      S3_XYZ(i,:) = [ SX SY SZ];

    end
    
    trialType = trialType';
    frameTime = frameTime';
    size(frameTime);
    eventFlag = eventFlag';
    size(eventFlag);
    size(collision_XYZ);
    trialType = trialType';
    size(trialType);
    size(obstacle_XYZ);
    shutterGlass_XYZ = [G0_XYZ G1_XYZ G2_XYZ G3_XYZ G4_XYZ];
    size(shutterGlass_XYZ);
    rightFoot_XYZ = [R0_XYZ R1_XYZ R2_XYZ R3_XYZ];
    size(rightFoot_XYZ);
    leftFoot_XYZ = [L0_XYZ L1_XYZ L2_XYZ L3_XYZ];
    size(leftFoot_XYZ);
    spinal_XYZ = [S0_XYZ S1_XYZ S2_XYZ S3_XYZ];
    size(spinal_XYZ);
    
    fileName = [textFileName '.mat']
    save (fileName, 'frameTime','trialType','eventFlag', 'obstacle_XYZ','collision_XYZ','shutterGlass_XYZ','rightFoot_XYZ','leftFoot_XYZ','spinal_XYZ')
end

