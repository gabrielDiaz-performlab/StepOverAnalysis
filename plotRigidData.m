function [] = plotRigidData(RigidData_fr_mkr_XYZ, color)

X = squeeze(RigidData_fr_mkr_XYZ(:,1));
Y = squeeze(RigidData_fr_mkr_XYZ(:,2));
Z = squeeze(RigidData_fr_mkr_XYZ(:,3));

plot3(X,Y,Z,'Color',color,'LineWidth',3);hold on;
   
end