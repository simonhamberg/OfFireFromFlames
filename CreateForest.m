%Create forest 
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Tim Johansson
clc; clear; clf;

%Parameters [m]
treeRadius = 2;
forestSize = [1000,1000];
treeOffset = 0;
trees = 5000;

%Initialization
p = zeros(2,trees);

for i = 1:trees
    p(1,i) = (forestSize(1)-1).*rand;
    p(2,i) = (forestSize(2)-1).*rand;
    k = 0;
    while k < 2
        for j = 1:i
            if i == 1
                k = 2;
            end
            if i ~= j
                if  norm(p(:,i) - p(:,j)) < treeRadius + treeOffset
                    p(1,i) = (forestSize(1)-1).*rand;
                    p(2,i) = (forestSize(2)-1).*rand;
                else
                    k = k + 1;
                end
            end
        end       
    end
end

plot(p(1,:),p(2,:),'.','color','g','MarkerSize',treeRadius*2);
%% 
csvwrite('Forest.csv',p);
