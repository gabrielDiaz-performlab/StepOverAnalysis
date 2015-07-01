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
    [glassesM0time_mFr glassesM0_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 0);
    [glassesM1time_mFr glassesM1_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 1);
    [glassesM2time_mFr glassesM2_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 2);
    [glassesM3time_mFr glassesM3_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 3);
    [glassesM4time_mFr glassesM4_mFr_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 4);
    
    %glasseSysTime_tr_CmIdx_mFr_xyz(trialNum) = {[glassesM0time_mFr glassesM1time_mFr glassesM2time_mFr glassesM3time_mFr glassesM4time_mFr]'};
    %glassesMData_tr_CmIdx_mFr_xyz(trialNum) = {[glassesM0_mFr_xyz glassesM1_mFr_xyz glassesM2_mFr_xyz glassesM3_mFr_xyz glassesM4_mFr_xyz]'};
    
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
    
    %%
    
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
    
    
    %%
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
    
    %% Quats and positions
    
    [glassRbSysTime_mFr glassRbPos_mFr_xyz glassRbQuatSysTime_mFr glassRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'shutterGlass.rb');
    [lFootRbSysTime_mFr lFootRbPos_mFr_xyz lFootRbQuatSysTime_mFr lFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'leftFoot.rb');
    [rFootRbSysTime_mFr rFootRbPos_mFr_xyz rFootRbQuatSysTime_mFr rFootRbQuat_mFr_xyz] = getBufferedRigidData(currentLine, 'rightFoot.rb');

    
    trialNum = trialNum+1;
    
end



%%

fclose(fid);

%%

outFileDir = [ 'parsed' textFileName(6:end)];

save ([ parsedTextFileDir outFileDir '.mat'],...
    'rFootSysTime_tr_mIdx_CmFr',...
    'rFootMData_tr_mIdx_CmFr_xyz',...
    'lFootSysTime_tr_mIdx_CmFr',...
    'lFootMData_tr_mIdx_CmFr_xyz',...
    'glassesSysTime_tr_mIdx_CmFr',...
    'glassesMData_tr_mIdx_CmFr_xyz',...
    'glassRbSysTime_mFr','glassRbPos_mFr_xyz',...
    'glassRbQuatSysTime_mFr','glassRbQuat_mFr_xyz',...
    'lFootRbSysTime_mFr','lFootRbPos_mFr_xyz',...
    'lFootRbQuatSysTime_mFr','lFootRbQuat_mFr_xyz',...
    'rFootRbSysTime_mFr','rFootRbPos_mFr_xyz',...
    'rFootRbQuatSysTime_mFr','rFootRbQuat_mFr_xyz',...
    '-append');

    
fprintf ('Parsed mocap data saved to text file %s.mat \n', parsedTextFileDir )




