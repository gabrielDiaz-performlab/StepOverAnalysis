function parsedTextFile =  parseTextFiletoStruct(textFileName)

    parsedTextFile = struct;

    fid = fopen([textFileName '.txt']);
    tline = fgets(fid);
    lineCount = 1;
    
    while ischar(tline)

        wordArray = '';
        charIdx = 1;
        wordIdx = 1;
        
        while (charIdx < numel(tline))

            word = '';
            
            while ( tline(charIdx) ~= ' ' && charIdx < numel(tline) )
                word = strcat(word, tline(charIdx));
                charIdx = charIdx + 1;
            end
            wordArray = [wordArray ' ' word];
            charIdx = charIdx + 1;
            wordIdx = wordIdx + 1;
        end
        
        field = ['line' num2str(lineCount)];
        parsedTextFile.(field) = wordArray;
        lineCount = lineCount + 1;
        tline = fgets(fid);
    end
    
end
