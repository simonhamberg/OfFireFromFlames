%Author Johan Rumar Karlquist
function indexWaterBombTrees = waterBombTrees(lineStart,lineEnd,forestPos,bombRadius)
    lineDistance=ones(5000,1)*(bombRadius+1);
    indexWaterBombTrees=[];
    for i=1:5000
        lineDistance(i)=distanceToLine(forestPos(:,i)',lineStart,lineEnd);
    end
    for i=1:5000
        if lineDistance(i)<bombRadius
            indexWaterBombTrees(length(indexWaterBombTrees)+1)=i;
        end
    end
end
