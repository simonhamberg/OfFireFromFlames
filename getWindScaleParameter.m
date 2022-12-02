%Get wind angle 
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Oscar Karlsson

function windScale  = getWindScaleParameter(treeAngle,windAngle, windStrength)

    %Tree is in the wind general direction -> increase likelyhood of
    %spread
if (abs(windAngle-treeAngle) < pi/4)
    windScale = windStrength;
else
    %Tree is in opposite direction of wind -> lower probability of spread
    windScale = 1/windStrength;
end
