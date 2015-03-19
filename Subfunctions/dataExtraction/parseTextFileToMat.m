function parseTextFileToMat (sessionNumber)
    
    loadParameters
    textFileName = dataFileList{sessionNumber};
    
    structFileName  = [ structFileDir textFileName '-struct.mat'];
    
    %% See if the txt has been parsed into a struct saved in a *.mat file.
    if (~exist(structFileName, 'file'))

        %fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);
        fprintf('Could not find struct file %s. Parsing text file...\n', structFileName);
        
        textFileStruct = parseTextFiletoStruct(textFileName);
        
        save( structFileName, textFileStruct);
       
        fprintf ('Struct file %s.mat created from text file\n', structFileName)

    else
        load(structFileName)
        fprintf('Loaded struct version of text data from %s\n',structFileName)
    end

    %% Now, see if the struct has been parsed into a sessionData file.
    
    sessionFileName = [ sessionFileDir textFileName '.mat'];
    
    if (~exist(sessionFileName, 'file'))
    
        structHandler = {textFileStruct};
        createMatFile(structHandler, textFileDir, textFileName,sessionFileDir)
        fprintf ('Session file %s.mat created \n', sessionFileName)

    else
        load([sessionFileDir textFileName '.mat'])
        fprintf('Loaded session data file from %s\n',sessionFileName)
    end

end
