function indexWaterBombTrees = waterBombTrees(x,y,axis,range,forestPos,bombRadius)
    %axis=1 motsvarar waterbombning i x-led, och axis=2 waterbombning i y-led
    %Väldigt enkel för tillfället, borde kunna generalisera detta till linje i vilken 
    %orientering som helst, genom att beräkna "line to point distance".
    distanceToLine=ones(5000,1)*(bombRadius+1);
    indexWaterBombTrees=[];
    for i=1:5000
        if abs(forestPos(axis,i)-y)<range
            distanceToLine(i)=abs(x-forestPos(3-axis,i));
        end
    end
    for i=1:5000
        if distanceToLine(i)<bombRadius
            indexWaterBombTrees(length(indexWaterBombTrees)+1)=i;
        end
    end
end
