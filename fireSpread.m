%%Author Gabriel Vevang

function burningTreeVector = fireSpread(burningTree,distanceMatrix,probabilityConstant,criticalRadius,Wind)
nearbyTrees = nerabyTrees2(distanceMatrix,burningTree,criticalRadius);
burningTreeVector = zeros(1,length(nearbyTrees));
%probabilityConstant = 5; %Constant, currently 0.2 if tree 5 meters away
i2 = 1;
for i = 1:length(nearbyTrees)-1
    distance = distanceMatrix(burningTree,nearbyTrees(i+1));
    windImpact = Wind(burningTree,nearbyTrees(i+1));
    Probability = 1/distance^2*probabilityConstant*windImpact; 
    if (Probability > rand)
        burningTreeVector(i2) = nearbyTrees(i2+1);
        i2 = i2 + 1;
    end
end
burningTreeVector = burningTreeVector(1:i2-1);
