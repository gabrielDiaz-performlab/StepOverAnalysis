function [] = plotMarkersFromRigid(figureHandle,markerData_fr_mkr_XYZ,color)




for mIdx = 1:size(markerData_fr_mkr_XYZ,2)
    
   X = squeeze(markerData_fr_mkr_XYZ(:,mIdx,1));
   Y = squeeze(markerData_fr_mkr_XYZ(:,mIdx,2));
   Z = squeeze(markerData_fr_mkr_XYZ(:,mIdx,3));
   
   scatter3( X,Y,Z,10,color)
   
end