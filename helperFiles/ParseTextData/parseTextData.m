
% %expTextDataFileString
% %eyeTextDataFileString

expDataFileObj = fopen(expTextDataFileString);

currentLine= fgetl(expDataFileObj );

count = 1

% For each line
while( ischar(currentLine) )
        
    charIdx = 0;
    
    while( charIdx <= length(currentLine)-2 )
        
        [varName varData charIdx] = parseTextDataVar(currentLine,charIdx+1);
        
        %fprintf('%s \n',varName);

        if( exist(varName) == 0 )
            eval( sprintf('%s = varData;',varName));

        else
            eval( sprintf('%s = [%s; varData];',varName,varName));
        end

    end
    
    currentLine = fgetl(expDataFileObj );
    count = count+1;
    
end

fclose(expDataFileObj );

display 'Done parsing exp text data'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expDataFileObj = fopen(eyeTextDataFileString);

currentLine= fgetl(expDataFileObj );
count = 1

% For each line
while( ischar(currentLine) )
        
    charIdx = 0;
    
    while( charIdx <= length(currentLine)-2 )
        
        [varName varData charIdx] = parseTextDataVar(currentLine,charIdx+1);
        
        %fprintf('%s \n',varName);

        if( exist(varName) == 0 )
            eval( sprintf('%s = varData;',varName));

        else
            eval( sprintf('%s = [%s; varData];',varName,varName));
        end

    end
    
    currentLine = fgetl(expDataFileObj );
    count = count+1;
    
end

fclose(expDataFileObj );

display 'Done parsing exp text data'

% 
% %%  Map text variables onto exp variables
% 
% % Match
% % frameTime
% sceneTime_fr = frameTime;
% eventFlag_fr = eventFlag;
% viewPos_fr_xyz = viewPos_XYZ;
% viewQuat_fr_quat = viewQUAT_XYZW; % corrrect format?
% racqPos_fr_xyz = paddlePos_XYZ;
% racqQuat_fr_quat = paddleQUAT_XYZW;
% racqAng_fr_xyz = paddleAngVel_XYZ;
% % Forgot racqu linear velocity?
% ballPos_fr_xyz = ballPos_XYZ;
% ballVel_fr_xyz = ballVel_XYZ
% 
% ballBounceX_tr = ballBounceLoc_XYZ(1,:);
% ballBounceY_tr = ballBounceLoc_XYZ(2,:);
% ballBounceZ_tr = ballBounceLoc_XYZ(3,:);
% 
% initBallX_tr = ballInitialPos_XYZ(1,:);
% initBallY_tr = ballInitialPos_XYZ(2,:);
% initBallZ_tr = ballInitialPos_XYZ(3,:);
% 
% initBallVelX_tr = initialVelocity_XYZ(1,:);
% initBallVelY_tr = initialVelocity_XYZ(2,:);
% initBallVelZ_tr = initialVelocity_XYZ(3,:);
% 
% racquHitLocList_xyz = ballOnPaddlePosLoc_XYZ;
% 
% elasticity_tr = ballElasticity
% distToBounce_tr = ballBounceDist
% zDot_tr = ballBounceSpeed
% approachAngle_tr = ballApproachAngleDegs
% 
% 
% % No match in new
% inCalibrateBool
% ballInitialPos_XYZ
% initialVelocity_XYZ
% ballOnPaddlePos_XYZ;
% ballDiameter
% ballGravity
% ballPassingLoc
% ballLaunchDistance
% ballLaunchHeight
% 
% % No match in old
% % movieID_fr
% %ballQuat_fr_quat
% sceneClockTime_fr
% trialType_tr
% viewRot_fr_d1_d2
% racqVel_fr_xyz
% 
% % stackVarNames_var =  {'','ballPix_fr_xy','','ballQuat_fr_quat','','',...
% %     'drawBallBool_fr','','','eyeDataTime_fr','eyeDuration_fr','eyePicTime_fr','gazePixelNormX_fr','gazePixelNormY_fr',,'numElasticities',
% % 'numRepsType1_bl','numRepsType2_bl','numTrials_blk','numBlocks','';};

