function [posSysTime_mFr pos_mFr_xyz quatSysTime_mFr quat_mFr_xyz] = getBufferedRigidData(currentLine, varName)

%FIXME:  FLIPPED DATA L/R to acocunt for export error in python

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rigid DATA 

% Find index after the variable header, ie: "<< rightFoot-M0 "
refString = sprintf('<< %s_quatXYZW',varName);
startIndex = strfind( currentLine, refString ) + length(refString);

% The next value specifies the number of entries stored in the variable
try
    [numMFrames moveAheadBy]= textscan( currentLine(startIndex:startIndex+10), '%u' );
    currentIndex = startIndex + moveAheadBy;
catch
    keyboard
end


[data_timeXYZ moveAheadBy]= textscan( currentLine(currentIndex:length(currentLine)), '[ %f %f %f %f %f ]' );

quatSysTime_mFr = data_timeXYZ{1};
quat_mFr_xyz = [ data_timeXYZ{2} data_timeXYZ{3} data_timeXYZ{4} data_timeXYZ{5}];
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POS DATA 

% Find index after the variable header, ie: "<< rightFoot-M0 "
refString = sprintf('<< %s_posXYZ',varName);
startIndex = strfind( currentLine, refString ) + length(refString);

% The next value specifies the number of entries stored in the variable
[numMFrames moveAheadBy]= textscan( currentLine(startIndex:startIndex+10), '%u' );
currentIndex = startIndex + moveAheadBy;

% Now, get all the quat data
[data_timeXYZ moveAheadBy]= textscan( currentLine(currentIndex:length(currentLine)), '[ %f %f %f %f ]' );

posSysTime_mFr = fliplr(data_timeXYZ{1});
pos_mFr_xyz = fliplr([ data_timeXYZ{2} data_timeXYZ{3} data_timeXYZ{4} ]);
    
