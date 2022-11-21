%Start a fire
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Tim Johansson
clc; clear; clf;

treeRadius = 2;
forestSize = [1000,1000];
treeOffset = 0;
trees = 5000;
initFireRadius = 100;

forestPos = readmatrix('Forest.csv');
[n,N] = size(forestPos);
plot(forestPos(1,:),forestPos(2,:),'.','color','g','MarkerSize',treeRadius*2);
isBurning = false(N,1);

%https://se.mathworks.com/help/matlab/ref/matlab.graphics.shape.internal.datacursormanager.html

[x,y] = ginput(1);
a = [x,y];

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
