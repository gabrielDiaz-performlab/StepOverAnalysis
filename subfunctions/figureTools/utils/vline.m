function vline = vline( xLoc, lineColor, width,linestyle)

if(nargin == 1 )
    line( [xLoc xLoc], ylim, 'Color','r','LineWidth', 2);
elseif(nargin == 2 )
    line( [xLoc xLoc], ylim, 'Color',lineColor,'LineWidth', 2);
elseif(nargin == 3 )
    line( [xLoc xLoc], ylim, 'Color',lineColor,'LineWidth', width)
elseif( nargin == 4 )
    line( [xLoc xLoc], ylim, 'Color',lineColor,'LineWidth', width,'LineStyle',linestyle)
end
