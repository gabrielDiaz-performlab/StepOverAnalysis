function handleOUT = plotPt(handleIN, Pt, Pt_Color)

if isgraphics(handleIN,'Figure')
    handleOUT = scatter3(Pt(1),Pt(2),Pt(3),[],Pt_Color,'x','Filled','LineWidth',3);
elseif isgraphics(handleIN,'Scatter')
   handleOUT = handleIN;
   handleOUT.XData = Pt(1); handleOUT.YData = Pt(2); handleOUT.ZData = Pt(3); 
end


end