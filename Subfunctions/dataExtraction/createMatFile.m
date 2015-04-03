function createMatFile(structHandler, textFileDir, textFileName, matFileDir)

    fieldNames = fieldnames(structHandler{1,1});
    numberOfLines = numel(fieldNames);

    collision_XYZ = zeros(numberOfLines, 3);
    frameTime = zeros(numberOfLines, 1);
    trialType = zeros(numberOfLines, 1);
    eventFlag = zeros(numberOfLines, 1);
    obstacle_XYZ = zeros(numberOfLines, 3);
    
    legLengthCM = zeros(numberOfLines, 1);
    walkingDirection = zeros(numberOfLines, 1);
    blockNum = zeros(numberOfLines, 1);
    trialType = zeros(numberOfLines, 1);
    
    
    rightFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
    leftFootQUAT_fr_WXYZ = nan(numberOfLines, 4);
    
    G0_fr_XYZ = zeros(numberOfLines, 3);
    G1_fr_XYZ = zeros(numberOfLines, 3);
    G2_fr_XYZ = zeros(numberOfLines, 3);
    G3_fr_XYZ = zeros(numberOfLines, 3);
    G4_fr_XYZ = zeros(numberOfLines, 3);
    
    L0_fr_XYZ = zeros(numberOfLines, 3);
    L1_fr_XYZ = zeros(numberOfLines, 3);
    L2_fr_XYZ = zeros(numberOfLines, 3);
    L3_fr_XYZ = zeros(numberOfLines, 3);
    
    R0_fr_XYZ = zeros(numberOfLines, 3);
    R1_fr_XYZ = zeros(numberOfLines, 3);
    R2_fr_XYZ = zeros(numberOfLines, 3);
    R3_fr_XYZ = zeros(numberOfLines, 3);
    
    S0_fr_XYZ = zeros(numberOfLines, 3);
    S1_fr_XYZ = zeros(numberOfLines, 3);
    S2_fr_XYZ = zeros(numberOfLines, 3);
    S3_fr_XYZ = zeros(numberOfLines, 3);

    
    
    parfor i = 1:numberOfLines


      
      %% ============= Frame Time ==================
      %% ===========================================

      currentLine = structHandler{1,1}.(fieldNames{i});
      refIdx = strfind( currentLine, 'frameTime' );
      tempVar = '';
      currentIdx = refIdx + 10;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      frameTime(i) =   str2num( tempVar );
     
      
      
      %% ============= Event Flag ==================
      %% ===========================================

     
      eventFlag(i) = extractVarFromLine(currentLine, 'eventFlag', 1  );
      
      legLengthCM(i) = extractVarFromLine(currentLine, 'legLengthCM', 1  );
      walkingDirection(i) = extractVarFromLine(currentLine, 'WalkingDirection', 1  );
      blockNum(i) = extractVarFromLine(currentLine, 'blockNum', 1  );
      
      %% ============= Right foot quat =============
      %% ===========================================
      
      %%
      varName = 'RightFootQUAT_XYZW';
      numVals = 4;

      data_valIdx = extractVarFromLine(currentLine, varName, numVals  );
      rightFootQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
      
      
      
      %% ============= Left foot quat =============
      %% ===========================================
   
      varInName = 'LeftFootQUAT_XYZW';
      numVals = 4;
      data_valIdx = extractVarFromLine(currentLine, varName, numVals  );
      
      data_valIdx = extractVarFromLine(currentLine, varName, numVals  );
      leftFootQUAT_fr_WXYZ(i,:) = [ -data_valIdx(4) data_valIdx(1) data_valIdx(3) data_valIdx(2) ];
      
      
      %% =========== Collision Location ============
      %  Commented out, Because Collision is not being stored correctly yet
      %% ===========================================

        

      %% ============= Trial Type ==================
      %% ===========================================  

      refIdx = strfind( currentLine, 'trialType' );
      tempVar = '';
      currentIdx = refIdx + 10;
      while( currentLine( currentIdx ) ~= ' ' )
          tempVar = [tempVar currentLine( currentIdx )];
          currentIdx = currentIdx + 1;
      end
      trialType(i) = str2num(tempVar(2));

      %% ============= Obstacle_XYZ ================
      %% ===========================================  

      
      varName = 'Obstacle_XYZ';
      numVals = 3;

      obstacle_XYZ(i,:) = extractVarFromLine(currentLine, varName, numVals  );
      
      
      %% ============= Shutter Glass ===============
      %% ===========================================  

      refIdx = strfind( currentLine, 'G0 [' );
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

      G0_fr_XYZ(i,:) = [ GX GY GZ];

      refIdx = strfind( currentLine, 'G1 [' );
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

      G1_fr_XYZ(i,:) = [ GX GY GZ];


      refIdx = strfind( currentLine, 'G2 [' );
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

      G2_fr_XYZ(i,:) = [ GX GY GZ];

      refIdx = strfind( currentLine, 'G3 [' );
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

      G3_fr_XYZ(i,:) = [ GX GY GZ];

      refIdx = strfind( currentLine, 'G4 [' );
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

      G4_fr_XYZ(i,:) = [ GX GY GZ];  

      %% ============= Right_Foot_XYZ ==============
      %% ===========================================  

      refIdx = strfind( currentLine, 'R0 [' );
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

      R0_fr_XYZ(i,:) = [ RX RY RZ];

      refIdx = strfind( currentLine, 'R1 [' );
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

      R1_fr_XYZ(i,:) = [ RX RY RZ];


      refIdx = strfind( currentLine, 'R2 [' );
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

      R2_fr_XYZ(i,:) = [ RX RY RZ];

      refIdx = strfind( currentLine, 'R3 [' );
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

      R3_fr_XYZ(i,:) = [ RX RY RZ];


      %% ============= Left_Foot_XYZ ==============
      %% ===========================================  

      refIdx = strfind( currentLine, 'L0 [' );
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

      L0_fr_XYZ(i,:) = [ LX LY LZ];

      refIdx = strfind( currentLine, 'L1 [' );
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

      L1_fr_XYZ(i,:) = [ LX LY LZ];


      refIdx = strfind( currentLine, 'L2 [' );
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

      L2_fr_XYZ(i,:) = [ LX LY LZ];

      refIdx = strfind( currentLine, 'L3 [' );
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

      L3_fr_XYZ(i,:) = [ LX LY LZ];

      %% ============== Spinal_XYZ =================
      %% ===========================================  

      refIdx = strfind( currentLine, 'S0 [' );
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
      
      try
        S0_fr_XYZ(i,:) = [ SX SY SZ];
      catch
         keyboard 
      end

      refIdx = strfind( currentLine, 'S1 [' );
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

      S1_fr_XYZ(i,:) = [ SX SY SZ];


      refIdx = strfind( currentLine, 'S2 [' );
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

      S2_fr_XYZ(i,:) = [ SX SY SZ];

      refIdx = strfind( currentLine, 'S3 [' );
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

      S3_fr_XYZ(i,:) = [ SX SY SZ];

    end
    
    % trialType = 
    % startingBoxPos =
    
    trialType = trialType';
    frameTime = frameTime';
%     size(frameTime);
    eventFlag = eventFlag';
%     size(eventFlag);
%     size(collision_XYZ);
    trialType = trialType';
%     size(trialType);
%     size(obstacle_XYZ);
    shutterGlass_XYZ = [G0_fr_XYZ G1_fr_XYZ G2_fr_XYZ G3_fr_XYZ G4_fr_XYZ]; % shutterGlass_fr_XYZ
%     size(shutterGlass_XYZ);
    rightFoot_XYZ = [R0_fr_XYZ R1_fr_XYZ R2_fr_XYZ R3_fr_XYZ]; % rightFoot_fr_XYZ 
%     size(rightFoot_XYZ);
    leftFoot_XYZ = [L0_fr_XYZ L1_fr_XYZ L2_fr_XYZ L3_fr_XYZ];
%     size(leftFoot_XYZ);
    spinal_XYZ = [S0_fr_XYZ S1_fr_XYZ S2_fr_XYZ S3_fr_XYZ];
%     size(spinal_XYZ);
    

    save ([matFileDir textFileName '.mat'],'frameTime','trialType',...
        'eventFlag', 'obstacle_XYZ','collision_XYZ','shutterGlass_XYZ',...
        'rightFoot_XYZ','leftFoot_XYZ','spinal_XYZ',...
        'rightFootQUAT_fr_WXYZ','leftFootQUAT_fr_WXYZ','legLengthCM','walkingDirection','blockNum');
      
    
          
end

