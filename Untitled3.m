clear
clc
degree = 2;
knotVector = [0,0,0,1,2,3,4,4,5,5,5];
u = 4;
knotspanIndex = FindSpan(u, degree, knotVector);
basisFunValue = BasisFuns(u, knotspanIndex, degree, knotVector);