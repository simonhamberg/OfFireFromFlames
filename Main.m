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

clf;
%Comment out either angleMatrix on the row below or the row that creates it
%further down after you've loaded these 3 matrices
clearvars -except forestPos distanceMat

treeRadius = 2;
forestSize = [1000,1000];
treeOffset = 0;
trees = 5000;
initFireRadius = 10;
criticalRadius = 70;
probabilityConstant = criticalRadius^2/2 ;

[n,N] = size(forestPos);
plot(forestPos(1,:),forestPos(2,:),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
isBurning = zeros(N,1); %%false

windScaleParam = zeros(N,N);

%windAngle = 2*pi*rand; %Randomize start angle
windAngle = pi/6;
windAngleAlterations = 1;

windStrength = 100.*rand;
windStrengthAlterations = 10;

[x,y] = ginput(1);
a = [x,y];
d = zeros(N,1);

%Get all trees angles relative to the start position
angleMatrix = getAngleMatrix(a,forestPos);

for i = 1:N
    d(i) = norm(forestPos(:,i) - a');
    if d(i) <= initFireRadius
        isBurning(i) = 5;
    end
end

hold on
for i = 1:N
    if isBurning(i) > 0
        plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 130 0],'MarkerSize',treeRadius*2);
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
    

    %Wind alternations
    if mod(iteration,windAngleAlterations) == 0
        deltaAngle =  normrnd(0,pi/6);
        windAngle = windAngle + deltaAngle;
    end

    %Windstrength alternations
     if mod(iteration,windStrengthAlterations) == 0
        deltaStrength = (2*rand(1,1)-1)/windStrengthAlterations;

        %Limit strength (Compared "Fresh breeze" to "Strong gale", see The Beaufort Wind Scale)
        %Wind speed would be a more accurate name
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
    newBurnetTrees = isBurning;
    for i = 1:N
        if isBurning(i) > 0
            temp = fireSpread(i,distanceMat,probabilityConstant,criticalRadius,windMatrix(i,1));
            newBurnetTrees(i) = newBurnetTrees(i) - 2;
            for i1 = 1:length(temp)
                if (isBurning(temp(i1)) == 0)
                    newBurnetTrees(temp(i1),1) = 5;
                elseif (isBurning(temp(i1)) < -1 )
                    newBurnetTrees(temp(i1),1) = isBurning(temp(i1)) + 10;
                end
            end
        end
    end
    
    isBurning = newBurnetTrees;
    if mod(iteration,5)==0 %Gör vattenbombning varje 5 iterationer (subject to change)
        indexBurningTrees=[];
        indexOldBurningTrees=[];
        for i=1:N
            if (isBurning(i) == 5)
                indexBurningTrees(length(indexBurningTrees)+1)=i;
            end
            if (isBurning(i) == 1)
                indexOldBurningTrees(length(indexOldBurningTrees)+1)=i;
            end
        end
        if (length(indexBurningTrees) ~= 0)
            indexRandomBurningTree=indexBurningTrees(randi([1,length(indexBurningTrees)]));
            %[lineEnd,lineStart]=getWaterBombDirection(forestPos(1,indexRandomBurningTree),a(1),...
            %    forestPos(2,indexRandomBurningTree),a(2));
            %x1,y1 är koordinater för ett träd som nyss börjat brinna och x2,y2 är
            %koordinater för eldens start position. Vet inte exakt hur man får det än.
            if (length(indexOldBurningTrees) ~= 0)
               indexRandomOldBurningTree=indexOldBurningTrees(randi([1,length(indexOldBurningTrees)]));
               [lineEnd,lineStart]=getWaterBombDirection(forestPos(1,indexRandomBurningTree),...
                forestPos(1,indexRandomOldBurningTree),forestPos(2,indexRandomBurningTree),...
                forestPos(2,indexRandomOldBurningTree));
            end
            waterTrees=waterBombTrees(lineStart,lineEnd,forestPos,50);
                
            for i =1:length(waterTrees)
                isBurning(waterTrees(i))=isBurning(waterTrees(i)) -20;
            end
        end
    end


    %Graphics
    clf;
    hold on
    plot(forestPos(1,:),forestPos(2,:),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
    title(['Iteration = ' num2str(iteration)]);
    
    changeInForest = false;
    for i = 1:N
        
        if isBurning(i) > 0 %&& wasBurning(i) == false
            if isBurning(i) == 5
                plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 0 0],'MarkerSize',treeRadius*2);  
            elseif isBurning(i) == 3      
                plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 160 0],'MarkerSize',treeRadius*2);  
            elseif isBurning(i) == 1 
                plot(forestPos(1,i),forestPos(2,i),'.','color',[0 0 0],'MarkerSize',treeRadius*2); 
            end
            changeInForest = true;
        elseif isBurning(i) == -1
            plot(forestPos(1,i),forestPos(2,i),'.','color',[.7 .7 .7],'MarkerSize',treeRadius*2);
        elseif isBurning(i) < -10 
            plot(forestPos(1,i),forestPos(2,i),'.','color',[0 0 1],'MarkerSize',treeRadius*2);
        elseif (-10 < isBurning(i) &&  isBurning(i)< -1)
           plot(forestPos(1,i),forestPos(2,i),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
         end  
    end

    
    
    %Wind plot
    u1 = forestPos;
    u2 = zeros(2,N);
    for i = 1:N
        u2(:,i) = u1(:,i).*sin(angleMatrix(i)).*windMatrix(i);
    end
    %quiver(u1(1,:),u1(2,:),u2(1,:),u2(2,:),'color','b');
    axis([0 1000 0 1000]);
    
    
    %Animation capture
    ax = gca;
    ax.Units = 'pixels';
    pos = ax.Position;
    ti = ax.TightInset;
    rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
    Frame(iteration) = getframe(ax,rect);
    
    if ~changeInForest %added
        disp('No more trees are burning')
        break
    end
    
    
end
numberOfDestroyedTrees = numel(find(isBurning==-1));
percDestrTrees = numberOfDestroyedTrees/5000;
disp([num2str(numberOfDestroyedTrees), ' trees was destroyed, in other words ', num2str(percDestrTrees), '%'])

%% Check animation
fps = 30;
frameSpeed = fps/30;

figure
for i = 1:iteration
    imshow(Frame(i).cdata)
    pause(frameSpeed);
end
