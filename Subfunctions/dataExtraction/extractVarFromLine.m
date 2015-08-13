function data_valIdx = extractVarFromLine(currentLine, varName, numVals  )
      

%%
refIdx = strfind( currentLine, varName );

currentIdx = refIdx + length(varName);
data_valIdx = zeros(1,numVals);
%%
for valIdx = 1:numVals;
  currentIdx = currentIdx +1 ;
  tempVar = '';
  while( currentLine( currentIdx ) ~= ' ' )
      
      tempVar = [tempVar currentLine( currentIdx )];
      currentIdx = currentIdx + 1;
      
  end

  
  if( isempty(str2num(tempVar)) )
     data_valIdx =   tempVar ; 
  else
     data_valIdx(valIdx) =   str2num( tempVar ); 
  end
  

end