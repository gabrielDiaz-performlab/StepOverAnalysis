function hline = hline( yLoc, lineColor,width ,linestyle)

if(nargin == 1 )
    line( xlim, [yLoc yLoc], 'Color','r','LineWidth', 2);
elseif(nargin == 2 )
    line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', 2);
elseif(nargin == 3 )
    line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', width)
elseif( nargin == 4 )
    line( xlim, [yLoc yLoc], 'Color',lineColor,'LineWidth', width,'LineStyle',linestyle)
end
