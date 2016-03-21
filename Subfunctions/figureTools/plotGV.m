function handleOUT = plotGV(handleIN, headPos, gazePoint, frIdx)

if isgraphics(handleIN,'Figure');
    handleOUT = line([headPos(frIdx,1) gazePoint(frIdx,1)],...
        [headPos(frIdx,2) gazePoint(frIdx,2)],...
        [headPos(frIdx,3) gazePoint(frIdx,3)],...
        'LineWidth',2.5,'Color',[0 1 1]);
else
    
    handleOUT = handleIN;
    handleOUT.XData = [headPos(frIdx,1) gazePoint(frIdx,1)];
    handleOUT.YData = [headPos(frIdx,2) gazePoint(frIdx,2)];
    handleOUT.ZData = [headPos(frIdx,3) gazePoint(frIdx,3)];
    
end
end