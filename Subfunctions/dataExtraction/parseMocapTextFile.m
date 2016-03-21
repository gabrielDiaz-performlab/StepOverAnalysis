function parseMocapTextFile(textFileDir, textFileName)

% textFileDir = 'F:\Data\Stepover\2015-9-24-15-14\';
% textFileName =  [textFileDir 'mocap_data-2015-9-24-15-14']
loadParameters

%fieldNames = fieldnames(structHandler{1,1});
%numberOfLines = numel(fieldNames);


%% First, count the number of lines in the text file

fid = fopen([textFileName '.log']);
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

fid = fopen([textFileName '.log']);

% i initialize vectors to arrays of NaN.
% I later remove the NaN before addingt trial data to a cell of all trial
% data
trialDur = 10 * 480; % lets assume 10 seconds of 480 Hz
%%
while ~feof(fid)
    %for i = 1:numberOfLines
    
    currentLine = fgetl(fid);
    %fprintf('%s\n',currentLine)
    
    if( strfind( currentLine, 'Start:' ) )
        
        trialNum = cell2mat(textscan( currentLine, 'Start: %f' ));
        gFr = 1;
        rfFr = 1;
        lfFr = 1;
        sFr = 1;
        
        clear glassesSysTime_fr_mkr glassesMData_fr_mkr glassRbSysTime_fr glassRbPos_fr_xyz glassRbQuatSysTime_fr glassRbQuat_fr_xyzw
        clear rFootSysTime_fr_mkr rFootMData_fr_mkr rFootRbSysTime_fr rFootRbPos_fr_xyz rFootRbQuatSysTime_fr rFootRbQuat_fr_xyzw
        clear lFootSysTime_fr_mkr lFootMData_fr_mkr lFootRbSysTime_fr lFootRbPos_fr_xyz lFootRbQuatSysTime_fr lFootRbQuat_fr_xyzw
        clear spineSysTime_fr_mkr spineMData_fr_mkr spineRbSysTime_fr spineRbPos_fr_xyz spineRbQuatSysTime_fr spineRbQuat_fr_xyzw
        
    end
    
    if( strfind( currentLine, 'End:' ) )
    % Starting a new trial!  Store buffered trial data in cell array of
    % trials
        % Store trial data into cell arrays
        if trialNum > 0
            
            trIdx = trialNum ;
            % Store marker time data
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% GLASSES
            for mIdx = 1:5
                glassesSysTime_tr_mIdx_CmFr(trIdx ,mIdx) = {glassesSysTime_fr_mkr(:,mIdx)};%(~isnan(glassesSysTime_fr_mkr(:,mIdx)))};
                glassesMData_tr_mIdx_CmFr_xyz(trIdx ,mIdx) = {squeeze(glassesMData_fr_mkr(:,mIdx,:))};%(~isnan(glassesMData_fr_mkr))};
            end
            
            glassRbSysTime_tr_CmFr(trIdx) =  {glassRbSysTime_fr};%(~isnan(glassRbSysTime_fr))};
            glassRbPos_tr_CmFr(trIdx) = {glassRbPos_fr_xyz};%(~isnan(glassRbPos_fr_xyz))};
            glassRbQuatSysTime_tr_CmFr(trIdx) = {glassRbQuatSysTime_fr};%(~isnan(glassRbQuatSysTime_fr))};
            glassRbQuat_tr_CmFr_xyz(trIdx) = {glassRbQuat_fr_xyzw};%(~isnan(glassRbQuat_fr_xyzw))};
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % RFOOT
            for mIdx = 1:4
                rFootSysTime_tr_mIdx_CmFr(trIdx ,mIdx) = {rFootSysTime_fr_mkr(:,mIdx)};%(~isnan(rFootSysTime_fr_mkr(:,mIdx)))};
                rFootMData_tr_mIdx_CmFr_xyz(trIdx ,mIdx) = {squeeze(rFootMData_fr_mkr(:,mIdx,:))};%(~isnan(rFootMData_fr_mkr))};
            end
            
            rFootRbSysTime_tr_CmFr(trIdx) =  {rFootRbSysTime_fr};%(~isnan(rFootRbSysTime_fr))};
            rFootRbPos_tr_CmFr(trIdx) = {rFootRbPos_fr_xyz};%(~isnan(rFootRbPos_fr_xyz),:)};
            rFootRbQuatSysTime_tr_CmFr(trIdx) = {rFootRbQuatSysTime_fr}; %(~isnan(rFootRbQuatSysTime_fr))};
            rFootRbQuat_tr_CmFr_xyz(trIdx) = {rFootRbQuat_fr_xyzw}; %(~isnan(rFootRbQuat_fr_xyzw))};
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % LFOOT
            for mIdx = 1:4
                
                lFootSysTime_tr_mIdx_CmFr(trIdx ,mIdx) = {lFootSysTime_fr_mkr(:,mIdx)};%(~isnan(lFootSysTime_fr_mkr(:,mIdx)))};
                lFootMData_tr_mIdx_CmFr_xyz(trIdx ,mIdx) = {squeeze(lFootMData_fr_mkr(:,mIdx,:))};%(~isnan(lFootMData_fr_mkr))};
            end
            
            lFootRbSysTime_tr_CmFr(trIdx) =  {lFootRbSysTime_fr};%(~isnan(lFootRbSysTime_fr))};
            lFootRbPos_tr_CmFr(trIdx) = {lFootRbPos_fr_xyz};%(~isnan(lFootRbPos_fr_xyz))};
            lFootRbQuatSysTime_tr_CmFr(trIdx) = {lFootRbQuatSysTime_fr};%(~isnan(lFootRbQuatSysTime_fr))};
            lFootRbQuat_tr_CmFr_xyz(trIdx) = {lFootRbQuat_fr_xyzw};%(~isnan(lFootRbQuat_fr_xyzw))};         
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Spine
            for mIdx = 1:4
                spineSysTime_tr_mIdx_CmFr(trIdx ,mIdx) = {spineSysTime_fr_mkr(:,mIdx)};%(~isnan(spineSysTime_fr_mkr(:,mIdx)))};
                spineMData_tr_mIdx_CmFr_xyz(trIdx ,mIdx) = {squeeze(spineMData_fr_mkr(:,mIdx,:))};%(~isnan(spineMData_fr_mkr))};
            end
            
            spineRbSysTime_tr_CmFr(trIdx) =  {spineRbSysTime_fr};%(~isnan(spineRbSysTime_fr))};
            spineRbPos_tr_CmFr(trIdx) = {spineRbPos_fr_xyz};%(~isnan(spineRbPos_fr_xyz))};
            spineRbQuatSysTime_tr_CmFr(trIdx) = {spineRbQuatSysTime_fr};%(~isnan(spineRbQuatSysTime_fr))};
            spineRbQuat_tr_CmFr_xyz(trIdx) = {spineRbQuat_fr_xyzw};%(~isnan(spineRbQuat_fr_xyzw))};
            
        end
           
        
        %% Initialize trial variables
%         glassesSysTime_fr_mkr = NaN(trialDur,4);
%         glassesMData_fr_mkr_xyz = NaN(trialDur,4,3);
%         
%         glassRbSysTime_fr = NaN(trialDur,1);
%         glassRbPos_fr_xyz = NaN(trialDur,3);
%         glassRbQuatSysTime_fr = NaN(trialDur,1);
%         glassRbQuat_fr_xyzw = NaN(trialDur,4);
        

        continue
    end
        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Get FRAME data.  Save it to a trial buffer.
    if( strfind( currentLine, 'shutter' ) )
        
        
        [glassesM0time, glassesM0_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 0);
        [glassesM1time, glassesM1_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 1);
        [glassesM2time, glassesM2_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 2);
        [glassesM3time, glassesM3_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 3);
        [glassesM4time, glassesM4_xyz] = getBufferedMarkerData(currentLine, 'shutterGlass.rb', 4);
    
        glassesSysTime_fr_mkr(gFr,1) = glassesM0time;
        glassesSysTime_fr_mkr(gFr,2) = glassesM1time;
        glassesSysTime_fr_mkr(gFr,3) = glassesM2time;
        glassesSysTime_fr_mkr(gFr,4) = glassesM3time;
        glassesSysTime_fr_mkr(gFr,5) = glassesM4time;
        
        glassesMData_fr_mkr(gFr,1,:) = glassesM0_xyz;
        glassesMData_fr_mkr(gFr,2,:) = glassesM1_xyz;
        glassesMData_fr_mkr(gFr,3,:) = glassesM2_xyz;
        glassesMData_fr_mkr(gFr,4,:) = glassesM3_xyz;
        glassesMData_fr_mkr(gFr,5,:) = glassesM4_xyz;
        
        [glassRbSysTime, glassRbPos_xyz, glassRbQuatSysTime, glassRbQuat_xyzw] = ...
            getBufferedRigidData(currentLine, 'shutterGlass.rb');
        
        glassRbSysTime_fr(gFr) = glassRbSysTime;
        glassRbPos_fr_xyz(gFr,:) = glassRbPos_xyz;
        glassRbQuatSysTime_fr(gFr) = glassRbQuatSysTime;
        glassRbQuat_fr_xyzw(gFr,:) = glassRbQuat_xyzw;
        
        gFr = gFr+1; % a unique frame counte fo the glasses rigid body
        
        continue
    end
    
    %% Right foot
     if( strfind( currentLine, 'right' ) )
          
        [rFootM0time, rFootM0_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 5);
        [rFootM1time, rFootM1_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 6);
        [rFootM2time, rFootM2_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 7);
        [rFootM3time, rFootM3_xyz] = getBufferedMarkerData(currentLine, 'rightFoot.rb', 8);
        
        rFootSysTime_fr_mkr(rfFr,1) = rFootM0time;
        rFootSysTime_fr_mkr(rfFr,2) = rFootM1time;
        rFootSysTime_fr_mkr(rfFr,3) = rFootM2time;
        rFootSysTime_fr_mkr(rfFr,4) = rFootM3time;

        rFootMData_fr_mkr(rfFr,1,:) = rFootM0_xyz;
        rFootMData_fr_mkr(rfFr,2,:) = rFootM1_xyz;
        rFootMData_fr_mkr(rfFr,3,:) = rFootM2_xyz;
        rFootMData_fr_mkr(rfFr,4,:) = rFootM3_xyz;
        
        [rFootRbSysTime, rFootRbPos_xyz, rFootRbQuatSysTime, rFootRbQuat_xyzw] = ...
            getBufferedRigidData(currentLine, 'rightFoot.rb');
        
        rFootRbSysTime_fr(rfFr) = rFootRbSysTime;
        rFootRbPos_fr_xyz(rfFr,:) = rFootRbPos_xyz;
        rFootRbQuatSysTime_fr(rfFr) = rFootRbQuatSysTime;
        rFootRbQuat_fr_xyzw(rfFr,:) = rFootRbQuat_xyzw;
        
        rfFr = rfFr +1; % a unique frame counte fo the glasses rigid body    
        

     end
     
     %% Left Foot
     if( strfind( currentLine, 'left' ) )
       
        [lFootM0time, lFootM0_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 9);
        [lFootM1time, lFootM1_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 10);
        [lFootM2time, lFootM2_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 11);
        [lFootM3time, lFootM3_xyz] = getBufferedMarkerData(currentLine, 'leftFoot.rb', 12);
        
        lFootSysTime_fr_mkr(lfFr,1) = lFootM0time;
        lFootSysTime_fr_mkr(lfFr,2) = lFootM1time;
        lFootSysTime_fr_mkr(lfFr,3) = lFootM2time;
        lFootSysTime_fr_mkr(lfFr,4) = lFootM3time;

        lFootMData_fr_mkr(lfFr,1,:) = lFootM0_xyz;
        lFootMData_fr_mkr(lfFr,2,:) = lFootM1_xyz;
        lFootMData_fr_mkr(lfFr,3,:) = lFootM2_xyz;
        lFootMData_fr_mkr(lfFr,4,:) = lFootM3_xyz;      
        
        [lFootRbSysTime, lFootRbPos_xyz, lFootRbQuatSysTime, lFootRbQuat_xyzw] = ...
            getBufferedRigidData(currentLine, 'leftFoot.rb');
        
        lFootRbSysTime_fr(lfFr) = lFootRbSysTime;
        lFootRbPos_fr_xyz(lfFr,:) = lFootRbPos_xyz;
        lFootRbQuatSysTime_fr(lfFr) = lFootRbQuatSysTime;
        lFootRbQuat_fr_xyzw(lfFr,:) = lFootRbQuat_xyzw;
        
        lfFr = lfFr +1; % a unique frame counte fo the glasses rigid body   
        

     end
     
     %% Spine
      if( strfind( currentLine, 'spine' ) )
       
        [spineM0time, spineM0_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 13);
        [spineM1time, spineM1_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 14);
        [spineM2time, spineM2_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 15);
        [spineM3time, spineM3_xyz] = getBufferedMarkerData(currentLine, 'spine.rb', 16);
        
        spineSysTime_fr_mkr(sFr,1) = spineM0time;
        spineSysTime_fr_mkr(sFr,2) = spineM1time;
        spineSysTime_fr_mkr(sFr,3) = spineM2time;
        spineSysTime_fr_mkr(sFr,4) = spineM3time;

        spineMData_fr_mkr(sFr,1,:) = spineM0_xyz;
        spineMData_fr_mkr(sFr,2,:) = spineM1_xyz;
        spineMData_fr_mkr(sFr,3,:) = spineM2_xyz;
        spineMData_fr_mkr(sFr,4,:) = spineM3_xyz;
        
        [spineRbSysTime, spineRbPos_xyz, spineRbQuatSysTime, spineRbQuat_xyzw] = ...
            getBufferedRigidData(currentLine, 'spine.rb');
        
        spineRbSysTime_fr(sFr) = spineRbSysTime;
        spineRbPos_fr_xyz(sFr,:) = spineRbPos_xyz;
        spineRbQuatSysTime_fr(sFr) = spineRbQuatSysTime;
        spineRbQuat_fr_xyzw(sFr,:) = spineRbQuat_xyzw;
        
        sFr = sFr +1; % a unique frame counter for the glasses rigid body    
        
        
     end
     
    
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




