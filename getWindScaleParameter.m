%Get wind angle 
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Oscar Karlsson

function windScale  = getWindScaleParameter(tree1,tree2,windAngle, windStrength)

%Angle between two trees in radians
treeAngle = atan((tree2(2)-tree1(2))/(tree2(1)-tree1(1)));

if (abs(treeAngle-windAngle) < pi/2)
    %Tree is in the wind generall direction -> increase likelyhood of
    %spread
    windScale = windStrength;
else
    %Tree is in opposite direction of wind -> lower probability of spread
    windScale = 1/windStrength;
end