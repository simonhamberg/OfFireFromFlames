% %Author Oscar Karlsson
function treeAngle = getAngleMatrix(a,forestPos)
[n,N] = size(forestPos);
treeAngle = zeros(N,1);
%Create a distance matrix
for i = 1:N
        treeAngle(i,1) = atan2((forestPos(2,i)-a(2)),(forestPos(1,i)-a(1)));
end
