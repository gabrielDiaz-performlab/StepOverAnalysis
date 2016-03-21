function per = findFootPercent(x,Data)

if isempty(Data)
    per = 0;
else
    A = Data(1);
    B = Data(2);
    per = 100*(x - A)/(B - A);

end