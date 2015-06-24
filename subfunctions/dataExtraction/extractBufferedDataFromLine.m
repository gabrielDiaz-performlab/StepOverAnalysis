function sysTime_mFr data_mFr_xyz = getBufferedMarkerData(currentLine, varName, mIdx)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MARKER DATA 

% Midx = Marker index

% Find index after the variable header, ie: "<< rightFoot-M0 "
refString = sprintf('<< %s-M%u',varName,mIdx);
currentIndex = strfind( currentLine, refString ) + length(refString);


%%

% The next value specifies the number of entries stored in the variable
[numMFrames currentIndex]= textscan( currentLine(currentIndex:length(currentLine)), '%u' );

sysTime_fr = []

% mFr = mocap frame.  
% B/C Mocap Framerate is higher than vizard refresh
% THere are more mocap frames than standard vizard frames
sysTime_mFr_xyz = NaN(numMFrames,1);
data_mFr_xyz = NaN(numMFrames,3);

for mFrIdx = 1:numMFrames
    
    [timeXYZ currentIndex]= textscan( currentLine(currentIndex:length(currentLine)), '[ %f %f %f %f ]' );
    sysTime_mFr(mFrIdx) = timeXYZ(1);
    data_mFr_xyz(mFrIdx,:) = timeXYZ(2:4);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POSITION DATA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QUATERNION DATA




