function [rotMats_fr_d1_d2] = quatVecToRotationMatVec(quat_fr_WXYZ,subIsWalkingUpAxis)

rotMats_fr_d1_d2 = zeros(length(quat_fr_WXYZ),4,4);

for frIdx = 1:length(quat_fr_WXYZ)
    
    %frInExpVec = frIdxList(mFrIdx);
    
    quat_WXYZ = squeeze(quat_fr_WXYZ(frIdx,:));
    
    if( subIsWalkingUpAxis == 0 )
        quat_WXYZ ([2 3]) = -quat_WXYZ([2 3]);
    end
    
    rotMats_fr_d1_d2(frIdx,:,:) = quaternion2matrix(quat_WXYZ);
    
end