
function sessionData = cleanSessionData(sessionData)

try
    sessionData = rmfield(sessionData,'processedData_tr');
end

try
    sessionData =  rmfield(sessionData,'dependentMeasures_tr');
end

try
    sessionData =  rmfield(sessionData,'summaryStats');
end

