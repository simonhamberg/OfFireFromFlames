clear;
clc;
clf;
close all; %askdnoasnda askdmp a
N = 16; %Grid size
p = 0.01; %Chance of tree growth
f = 0.2; %Chance of lightning
T = 10^4;
forest = ones(N); %1 for empty
change = 0;
fireCount = 0;
iTree = 0;
jTree = 0;
iLight = 0;
jLight = 0;
hold on
cmap = zeros(4,3);
cmap = [0.5, 0.5, 0.5; ... %Gray for empty
        0, 1, 0; ... %Green for tree
        1, 1, 0; ... %Yellow for lightning strike
        1, 0, 0]; %Red for Burning
image(forest);
colormap(cmap)

fireList = [];
fireSizeList = [];
sizeCount = 0;
for t = 1:T

    r = rand;
    if r < p %Tree grows
       iTree = randi(N);
       jTree = randi(N);
       forest(iTree,jTree) = 2;
       image(forest);
       colormap(cmap)
       pause(0.1)
     end

    r = rand;
    if r < f    %Lightning strikes
       iLight = randi(N);
       jLight = randi(N);
    end
if (iTree ~= 0) && (jTree ~=0)
    if (iTree == iLight) && (jTree == jLight)
        fireCount = fireCount + 1;
        forest(iLight,jLight) = 3;
        fireList(fireCount,1) = iLight;
        fireList(fireCount,2) = jLight;
        change = true;

        while change
            change = false;

            for a = 1:size(fireList,1)
                i = fireList(a,1);
                j = fireList(a,2);

               if (forest(max(i-1,1),j)) == 2
                   forest(max(i-1,1),j) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = max(i-1,1);
                   fireList(fireCount,2) = j;
                   change = true;
               end
               if (forest(min(i+1,N),j)) == 2
                   forest(min(i+1,N),j) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = min(i+1,N);
                   fireList(fireCount,2) = j;
                   change = true;
               end
               
               if (forest(i,max(j-1,1))) == 2
                   forest(i,max(j-1,1)) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = i;
                   fireList(fireCount,2) = max(j-1,1);
                   change = true;
               end
               if (forest(i,min(j+1,N))) == 2
                   forest(i,min(j+1,N)) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = i;
                   fireList(fireCount,2) = min(j+1,N);
                   change = true;
               end

               if ((i == N) && (forest(1,j) == 2))
                   forest(1,j) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = 1;
                   fireList(fireCount,2) = j;
                   change = true;
               end
               if ((j == N) && (forest(i,1) == 2))
                   forest(i,1) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = i;
                   fireList(fireCount,2) = 1;
                   change = true;
               end
               if ((i == 1) && (forest(N,j) == 2))
                   forest(N,j) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = N;
                   fireList(fireCount,2) = j;
                   change = true;
               end
               if ((j == 1) && (forest(i,N) == 2))
                   forest(i,N) = 4;
                   fireCount = fireCount + 1;
                   fireList(fireCount,1) = i;
                   fireList(fireCount,2) = N;
                   change = true;
               end
            end
        end
        image(forest);
        colormap(cmap)
        pause(0.5)
        forest(iLight,jLight) = 4;
        for k = 1:size(fireList,1) %Delete the burned trees from grid
            forest(fireList(k,1),fireList(k,2)) = 1;
        end
        image(forest);
        colormap(cmap)
        pause(0.1)
        sizeCount = sizeCount + 1;
        fireSizeList(sizeCount,1) = fireCount;
    end
    fireCount = 0;
    fireList  = [];

end
end
figure
histogram(fireSizeList)
