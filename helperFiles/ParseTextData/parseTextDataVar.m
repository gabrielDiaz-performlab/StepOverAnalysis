function [variableName varData endTrigIdx] = parseTextDataVar(currentLine,charIdx)

% Necessary to fix a bug in matlab's textscan function, in which it cannot
% read in nan values correctly 
%currentLine = strrep(currentLine, 'nan', 'nnann');

% This allows me to handle a small bug, in which a space was forgotten.

if( charIdx == 1 )
    isTheFirstVar = 1;
else
    isTheFirstVar = 0;
end
    
% # Legend:
% # ** for 1 var
% # () for 2 vars
% # [] for 3 vars
% # <> for 4 vars
% # @@ for 16 vars (view and projection matrices)

triggerChars = '*([<@';
endChars = '*)]>@';

% Is the char a triggerChar?
currentChar = currentLine(charIdx);
[isTrigBool trigIdx] = ismember(currentChar,triggerChars);


% If not, increment until we find a trigger char
while( isTrigBool == 0 )  
    charIdx = charIdx+1;
    currentChar = currentLine(charIdx);
    [isTrigBool trigIdx] = ismember(currentChar,triggerChars);
end


startTrigIdx = charIdx;

% Now, increment until we find the ending trigger char
isTrigBool = 0;

while( isTrigBool == 0 )
    charIdx = charIdx+1;
    currentChar = currentLine(charIdx);
    
    if( strcmp( currentChar , endChars(trigIdx)) )
        isTrigBool = 1;
    end
end

endTrigIdx = charIdx;

% Get variable name and data
if( trigIdx == 1 && isTheFirstVar )
    %infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '* %s %f*','TreatAsEmpty',' nnann');
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '* %s %f*');
    %endTrigIdx = endTrigIdx + 1;

elseif( trigIdx == 1 && ~isTheFirstVar )
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '* %s %f *');%,'TreatAsEmpty',' nnann');

elseif( trigIdx == 2 )
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '( %s %f %f )');%,'TreatAsEmpty',' nnann');

elseif( trigIdx == 3 )
    
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '[ %s %f %f %f ]');%,'TreatAsEmpty',' nnann');
    
elseif( trigIdx == 4 )
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '< %s %f %f %f %f >');%,'TreatAsEmpty',' nnann');

elseif( trigIdx == 5 )
    
    infoString = textscan(currentLine(startTrigIdx:endTrigIdx), '@ %s [%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f] @');%,'TreatAsEmpty',' nnann');
    
    % Not sure why endTrigIdx = endTrigIdx + 1; crashes it.  
    
end

variableName = char(infoString{1});
varData = cell2mat(infoString(2:end));

