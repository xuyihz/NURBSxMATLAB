clear
clc

%% varify BasisFuns
degree = 2;
knotVector = [0,0,0,1,2,3,4,4,5,5,5];
u = 5/2;
[basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);

%% Surface
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

%% Curve
% U = linspace(0,1);
% % U = 0;
% % U = 1;
% % U = 1/2;
% curve = zeros(length(U),2);
% for i = 1:length(U)
% u = U(i);
% degree = 3;
% knotVector = [0, 0, 0, 0, 1, 1, 1, 1];
% cvPtX = [0.084641712804496352,...
%     3.3218617663495729,...
%     6.9286011411941901,...
%     2.3699679585258182];
% cvPtY = [0.063481284603371504,...
%     5.0654020277678935,...
%     -3.0670589716973753,...
%     -3.9570000736100668];
% weightVector = ones(1,length(cvPtX));
% curvePt = NurbsCrvPt(u, degree, knotVector, cvPtX, cvPtY, weightVector);
% curve(i,:) = curvePt;
% end