%Main
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Authors: ...

clc; clear; clf;

%Read
%--------------------------------------------------------------------------
forestPos = readmatrix('Newforest.csv');
distanceMat = readmatrix('DistanceMatrix2.csv');

%% Start a fire
%--------------------------------------------------------------------------
%Author: Tim Johansson
%Local parameters

clf;
%Comment out either angleMatrix on the row below or the row that creates it
%further down after you've loaded these 3 matrices
savedValues = zeros(100,1);
LivingTreeMatrix = zeros(100,1000);
for z1 = 1:100
    clearvars -except forestPos distanceMat z1 savedValues LivingTreeMatrix

    treeRadius = 2;
    forestSize = [1000,1000];
    treeOffset = 0;

    initFireRadius = 10;
    criticalRadius = 70;
    % probabilityConstant = criticalRadius^2/64 ;
    probabilityConstant = 10^4;

    [n,N] = size(forestPos);
    trees = N;
    % plot(forestPos(1,:),forestPos(2,:),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
    isBurning = zeros(N,1); %%false

    windScaleParam = zeros(N,N);

    %windAngle = 2*pi*rand; %Randomize start angle
    windAngle = pi/6;


    windAngleAlterations = 5;

    windStrength = 3.*rand;
    windStrength0 = windStrength;
    windStrengthAlterations = 10;

    % [x,y] = ginput(1);
    x   = 423.1951;
    y   = 545.7198;
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
    % for i = 1:N
    %     if isBurning(i) > 0
    %         plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 130 0],'MarkerSize',treeRadius*2);
    %     end
    % end
    %--------------------------------------------------------------------------
    %Simulation start:
    simFrames = 1000; %Number of iterations
    waterStart = 100; %Starts after "waterStart" iterations
    waterStop = 150;
    waterBombXpos = 100;
    for iteration = 1:simFrames
        %pause(0.0001);


        %Wind alternations
        if mod(iteration,windAngleAlterations) == 0
            deltaAngle =  normrnd(0,pi/24);
            if (windAngle + deltaAngle > 2*pi )
                windAngle = windAngle + deltaAngle - 2*pi ;
            elseif(windAngle + deltaAngle < 0 )
                windAngle = windAngle + deltaAngle + 2*pi ;
            else
                windAngle = windAngle + deltaAngle;
            end

        end

        %Windstrength alternations
        if mod(iteration,windStrengthAlterations) == 0
            deltaStrength = (2*rand(1,1)-1)/windStrengthAlterations;

            %Limit strength (Compared "Fresh breeze" to "Strong gale", see The Beaufort Wind Scale)
            %Wind speed would be a more accurate name
            if (windStrength + deltaStrength) < 1/3 * windStrength0
                windStrength = 1/3 * windStrength0;
            elseif (windStrength + deltaStrength) > 3 * windStrength0
                windStrength = 3*windStrength0;
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


        if mod(iteration,5)==0 && iteration > 19 %Gör vattenbombning varje 5 iterationer (subject to change)
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
                %Method 1
                                [lineEnd,lineStart]=getWaterBombDirection(forestPos(1,indexRandomBurningTree),a(1),...
                                   forestPos(2,indexRandomBurningTree),a(2));
                %Method2
%                 if (length(indexOldBurningTrees) ~= 0)
%                     indexRandomOldBurningTree=indexOldBurningTrees(randi([1,length(indexOldBurningTrees)]));
%                     [lineEnd,lineStart]=getWaterBombDirection(forestPos(1,indexRandomBurningTree),...
%                         forestPos(1,indexRandomOldBurningTree),forestPos(2,indexRandomBurningTree),...
%                         forestPos(2,indexRandomOldBurningTree));
%                 end
                %
                waterTrees=waterBombTrees(lineStart,lineEnd,forestPos,30,N);
                for i =1:length(waterTrees)
                    isBurning(waterTrees(i))=isBurning(waterTrees(i)) -20;
                end
            end
        end

        % %%
        %     %%Graphics
        %     clf;
        %     hold on
        %     plot(forestPos(1,:),forestPos(2,:),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
        %     title(['Iteration = ' num2str(iteration)]);
        %
        %     changeInForest = false;
        %     for i = 1:N
        %
        %         if isBurning(i) > 0 %&& wasBurning(i) == false
        %             if isBurning(i) == 5
        %                 plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 0 0],'MarkerSize',treeRadius*2);
        %             elseif isBurning(i) == 3
        %                 plot(forestPos(1,i),forestPos(2,i),'.','color',1/255*[255 160 0],'MarkerSize',treeRadius*2);
        %             elseif isBurning(i) == 1
        %                 plot(forestPos(1,i),forestPos(2,i),'.','color',[0 0 0],'MarkerSize',treeRadius*2);
        %             end
        %             changeInForest = true;
        %         elseif isBurning(i) == -1
        %             plot(forestPos(1,i),forestPos(2,i),'.','color',[.7 .7 .7],'MarkerSize',treeRadius*2);
        %         elseif isBurning(i) < -10
        %             plot(forestPos(1,i),forestPos(2,i),'.','color',[0 0 1],'MarkerSize',treeRadius*2);
        %         elseif (-10 < isBurning(i) &&  isBurning(i)< -1)
        %            plot(forestPos(1,i),forestPos(2,i),'.','color',[0 100/255 0],'MarkerSize',treeRadius*2);
        %          end
        %     end
        %
        %
        %
        %     %Wind plot
        %     u1 = forestPos;
        %     u2 = zeros(2,N);
        %     for i = 1:N
        %         u2(:,i) = u1(:,i).*sin(angleMatrix(i)).*windMatrix(i);
        %     end
        %     %quiver(u1(1,:),u1(2,:),u2(1,:),u2(2,:),'color','b');
        %     axis([0 1000 0 1000]);
        %
        %
        %     %Animation capture
        %     ax = gca;
        %     ax.Units = 'pixels';
        %     pos = ax.Position;
        %     ti = ax.TightInset;
        %     rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        %     Frame(iteration) = getframe(ax,rect);
        %
        %     if ~changeInForest %added
        %         disp('No more trees are burning')
        %         break
        %     end
        %
        %
        tempnumberOfDestroyedTrees = sum(isBurning==-1) + sum(isBurning == -21) + sum(isBurning == -11);
        LivingTreeMatrix(z1,iteration) = N - tempnumberOfDestroyedTrees;
    end
    numberOfDestroyedTrees = numel(find(isBurning==-1)) + sum(isBurning == -21) + sum(isBurning == -11);
    percDestrTrees = numberOfDestroyedTrees/N;
    disp([num2str(numberOfDestroyedTrees), ' trees was destroyed, in other words ', num2str(percDestrTrees*100), '%'])
    savedValues(z1) = percDestrTrees;
end
%%
% Check animation
% fps = 5;
% frameSpeed = fps/30;
%
% figure
% for i = 1:iteration
%     imshow(Frame(i).cdata)
%     pause(frameSpeed);
% end
%%
% myVideo = VideoWriter('myVideoFile'); %open video file
% myVideo.FrameRate = 5;  %can adjust this, 5 - 10 works well for me
% open(myVideo)
% %% Plot in a loop and grab frames
% for i = 1:iteration
%     imshow(Frame(i).cdata)
%     pause(frameSpeed);
%     writeVideo(myVideo, Frame(i).cdata);
% end
% close(myVideo)
%%
%% Plots
figure(2)
plot(1:simFrames, mean(LivingTreeMatrix));
hold on
%%
axis([0 100 0 1])
ylabel('Ratio of living trees over time', 'FontSize', 15,'Interpreter','latex');
xlabel('Time steps $\Delta t$', 'FontSize', 15,'Interpreter','latex');
