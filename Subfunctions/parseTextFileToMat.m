function parseTextFileToMat (textFileName)

    matFileName = [ textFileName '.mat']
    if (~exist(matFileName, 'file'))

        fprintf('.mat File Not Found Parsing The TextFile %s\n', textFileName);

        textFileStruct = parseTextFiletoStruct(textFileName);

        structHandler = {textFileStruct};
%         %createMatFile(structHandler);
%         save ('MyMatFile.mat', 'structHandler')
%     else
%         fprintf('.mat File Found ==> %s.mat\n', textFileName);
%         load MyMatFile.mat
        createMatFile (structHandler, textFileName)
        fprintf ('%s File Created\n', matFileName)

    else
        load(matFileName)
        fprintf('.mat File found and loaded!! \n')
    end

end
