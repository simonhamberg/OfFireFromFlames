%Author Oscar Karlsson
function treeAngle  = getAngleMatrix(tree1,tree2)
    treeAngle = atan((tree2(2)-tree1(2))/(tree2(1)-tree1(1)));
end
