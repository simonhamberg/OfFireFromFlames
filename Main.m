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
clf; clc;
treeRadius = 2;
forestSize = [1000,1000];
treeOffset = 0;
trees = 5000;
initFireRadius = 10;
criticalRadius = 70;
probabilityConstant = criticalRadius^2/2 ;

[n,N] = size(forestPos);
plot(forestPos(1,:),forestPos(2,:),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
isBurning = false(N,1);
isWater = false(N,1);

windScaleParam = zeros(N,N);

%windAngle = 2*pi*rand; %Randomize start angle
windAngle = pi/6;
windAngleAlterations = 1;

windStrength = 100.*rand; %Rand strength between 0 and 3;
windStrengthAlterations = 10;

[x,y] = ginput(1);
a = [x,y];
d = zeros(N,1);

angleMatrix = getAngleMatrix(a);

for i = 1:N
    d(i) = norm(forestPos(:,i) - a');
    if d(i) <= initFireRadius
        isBurning(i) = true;
    end
end

hold on
for i = 1:N
    if isBurning(i)
        plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 130 0],'MarkerSize',treeRadius*2);
    end
end
%--------------------------------------------------------------------------
%Simulation start:
simFrames = 1000; %Number of iterations
waterStart = 100; %Starts after "waterStart" iterations
waterStop = 150;
waterBombXpos = 100;
wasBurning = false(N,1);
r_gb = 120;
for iteration = 1:simFrames
    pause(0.0001);
    wasBurning = isBurning + wasBurning;

    %Wind calculations
    if mod(iteration,windAngleAlterations) == 0
        deltaAngle =  normrnd(0,pi/6);
        windAngle = windAngle + deltaAngle;
    end

    %Alternate windStrength a bit more often than windAngle
     if mod(iteration,windStrengthAlterations) == 0
        %Create random small strength alteration
        deltaStrength = (2*rand(1,1)-1)/windStrengthAlterations;

        %Limit strength to 3x
        if (windStrength + deltaStrength) < 1/3 * probabilityConstant
            windStrength = 1/3 * probabilityConstant;
        elseif (windStrength + deltaStrength) > 3 * probabilityConstant
            windStrength = 3*probabilityConstant;
        else
            windStrength = windStrength + deltaStrength;
        end
    end

    %Create a matrix that will either increase or decrease probability of
    %spread between two trees depending on angle between them and the angle of
    %the wind
    windMatrix = zeros(N,1);
    for i = 1:N
            windMatrix(i,1) = getWindScaleParameter(angleMatrix(i,1),windAngle, windStrength);
    end

    %Spreads the fire
    %     newBurnetTrees = false(1,trees);
    newBurnetTrees = isBurning;
    for i = 1:N
        if isBurning(i)
            temp = fireSpread(i,distanceMat,probabilityConstant,criticalRadius,windMatrix(i,1));
            for i1 = 1:length(temp)
                newBurnetTrees(temp(i1),1) = true;
            end
        end
    end
    
    newBurnetTrees = newBurnetTrees - isBurning;
    isBurning = newBurnetTrees;
    



    if mod(iteration,5)==0 %Gör vattenbombning varje 5 iterationer (subject to change)
        [lineEnd,lineStart]=getWaterBombDirection(x1,x2,y1,y2); %x1,y1 är koordinater för ett träd som nyss börjat brinna och x2,y2 är koordinater 
        %för eldens start position. Vet inte exakt hur man får det än.
        waterTrees=waterBombTrees(lineStart,lineEnd,forestPos,50);
        for i =1:length(waterTrees)
            isWater(waterTrees(i))=true;
            isBurning(waterTrees(i))=false;
        end
    end

    %Graphics
    %     if iteration > waterStart && iteration < waterStop
    %         waterBombing = true;
    %     else
    %         waterBombing = false;
    %     end

    %     %Temporary until new waterbombing function
    %     if waterBombing
    %         coords = WaterBomb(10,100*(iteration-waterStart));
    %         plot(10,abs(coords),'.','color','b');
    %     end
    %
    changeInForest = false;
    for i = 1:N
        
        if isBurning(i) && wasBurning(i) == false
            wasBurning(i,simFrames + 1) = isBurning(i);
            if r_gb<0
                r_gb = 0;
            end
            plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 r_gb 0],'MarkerSize',treeRadius*2);
            changeInForest = true;
        end
        
        if wasBurning(i)
            plot(forestPos(1,i),forestPos(2,i),'.','color',[.7 .7 .7],'MarkerSize',treeRadius*2);
        end       
        
    end
    r_gb = r_gb - 25;
    iteration
    if ~changeInForest %added
        disp('No more trees are burning')
        break
    end
end
