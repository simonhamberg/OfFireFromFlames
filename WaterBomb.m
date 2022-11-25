function  coords = WaterBomb(range,target)
    coords = zeros(1,range);
    for i = 1:range 
        coords(1,i) = target - range * (2*rand-1);
    end
    
end