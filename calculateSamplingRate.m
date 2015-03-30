function [sessionData] = calculateSamplingRate(sessionData)


globalSumOfMeanFrameTimes = 0;

for trIdx = 1:sessionData.expInfo.numTrials
    
    
    
    globalSumOfMeanFrameTimes  = globalSumOfMeanFrameTimes ...
        + mean(diff(sessionData.rawData_tr(trIdx).frameTime_fr));
    
end

%%

sessionData.expInfo.meanFrameDur = globalSumOfMeanFrameTimes ./ sessionData.expInfo.numTrials;
sessionData.expInfo.meanFrameRate = 1 / sessionData.expInfo.meanFrameDur;