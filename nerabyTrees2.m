function sortedVector = nerabyTrees2(m,i,j,criticalRadius)
sortedVector=zeros(2,length(m)); %x,y
sortedVector(1,1) = i;
sortedVector(2,1) = j;
sortedVectorIterator = 2;
for i1 = 1:length(m)
    if( abs(m(i1,j) ) <= criticalRadius)
            sortedVector(1,sortedVectorIterator) = i1;
            sortedVector(2,sortedVectorIterator) = j;
            sortedVectorIterator = sortedVectorIterator + 1;
    end
end
