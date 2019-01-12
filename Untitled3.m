clear
clc
% degree = 2;
% knotVector = [0,0,0,1,2,3,4,4,5,5,5];
% u = 2.5;
% [basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);
degreeU = 2;
knotVectorU = [0,0,0,1,2,3,4,4,5,5,5];
u = 2.5;
degreeV = 2;
knotVectorV = [0,0,0,1,2,3,4,4,5,5,5];
v = 2.5;
cvPtX = rand(7,7);
cvPtY = rand(7,7);
cvPtZ = rand(7,7);
weightVector = rand(7,7);
surfacePt = NurbsSrfPt(u, degreeU, knotVectorU, v, degreeV, knotVectorV, cvPtX, cvPtY, cvPtZ, weightVector);