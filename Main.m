%Main
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Authors: ...
clc; clear; clf;

%Read
%--------------------------------------------------------------------------
forestPos = readmatrix('Forest.csv');
distanceMat = readmatrix('DistanceMatrix.csv');

%% Start a fire
%--------------------------------------------------------------------------
%Author: Tim Johansson

%Local parameters
treeRadius = 2;
forestSize = [1000,1000];
treeOffset = 0;
trees = 5000;
initFireRadius = 10;

[n,N] = size(forestPos);
plot(forestPos(1,:),forestPos(2,:),'.','color','g','MarkerSize',treeRadius*2);
isBurning = false(N,1);

[x,y] = ginput(1);
a = [x,y];
d = zeros(N,1);

for i = 1:N
    d(i) = norm(forestPos(:,i) - a');
    if d(i) <= initFireRadius
        isBurning(i) = true;
    end 
end

hold on
for i = 1:N
    if isBurning(i)
        plot(forestPos(1,i),forestPos(2,i),'.','color','r','MarkerSize',treeRadius*2);
    end    
end
%--------------------------------------------------------------------------
%Simulation start:
simFrames = 1000; %Number of iterations
waterStart = 100; %Starts after "waterStart" iterations
waterStop = 150;
waterBombXpos = 100;

for iteration = 1:simFrames
    pause(0.0001);
    
    
    
    
    
    
    
    
    
    
    
    %Graphics
    if iteration > waterStart && iteration < waterStop
        waterBombing = true;
    else
        waterBombing = false;
    end
    
%     %Temporary until new waterbombing function
%     if waterBombing
%         coords = WaterBomb(10,100*(iteration-waterStart));
%         plot(10,abs(coords),'.','color','b');
%     end
%     
    for i = 1:N
        if isBurning(i)
            plot(forestPos(1,i),forestPos(2,i),'.','color','r','MarkerSize',treeRadius*2);
        end
    end
       
    iteration
end
