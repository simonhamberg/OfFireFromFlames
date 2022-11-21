function sortedVector = nerabyTrees2(m,i,criticalRadius)
sortedVector=zeros(1,length(m)); %i
sortedVector(1,1) = i;
sortedVectorIterator = 2;
for i1 = 1:length(m)
    if( abs(m(i1,i) ) <= criticalRadius)
            sortedVector(1,sortedVectorIterator) = i1;
            sortedVectorIterator = sortedVectorIterator + 1;
    end
end
