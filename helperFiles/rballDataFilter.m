function outputData = rballDataFilter(inputData);

loadParameters;

if( rem(gaussFiltSize,2) ~= 1  || rem(medFiltSize,2) ~= 1)
    beep
    display('Error! Filter parameter s must be an odd number.')
    return
end

inputData  = medfilt1(inputData,medFiltSize);

filter = fspecial('gaussian',[gaussFiltSize 1], gaussSdev);  % gaussian kernel where s= size of contour

outputData = conv(inputData,filter,'same');