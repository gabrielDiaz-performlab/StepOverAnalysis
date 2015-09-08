function [] = plotMarkersFromRigid(markerData_fr_mkr_XYZ, color)

markerData_fr_mkr_XYZ = cell2mat(permute(markerData_fr_mkr_XYZ,[2 3 1]));

for mIdx = 1:size(markerData_fr_mkr_XYZ,3)
    
   X = squeeze(markerData_fr_mkr_XYZ(:,1,mIdx));
   Y = squeeze(markerData_fr_mkr_XYZ(:,2,mIdx));
   Z = squeeze(markerData_fr_mkr_XYZ(:,3,mIdx));
   
   scatter3(X,Y,Z,10,color);hold on;
   
end
end