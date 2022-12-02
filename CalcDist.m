%Calculate distance
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Tim Johansson
clc; clear; clf;

forestPos = readmatrix('Forest.csv');

[n,N] = size(forestPos);
distance = zeros(N,N);

%Create a distance matrix
for i = 1:N
    for j = 1:N
        distance(i,j) = getDistance(forestPos(:,i),forestPos(:,j));
    end
end

csvwrite('DistanceMatrix.csv', distance);
%save('DistanceMatrix', 'distance');
