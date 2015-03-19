function MinDist =  FindMinimumDistance(FootPos, Obstacle_XYZ, CrossingFrame)

% This Function Calculates the minimum distance to the obstacle while the
% subject is crossing over it.

% The number of Frames taken into account before and after the crossing Frame
OffsetFrame = 20;
P2 = Obstacle_XYZ;

for i = -OffsetFrame:OffsetFrame
    P1 = FootPos(CrossingFrame + i,:);
    D(i+OffsetFrame+1) = EuclideanDistance(P1,P2);
end

MinDist = min(D);