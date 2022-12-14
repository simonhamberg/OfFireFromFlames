%%Author Gabriel Vevang

function burningTreeVector = fireSpread(burningTree,distanceMatrix,probabilityConstant,criticalRadius,Wind)
    nearbyTrees = nerabyTrees2(distanceMatrix,burningTree,criticalRadius);
    burningTreeVector = zeros(1,length(nearbyTrees));
    i2 = 1;
    for i = 1:length(nearbyTrees)-1
        distance = distanceMatrix(burningTree,nearbyTrees(i+1));
        Probability = 1/(distance)^4*probabilityConstant*Wind; 
        if (Probability > rand)
            burningTreeVector(i2) = nearbyTrees(i+1);
            i2 = i2 + 1;
        end
    end
    burningTreeVector = burningTreeVector(1:i2-1);
