clear
clc

%% varify BasisFuns
% degree = 2;
% knotVector = [0,0,0,1,2,3,4,4,5,5,5];
% u = 5/2;
% [basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);

%% Surface
degreeU = 3;
knotVectorU = [0, 0, 0, 0, 1, 1, 1, 1];
u = linspace(0,1);
degreeV = 3;
knotVectorV = [0, 0, 0, 0, 1, 1, 1, 1];
v = linspace(0,1);
weightVector = ones(length(knotVectorV)-degree-1,length(knotVectorU)-degree-1);

cvPtX = rand(4,4);
cvPtY = rand(4,4);
cvPtZ = rand(4,4);
surfacePt = NurbsSrfPt(u, degreeU, knotVectorU, v, degreeV, knotVectorV, cvPtX, cvPtY, cvPtZ, weightVector);

%% Curve
% U = linspace(0,1);
% curve = zeros(length(U),2);
% degree = 3;
% knotVector = [0, 0, 0, 0, 1, 1, 1, 1];
% weightVector = ones(1,length(knotVector)-degree-1);
% for i = 1:length(U)
% u = U(i);
% cvPtX = [0.084641712804496352,...
%     3.3218617663495729,...
%     6.9286011411941901,...
%     2.3699679585258182];
% cvPtY = [0.063481284603371504,...
%     5.0654020277678935,...
%     -3.0670589716973753,...
%     -3.9570000736100668];
% curvePt = NurbsCrvPt(u, degree, knotVector, cvPtX, cvPtY, weightVector);
% curve(i,:) = curvePt;
% end
% plot(curve(:,1),curve(:,2));
