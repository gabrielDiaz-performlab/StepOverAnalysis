
tok = rvd('create',1);
info=rvd('open',tok,movieString);
fprintf('\nGetting data from %s  This may take a minute...\n',movieName);

clear infoString ZDotList numReps_bl elasticity_bl

%%%%%%%%%%%%%%%%%%
%% Distance to walls

startUnit = 1;
while( info.meta(startUnit) ~= '[')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= ']')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '[%8.3f %8.3f %8.3f %8.3f]');

frontWallDist = infoString{1};
backWallDist = infoString{2};
roomWidth = infoString{3};
roomHeight = infoString{4};

%%%%%%%%%%%%%%%%%%
%%% Batter's box

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '[')
    startUnit = startUnit+1;
end

endUnit = startUnit+1;
while( info.meta(endUnit) ~= ']')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '[%8.3f %8.3f %8.3f %8.3f]');

battersBoxW = infoString{1};
battersBoxL = infoString{2};
battersBoxH = infoString{3};
battersBoxPosX = infoString{4};

%%%%%%%%%%%%%%%%%%%%%
%%% PassRange

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '<')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= '>')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f>');

passRangeMin = infoString{1};
passRangeMax = infoString{2};

%%%%%%%%%%%%%%%%%%%%%
%%% initZMin / max

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '<')
    startUnit = startUnit+1;
end

endUnit = startUnit+1;
while( info.meta(endUnit) ~= '>')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f>');

initZMin = infoString{1};
initZMax = infoString{2};

%%%%%%%%%%%%%%%%%%%%%
%%% Flightdist

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '<')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= '>')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f>');

launchDistMin = infoString{1};
launchDistMax = infoString{2};

%%%%%%%%%%%%%%%%%%%%%
%%% Racquet Size

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '<')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= '>')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f %f>');
racquetSize_whd = [infoString{1} infoString{2} infoString{3}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ball radius, Inviisble for X frames
startUnit = endUnit+1;
endUnit= startUnit+15;

% while( info.meta(endUnit) ~= '<')
%     endUnit = endUnit+1;
% end

[infoString] = textscan(info.meta(startUnit:endUnit), '%f %f');

ballRadius = infoString{1};
ballInvisForXFrames = infoString{2};


%%%%%%%%%%%%%%%%%%%%%
%% Bounce distribution X

startUnit = endUnit;

while( info.meta(startUnit) ~= '<')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= '>')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f>');
 
[bounceDistMin bounceDistMax]  = infoString{1:2};

% startUnit = endUnit;
% 
% while( info.meta(startUnit) ~= '<')
%     startUnit = startUnit+1;
% end
% 
% endUnit = startUnit;
% while( info.meta(endUnit) ~= '>')
%     endUnit = endUnit+1;
% end
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%
% %% Bounce distribution Y
% 
% startUnit = endUnit;
% 
% while( info.meta(startUnit) ~= '<')
%     startUnit = startUnit+1;
% end
% 
% endUnit = startUnit;
% while( info.meta(endUnit) ~= '>')
%     endUnit = endUnit+1;
% end
% 
% [infoString] = textscan(info.meta(startUnit:endUnit), '<%f %f>');
% 
% [bounceCenterY bounceStdY]  = infoString{1:2};

% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Divangle
%
% startUnit = endUnit+1;
% while( info.meta(startUnit) ~= '[')
%     startUnit = startUnit+1;
% end
%
% endUnit = startUnit;
% while( info.meta(endUnit) ~= ']')
%     endUnit = endUnit+1;
% end
%
% [infoString] = textscan(info.meta(startUnit:endUnit), '[%f]');
%
% eyeRotation = -infoString{1}* (pi / 180);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Number of blocks

startUnit = endUnit;
while( info.meta(startUnit) ~= '[[')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= ']]')
    endUnit = endUnit+1;
end

[infoString] = textscan(info.meta(startUnit:endUnit), '[[%f]]');

numBlocks = infoString{1};

%%%%%%%%%%%%%%%%%%%%%
%%% Reps for trial type 1

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '[')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= ']')
    endUnit = endUnit+1;
end

unitString = '';

for i = 1:numBlocks
    unitString = [unitString '%f '];
end

[infoString] = textscan(info.meta(startUnit:endUnit), ['[' unitString ']']);
numRepsType1_bl  = cell2mat(infoString);

%%%%%%%%%%%%%%%%%%%%%
%% Reps for trial type 2

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '[')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= ']')
    endUnit = endUnit+1;
end

unitString = '';

for i = 1:numBlocks
    unitString = [unitString '%f '];
end

[infoString] = textscan(info.meta(startUnit:endUnit), ['[' unitString ']']);
numRepsType2_bl  = cell2mat(infoString);

% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Num bounce speeds
%
% startUnit = endUnit+1;
% while( info.meta(startUnit) ~= '[')
%     startUnit = startUnit+1;
% end
%
% endUnit = startUnit;
% while( info.meta(endUnit) ~= ']')
%     endUnit = endUnit+1;
% end
%
% [infoString] = textscan(info.meta(startUnit:endUnit), '[[%f]]');
% numZdot = infoString{1};

%%%%%%%%%%%%%%%%%%%%%
% %%% Zdot
%
% startUnit = endUnit+1;
% while( info.meta(startUnit) ~= '[')
%     startUnit = startUnit+1;
% end
%
% endUnit = startUnit;
% while( info.meta(endUnit) ~= ']')
%     endUnit = endUnit+1;
% end
%
% unitString = '';
%
% for i = 1:numZdot
%     unitString = [unitString '%f '];
% end
%
% [infoString] = textscan(info.meta(startUnit:endUnit), ['[' unitString ']']);
% zDotList = cell2mat(infoString);

%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Num elasticities
%
% startUnit = endUnit+1;
%
% while( info.meta(startUnit) ~= '[[')
%     startUnit = startUnit+1;
% end
%
% endUnit = startUnit;
% while( info.meta(endUnit) ~= ']]')
%     endUnit = endUnit+1;
% end
%
% [infoString] = textscan(info.meta(startUnit:endUnit), '[[%f]]');
% numElasticities = infoString{1};

%%%%%%%%%%%%%%%%%%%%%
%% Elasticities


display(sprintf('MANUALLY SETTING NUMELASTICITIES TO 2 IN PARSEMOVIEFILE.M'))
numElasticities = 2;

startUnit = endUnit+1;
while( info.meta(startUnit) ~= '[')
    startUnit = startUnit+1;
end

endUnit = startUnit;
while( info.meta(endUnit) ~= ']')
    endUnit = endUnit+1;
end

unitString = '';

for i = 1:numElasticities
    unitString = [unitString '%f '];
end

[infoString] = textscan(info.meta(startUnit:endUnit), ['[' unitString ']']);
elasticityList  = cell2mat(infoString);

numTrials_blk = (numRepsType1_bl +numRepsType2_bl) * numElasticities;

%%

% Note:  Data is associated with an ID number.  ID numbers reflect the
% order in which the frames were recieved by the quicktime movie.
% ID numbers will only ever INCrEASE in number, however
% ID numbers may increment by >1, or not at all.
% To avoid complication, I use *frame*  convention, which refers
% to all frame IDs from ID#1 to the total number of frame ID's,
% sequentially.

numUniqueFrames = info.scene_samples;


movieID_fr = zeros(numUniqueFrames,1);
sceneTime_fr = zeros(numUniqueFrames,1);
sceneClockTime_fr = zeros(numUniqueFrames,1);
eventFlag_fr = zeros(numUniqueFrames,1);
viewPos_fr_xyz = zeros(numUniqueFrames,3);
viewQuat_fr_quat = zeros(numUniqueFrames,4);
ballPos_fr_xyz = zeros(numUniqueFrames,3);
ballQuat_fr_quat = zeros(numUniqueFrames,4);
ballVel_fr_xyz = zeros(numUniqueFrames,3);
ballAng_fr_xyz = zeros(numUniqueFrames,3);
racqPos_fr_xyz = zeros(numUniqueFrames,3);
racqQuat_fr_quat = zeros(numUniqueFrames,4);
racqVel_fr_xyz = zeros(numUniqueFrames,3);
racqAng_fr_xyz = zeros(numUniqueFrames,3);
eyePicTime_fr = zeros(numUniqueFrames,1);
eyeDataTime_fr = zeros(numUniqueFrames,1);
eyeDuration_fr = zeros(numUniqueFrames,1);
gazePixelNormX_fr = zeros(numUniqueFrames,1);
gazePixelNormY_fr = zeros(numUniqueFrames,1);
eyePupilSizeX_fr = zeros(numUniqueFrames,1);
eyePupilSizeY_fr = zeros(numUniqueFrames,1);
eyeQuality = zeros(numUniqueFrames,1);

viewRot_fr_d1_d2 = zeros(numUniqueFrames,4,4);
ballPix_fr_xy = zeros(numUniqueFrames,2);

totalNumTrials = sum(numTrials_blk);

initBallX_tr = zeros(totalNumTrials,1);
initBallY_tr = zeros(totalNumTrials,1);
initBallZ_tr = zeros(totalNumTrials,1);
initBallVelX_tr = zeros(totalNumTrials,1);
initBallVelY_tr = zeros(totalNumTrials,1);
initBallVelZ_tr = zeros(totalNumTrials,1);
ballBounceX_tr = zeros(totalNumTrials,1);
ballBounceY_tr = zeros(totalNumTrials,1);
ballBounceZ_tr = zeros(totalNumTrials,1);
zDot_tr = zeros(totalNumTrials,1);
distToBounce_tr = zeros(totalNumTrials,1);
approachAngle_tr = zeros(totalNumTrials,1);
elasticity_tr = zeros(totalNumTrials,1);

contactTimeList  = [];
contactFrList  = [];
racquHitLocList_xyz = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Get scene data
%%

dataStringLookup = {'time' 'trialState' 'viewPx' 'viewPy' 'viewPz' 'viewQ1' 'viewQ2' 'viewQ3' 'viewQ4' ...
    'ballX' 'ballY' 'ballZ' 'ballQ1' 'ballQ2' 'ballQ3' 'ballQ4' 'ballVx' 'ballVy' 'ballVz' 'ballAx' 'ballAy' 'ballAz' 'drawBall' ...
    'racqX' 'racqY' 'racqZ' 'racqQ1' 'racqQ2' 'racqQ3' 'racqQ4' 'racqVx' 'racqVy' 'racqVz' 'racqAx' 'racqAy' 'racqAz' 'ballPixX' 'ballPixY'};

trialIdx = 0;

trialCount = 0;
blockCount = 1;

movieID = info.scene_first;
frIdx = 1;


while( movieID <= info.scene_last )
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Scene
    try
        
        scene=rvd('scene',tok,movieID,2);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Scene data
        
        numMeta = size(scene.meta,1);
        % if more than one meta string, search for one with newTrialData>0
        metaIdx = 1;
        
        %%
        
        if( numMeta >1 )
            for idx = 1:numMeta
                
                
                [dataString] = textscan(scene.meta(idx).str, ['%010d %1d']);
                
                isNewTrial_temp = dataString{2};
                
                if(isNewTrial_temp>0)
                    metaIdx = idx;
                end
                
            end
            
        end
        
        [dataString] = textscan(scene.meta(metaIdx).str, ['%010d %1d']);
        eventFlag_fr(frIdx) = dataString{2};
        
        if( eventFlag_fr(frIdx) == 1)
            trialCount = trialCount+1;
            fprintf('BlockIdx: %1.0f, TrialIdx: %1.0f\n',blockCount, trialCount)
        end
        
        %%
        
        if(eventFlag_fr(frIdx) == 3)
            blockCount = blockCount+1;
            trialCount = 0;
        end
        
        %         if( eventFlag_fr(frIdx) == 6)
        %
        %             % racquet hit - string includes racqu pos.
        %             [dataString lastPos] = textscan(scene.meta(metaIdx).str, ['%010d %1d <%f %f %f> [%f %f %f %f] <%f %f %f> '...
        %                 '[%f %f %f %f] (%f %f %f) (%f %f %f) %d <%f %f %f> '...
        %                 '[%f %f %f %f] (%f %f %f) (%f %f %f) <%f %f> %f <%f %f %f>']);
        %
        %
        %             contactTimeList = [contactTimeList dataString{end-3}];
        %             contactFrList = [contactFrList frIdx];
        %             racquHitLocList_xyz = [racquHitLocList_xyz; dataString{end-2:end}];
        
        
        [dataString lastPos] = textscan(scene.meta(metaIdx).str, ['%010d %1d <%f %f %f> [%f %f %f %f] <%f %f %f> '...
            '[%f %f %f %f] (%f %f %f) (%f %f %f) %d <%f %f %f> '...
            '[%f %f %f %f] (%f %f %f) (%f %f %f) <%f %f>']);
        
        
        for i = 1:numel(dataString)
            if( isempty(dataString{i}) )
                fprintf('   Warning! Datastring empty on frame %1.0f',frIdx);
                dataString{i} = 0;
            end
        end
        
        movieID_fr(frIdx) = movieID;
        
        sceneTime_fr(frIdx) =  scene.time;
        sceneClockTime_fr(frIdx) = dataString{find(strcmp(dataStringLookup,'time')==1)};
        
        tempIdx = find(strcmp(dataStringLookup,'viewPx')==1);
        viewPos_fr_xyz(frIdx,:)= -cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        %%
        
        tempIdx = [find(strcmp(dataStringLookup,'viewQ4')) ...
            find(strcmp(dataStringLookup,'viewQ1')) ...
            find(strcmp(dataStringLookup,'viewQ2'))...
            find(strcmp(dataStringLookup,'viewQ3'))];
        
        viewQuat_fr_quat(frIdx,:) = cell2mat(dataString(tempIdx));
        viewQuat_fr_quat(frIdx,1) = -viewQuat_fr_quat(frIdx,1);
        
        viewRot_fr_d1_d2(frIdx,:,:) = quaternion2matrix(viewQuat_fr_quat(frIdx,:));
        
        tempIdx = find(strcmp(dataStringLookup,'ballX')==1);
        ballPos_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        
        %%
        
        tempIdx = [find(strcmp(dataStringLookup,'ballQ4')) ...
            find(strcmp(dataStringLookup,'ballQ1')) ...
            find(strcmp(dataStringLookup,'ballQ2'))...
            find(strcmp(dataStringLookup,'ballQ3'))];
        
        ballQuat_fr_quat(frIdx,:) = cell2mat(dataString(tempIdx));
        ballQuat_fr_quat(frIdx,1) = -ballQuat_fr_quat(frIdx,1);
        
        %%
        
        tempIdx = find(strcmp(dataStringLookup,'ballVx')==1);
        ballVel_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        tempIdx = find(strcmp(dataStringLookup,'ballAx')==1);
        ballAng_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        tempIdx = find(strcmp(dataStringLookup,'drawBall')==1);
        drawBallBool_fr(frIdx,:) = cell2mat(dataString(tempIdx));
        
        tempIdx = find(strcmp(dataStringLookup,'racqX')==1);
        racqPos_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        tempIdx = find(strcmp(dataStringLookup,'racqQ1')==1);
        racqQuat_fr_quat(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+3)));
        
        tempIdx = find(strcmp(dataStringLookup,'racqVx')==1);
        racqVel_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        tempIdx = find(strcmp(dataStringLookup,'racqAx')==1);
        racqAng_fr_xyz(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+2)));
        
        tempIdx = find(strcmp(dataStringLookup,'ballPixX')==1);
        ballPix_fr_xy(frIdx,:) = cell2mat(dataString(tempIdx:(tempIdx+1)));
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Eye info
        %%
        
        if( scene.eye_frame ~= 0 )
            
            %try
            eyeStruct=rvd('eye',tok,scene.eye_frame,2);
            
            eyePicTime_fr(frIdx)= eyeStruct.time;
            eyeDataTime_fr(frIdx)= eyeStruct.arr.time;
            eyeDuration_fr(frIdx,:) = eyeStruct.arr.duration; %
            gazePixelNormX_fr(frIdx,:) = eyeStruct.arr.gx;
            gazePixelNormY_fr(frIdx,:) = eyeStruct.arr.gy;
            eyePupilSizeX_fr(frIdx,:) = eyeStruct.arr.px;
            eyePupilSizeY_fr(frIdx,:) = eyeStruct.arr.py;
            eyeQuality(frIdx,:) = eyeStruct.arr.quality;
            
        end
        
        
        
        if( eventFlag_fr(frIdx) == 1)
            
            trialIdx = trialIdx+1;
            
            newTrialDataStringLookup = {'blockNum' 'trialNum' 'trialType' 'initBallX' 'initBallY' 'initBallZ' 'initBallVx' 'initBallVy' 'initBallVz' ...
                'bounceX' 'bounceY' 'bounceZ' 'finalBallZ' 'elasticity' 'distToBounce' 'approachAngle' 'ballhitRacAtX' 'ballhitRacAtY' 'ballhitRacAtZ'};
            
            dataString = textscan(scene.meta(metaIdx).str(lastPos+1:end),'[%f %f %f] <%f %f %f> [%f %f %f] <%f %f %f> %f %f %f %8.4f  [%f %f %f]');
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'trialType')==1);
            trialType_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'blockNum')==1);
            blockNum_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallX')==1);
            initBallX_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallY')==1);
            initBallY_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallZ')==1);
            initBallZ_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallVx')==1);
            initBallVelX_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallVy')==1);
            initBallVelY_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'initBallVz')==1);
            initBallVelZ_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'bounceX')==1);
            ballBounceX_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'bounceY')==1);
            ballBounceY_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'bounceZ')==1);
            ballBounceZ_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'finalBallZ')==1);
            zDot_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'elasticity')==1);
            elasticity_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'distToBounce')==1);
            distToBounce_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            tempIdx = find(strcmp(newTrialDataStringLookup,'approachAngle')==1);
            approachAngle_tr(trialIdx) = cell2mat(dataString(tempIdx));
            
            % 'ballhitRacAtX' 'ballhitRacAtY' 'ballhitRacAtZ'
            
        end
        
        
        frIdx = frIdx+1;
        movieID = movieID+scene.duration;
    catch
        display('Jumping bad quicktime slot!')
        frIdx = frIdx+1;
        movieID = movieID+1;
        
    end
end

%%
display('Done extracting data from movie')

rvd('close',tok)
rvd('destroy',tok)

beep
