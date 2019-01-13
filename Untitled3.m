clear
clc

%%
% degree = 2;
% knotVector = [0,0,0,1,2,3,4,4,5,5,5];
% u = 5/2;
% [basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);

%%
% degreeU = 2;
% knotVectorU = [0,0,0,1,2,3,4,4,5,5,5];
% u = 5/2;
% degreeV = 2;
% knotVectorV = [0,0,0,1,2,3,4,4,5,5,5];
% v = 5/2;
% cvPtX = rand(7,7);
% cvPtY = rand(7,7);
% cvPtZ = rand(7,7);
% weightVector = rand(7,7);
% surfacePt = NurbsSrfPt(u, degreeU, knotVectorU, v, degreeV, knotVectorV, cvPtX, cvPtY, cvPtZ, weightVector);

%%
U = linspace(0,1);
% U = 0;
% U = 1;
% U = 1/2;
curve = zeros(length(U),2);
for i = 1:length(U)
u = U(i);
degree = 3;
knotVector = [0, 0, 0, 0, 1, 1, 1, 1];
cvPtX = [-0.083270996807659842,...
    2.7895783930565914,...
    5.0378953068634038,...
    6.9531282334395685];
cvPtY = [0.020817749201915078,...
    -5.683245532122764,...
    6.4743200017955296,...
    -0.22899524122106429];
weightVector = ones(1,length(cvPtX));
curvePt = NurbsCrvPt(u, degree, knotVector, cvPtX, cvPtY, weightVector);
curve(i,:) = curvePt;
end