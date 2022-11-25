%Author Johan Rumar Karlquist
function indexWaterBombTrees = waterBombTrees(lineStart,lineEnd,forestPos,bombRadius)
    distanceToLine=ones(5000,1)*(bombRadius+1);
    indexWaterBombTrees=[];
    for i=1:5000
        numerator = abs((lineEnd(1) - lineStart(1)) * (lineStart(2) - forestPos(2,i))... 
        - (lineStart(1) - forestPos(1,i)) * (lineEnd(2) - lineStart(2)));
 
        denominator = sqrt((lineEnd(1) - lineStart(1)) ^ 2 + (lineEnd(2) - lineStart(2)) ^ 2);
        
        distanceToLine(i)=numerator./denominator;
    end
    for i=1:5000
        if distanceToLine(i)<bombRadius
            indexWaterBombTrees(length(indexWaterBombTrees)+1)=i;
        end
    end
end
