%%Author Gabriel Vevang
function sortedVector = nerabyTrees2(distanceMatrix,chosenTreeIndex,criticalRadius)
    
    sortedVector=zeros(1,length(distanceMatrix)); 
    sortedVector(1,1) = chosenTreeIndex;
    sortedVectorIterator = 2;
    for i1 = 1:length(distanceMatrix)
        if( abs(distanceMatrix(i1,chosenTreeIndex) ) <= criticalRadius && i1 ~= chosenTreeIndex)
                sortedVector(1,sortedVectorIterator) = i1;
                sortedVectorIterator = sortedVectorIterator + 1;
        end
    end
    sortedVector = sortedVector(1:sortedVectorIterator-1);
