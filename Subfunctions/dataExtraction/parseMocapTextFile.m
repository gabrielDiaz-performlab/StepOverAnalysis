function parseTextFile(textFileDir, textFileName)

loadParameters

%fieldNames = fieldnames(structHandler{1,1});
%numberOfLines = numel(fieldNames);


%% First, count the number of lines in the text file

fid = fopen([textFileName '.txt']);
numberOfLines = 0;
chunksize = 1e6; % read chuncks of 1MB at a time

while ~feof(fid)
    ch = fread(fid, chunksize, '*uchar');
    if isempty(ch)
        break
    end
    numberOfLines = numberOfLines + sum(ch == sprintf('\n'));
end

fclose(fid);

%%  Initialize all of my variables

rFootSysTime_tr_mIdx_CmFr = cell(numberOfLines, 4);
rFootMData_tr_mIdx_CmFr_xyz = cell(numberOfLines, 4);

lFootSysTime_tr_mIdx_CmFr = cell(numberOfLines, 4);
lFootMData_tr_mIdx_CmFr_xyz = cell(numberOfLines, 4);

glassesSysTime_tr_mIdx_CmFr = cell(numberOfLines, 5);
glassesMData_tr_mIdx_CmFr_xyz = cell(numberOfLines, 5);

fid = fopen([textFileName '.txt']);

trialNum = 1;

%%
while ~feof(fid)
    %for i = 1:numberOfLines
    
    currentLine = fgetl(fid);
    
    %  ============= BUFFERED DATA
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Glasses marker data
    
    [glassesM0time_mFr glassesM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 0);
    [glassesM1time_mFr glassesM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 1);
    [glassesM2time_mFr glassesM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 2);
    [glassesM3time_mFr glassesM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 3);
    [glassesM4time_mFr glassesM4_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 4);
    
    glassesSysTime_tr_mIdx_CmFr(trialNum,1) = {glassesM0time_mFr};
    glassesSysTime_tr_mIdx_CmFr(trialNum,2) = {glassesM1time_mFr};
    glassesSysTime_tr_mIdx_CmFr(trialNum,3) = {glassesM2time_mFr};
    glassesSysTime_tr_mIdx_CmFr(trialNum,4) = {glassesM3time_mFr};
    glassesSysTime_tr_mIdx_CmFr(trialNum,5) = {glassesM4time_mFr};
    
    glassesMData_tr_mIdx_CmFr_xyz(trialNum,1) = {glassesM0_mFr_xyz};
    glassesMData_tr_mIdx_CmFr_xyz(trialNum,2) = {glassesM1_mFr_xyz};
    glassesMData_tr_mIdx_CmFr_xyz(trialNum,3) = {glassesM2_mFr_xyz};
    glassesMData_tr_mIdx_CmFr_xyz(trialNum,4) = {glassesM3_mFr_xyz};
    glassesMData_tr_mIdx_CmFr_xyz(trialNum,5) = {glassesM4_mFr_xyz};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Right foot marker data
    
    [rFootM0time_mFr rFootM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 5); 
    [rFootM1time_mFr rFootM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 6);
    [rFootM2time_mFr rFootM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 7);
    [rFootM3time_mFr rFootM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 8);
    
    rFootSysTime_tr_mIdx_CmFr(trialNum,1) = {rFootM0time_mFr};
    rFootSysTime_tr_mIdx_CmFr(trialNum,2) = {rFootM1time_mFr};
    rFootSysTime_tr_mIdx_CmFr(trialNum,3) = {rFootM2time_mFr};
    rFootSysTime_tr_mIdx_CmFr(trialNum,4) = {rFootM3time_mFr};
    
    rFootMData_tr_mIdx_CmFr_xyz(trialNum,1) = {rFootM0_mFr_xyz};
    rFootMData_tr_mIdx_CmFr_xyz(trialNum,2) = {rFootM1_mFr_xyz};
    rFootMData_tr_mIdx_CmFr_xyz(trialNum,3) = {rFootM2_mFr_xyz};
    rFootMData_tr_mIdx_CmFr_xyz(trialNum,4) = {rFootM3_mFr_xyz};
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Left foot marker data
    
    [lFootM0time_mFr lFootM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 9);
    [lFootM1time_mFr lFootM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 10);
    [lFootM2time_mFr lFootM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 11);
    [lFootM3time_mFr lFootM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 12);
    
    lFootSysTime_tr_mIdx_CmFr(trialNum,1) = {lFootM0time_mFr};
    lFootSysTime_tr_mIdx_CmFr(trialNum,2) = {lFootM1time_mFr};
    lFootSysTime_tr_mIdx_CmFr(trialNum,3) = {lFootM2time_mFr};
    lFootSysTime_tr_mIdx_CmFr(trialNum,4) = {lFootM3time_mFr};
    
    lFootMData_tr_mIdx_CmFr_xyz(trialNum,1) = {lFootM0_mFr_xyz};
    lFootMData_tr_mIdx_CmFr_xyz(trialNum,2) = {lFootM1_mFr_xyz};
    lFootMData_tr_mIdx_CmFr_xyz(trialNum,3) = {lFootM2_mFr_xyz};
    lFootMData_tr_mIdx_CmFr_xyz(trialNum,4) = {lFootM3_mFr_xyz};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Spine marker data
    
    [spineM0time_mFr spineM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 13);
    [spineM1time_mFr spineM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 14);
    [spineM2time_mFr spineM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 15);
    [spineM3time_mFr spineM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 16);
    
    spineSysTime_tr_mIdx_CmFr(trialNum,1) = {spineM0time_mFr};
    spineSysTime_tr_mIdx_CmFr(trialNum,2) = {spineM1time_mFr};
    spineSysTime_tr_mIdx_CmFr(trialNum,3) = {spineM2time_mFr};
    spineSysTime_tr_mIdx_CmFr(trialNum,4) = {spineM3time_mFr};
    
    spineMData_tr_mIdx_CmFr_xyz(trialNum,1) = {spineM0_mFr_xyz};
    spineMData_tr_mIdx_CmFr_xyz(trialNum,2) = {spineM1_mFr_xyz};
    spineMData_tr_mIdx_CmFr_xyz(trialNum,3) = {spineM2_mFr_xyz};
    spineMData_tr_mIdx_CmFr_xyz(trialNum,4) = {spineM3_mFr_xyz};
    
    %% Quats and positions
    
    [glassRbSysTime_mFr glassRbPos_mFr_xyz glassRbQuatSysTime_mFr glassRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'shutterGlass.rb');
    [lFootRbSysTime_mFr lFootRbPos_mFr_xyz lFootRbQuatSysTime_mFr lFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'leftFoot.rb');
    [rFootRbSysTime_mFr rFootRbPos_mFr_xyz rFootRbQuatSysTime_mFr rFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'rightFoot.rb');
    [spineRbSysTime_mFr spineRbPos_mFr_xyz spineRbQuatSysTime_mFr spineRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'spine.rb');

    glassRbSysTime_tr_CmFr(trialNum) = {glassRbSysTime_mFr};
    glassRbPos_tr_CmFr(trialNum) = {glassRbPos_mFr_xyz};
    glassRbQuatSysTime_tr_CmFr(trialNum) = {glassRbQuatSysTime_mFr};
    glassRbQuat_tr_CmFr_xyz(trialNum)  = {glassRbQuat_mFr_xyz};
    
    rFootRbSysTime_tr_CmFr(trialNum) = {rFootRbSysTime_mFr};
    rFootRbPos_tr_CmFr(trialNum) = {rFootRbPos_mFr_xyz};
    rFootRbQuatSysTime_tr_CmFr(trialNum) = {rFootRbQuatSysTime_mFr};
    rFootRbQuat_tr_CmFr_xyz(trialNum)  = {rFootRbQuat_mFr_xyz};
    
    lFootRbSysTime_tr_CmFr(trialNum) = {lFootRbSysTime_mFr};
    lFootRbPos_tr_CmFr(trialNum) = {lFootRbPos_mFr_xyz};
    lFootRbQuatSysTime_tr_CmFr(trialNum) = {lFootRbQuatSysTime_mFr};
    lFootRbQuat_tr_CmFr_xyz(trialNum)  = {lFootRbQuat_mFr_xyz};
    
    spineRbSysTime_tr_CmFr(trialNum) = {spineRbSysTime_mFr};
    spineRbPos_tr_CmFr(trialNum) = {spineRbPos_mFr_xyz};
    spineRbQuatSysTime_tr_CmFr(trialNum) = {spineRbQuatSysTime_mFr};
    spineRbQuat_tr_CmFr_xyz(trialNum)  = {spineRbQuat_mFr_xyz};
    
    trialNum = trialNum+1;
    
end



%%

fclose(fid);

%%

outFileDir = [ 'parsed' textFileName(6:end)];

save ([ parsedTextFileDir outFileDir '.mat'],...
    'spineSysTime_tr_mIdx_CmFr',...
    'spineMData_tr_mIdx_CmFr_xyz',...
    'rFootSysTime_tr_mIdx_CmFr',...
    'rFootMData_tr_mIdx_CmFr_xyz',...
    'lFootSysTime_tr_mIdx_CmFr',...
    'lFootMData_tr_mIdx_CmFr_xyz',...
    'glassesSysTime_tr_mIdx_CmFr',...
    'glassesMData_tr_mIdx_CmFr_xyz',...
    'glassRbSysTime_tr_CmFr','glassRbPos_tr_CmFr','glassRbQuatSysTime_tr_CmFr','glassRbQuat_tr_CmFr_xyz',...
    'rFootRbSysTime_tr_CmFr','rFootRbPos_tr_CmFr','rFootRbQuatSysTime_tr_CmFr','rFootRbQuat_tr_CmFr_xyz',...
    'lFootRbSysTime_tr_CmFr','lFootRbPos_tr_CmFr','lFootRbQuatSysTime_tr_CmFr','lFootRbQuat_tr_CmFr_xyz',...
    'spineRbSysTime_tr_CmFr','spineRbPos_tr_CmFr','spineRbQuatSysTime_tr_CmFr','spineRbQuat_tr_CmFr_xyz',...
    '-append');


fprintf ('Parsed mocap data saved to text file %s.mat \n', parsedTextFileDir )




