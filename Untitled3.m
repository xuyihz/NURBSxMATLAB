clear
clc
degree = 2;
knotVector = [0,0,0,1,2,3,4,4,5,5,5];
u = 2.5;
knotspanIndex = FindSpan(u, degree, knotVector);
[basisFunValue, dersBasisFunValue] = BasisFuns(u, knotspanIndex, degree, knotVector);