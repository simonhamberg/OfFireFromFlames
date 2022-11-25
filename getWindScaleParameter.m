%Get wind angle 
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Oscar Karlsson

function windScale  = getWindScaleParameter(treeAngle,windAngle, windStrength)

if (abs(treeAngle-windAngle) < pi/2)
    %Tree is in the wind generall direction -> increase likelyhood of
    %spread
    windScale = windStrength;
else
    %Tree is in opposite direction of wind -> lower probability of spread
    windScale = 1/windStrength;
end
