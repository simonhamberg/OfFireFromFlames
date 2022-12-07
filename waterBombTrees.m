%Author Johan Rumar Karlquist
function indexWaterBombTrees = waterBombTrees(lineStart,lineEnd,forestPos,bombRadius,N)
    lineDistance=ones(N,1)*(bombRadius+1);
    indexWaterBombTrees=[];
    for i=1:N
        lineDistance(i)=distanceToLine(forestPos(:,i)',lineStart,lineEnd);
    end
    for i=1:N
        if lineDistance(i)<bombRadius
            indexWaterBombTrees(length(indexWaterBombTrees)+1)=i;
        end
    end
end
