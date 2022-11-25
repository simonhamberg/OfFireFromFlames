%Get wind angle 
%Course [FFR120]
%Group Anacondas
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Author: Oscar Karlsson

%forestPos = readmatrix('Forest.csv');
%[n,N] = size(forestPos);

windScaleParam = zeros(N,N);

windAngle = 2*pi*rand(1,1); %Randomize start angle
windAngleAlterations = 10;

windStrength = 3.*rand(N,1); %Rand strength between 0 and 3;
windStrengthAlterations = 20;


%Alternate wind angle and strength 10 respectively 20 times in total
if mod(iteration,windAngleAlterations) == 0
    %Create random small angle alternation
    deltaAngle=2*rand(1,1)-1;
    deltaAngle = deltaAngle*pi/100; %Make sure the alternation is small
    windAngle = windAngle + deltaAngle;
end

%Alternate windStrength a bit more often than windAngle
if mod(iteration,windStrengthAlterations) == 0 
    %Create random small strength alteration
    deltaStrength = (2*rand(1,1)-1)/windStrengthAlterations;
    
    %Limit strength to 3x
    if (windStrength + deltaStrength) < 1/3
        windStrength = 1/3; 
    elseif (windStrength + deltaStrength) > 3
        windStrength = 3;
    else
        windStrength = windStrength + deltaStrength;
    end
end



%Create a matrix that will either increase or decrease probability of
%spread between two trees depending on angle between them and the angle of
%the wind

for i = 1:N
    for j = 1:N
        windMatrix(i,j) = getWindScaleParameter(forestPos(:,i),forestPos(:,j),windAngle, windStrength);
    end
end
