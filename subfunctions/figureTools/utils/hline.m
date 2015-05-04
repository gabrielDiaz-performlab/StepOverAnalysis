function hline = hline( yLoc, lineColor,width ,linestyle)

if(nargin == 1 )
    hline = line( xlim, [yLoc yLoc], 'Color','r','LineWidth', 2);
elseif(nargin == 2 )
    hline = line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', 2);
elseif(nargin == 3 )
    hline = line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', width);
elseif( nargin == 4 )
    hline = line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', width,'LineStyle',linestyle);
end
