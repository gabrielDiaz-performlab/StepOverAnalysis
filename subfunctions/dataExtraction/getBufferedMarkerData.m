function [sysTime_mFr data_mFr_xyz] = getBufferedMarkerData(currentLine, varName, mIdx)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MARKER DATA 

% Find index after the variable header, ie: "<< rightFoot-M0 "
refString = sprintf('<< %s-M%u_XYZ',varName,mIdx);
startIndex = strfind( currentLine, refString ) + length(refString);

if( isempty(startIndex) )
    keyboard
    return
    errorString = springf('in getBufferedMarkerData: Marker #%f of %s not present during this trial',mIdx,varName);
    error(errorString)
end

%%

% % The next value specifies the number of entries stored in the variable
% [numMFrames moveAheadBy]= textscan( currentLine(startIndex:startIndex+10), '%u' );
% %fprintf('%u\n',numMFrames{1})
% currentIndex = startIndex + moveAheadBy;

%%
    
[data_timeXYZ moveAheadBy]= textscan( currentLine(startIndex:length(currentLine)), '[ %f %f %f %f ]' );

sysTime_mFr = data_timeXYZ{1};
% SWAPPED Y AND Z AXES
data_mFr_xyz = [ data_timeXYZ{2} data_timeXYZ{4} data_timeXYZ{3} ];
    

