%% Compute point on non-uniform rational B-spline curve
% Input:  u, degree, knotVector, cvPt(X,Y), weightVector
% Output: point on non-uniform rational B-spline curve
% it doesn't work at special case.
% Xu Yi, 2019

%%
function [curvePt, dersCurvePt] = NurbsCrvPt(u, degree, knotVector, cvPtX, cvPtY, cvPtZ, weightVector)
% u
knotspanIndex = FindSpan(u, knotVector);
[basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);
% w.*P
WcvPtX = cvPtX.* weightVector;
WcvPtY = cvPtY.* weightVector;
WcvPtZ = cvPtZ.* weightVector;
if knotspanIndex == length(knotVector) - degree % special case
    PtX = cvPtX(end);
    PtY = cvPtY(end);
    PtZ = cvPtZ(end);
else
    W = basisFunValue(end,:)...
        * ( weightVector( (knotspanIndex-degree):knotspanIndex )' ); % 此处与surface不同
    PtX = basisFunValue(end,:)...
        * ( WcvPtX( (knotspanIndex-degree):knotspanIndex )' )...
        / W;
    PtY = basisFunValue(end,:)...
        * ( WcvPtY( (knotspanIndex-degree):knotspanIndex )' )...
        / W;
    PtZ = basisFunValue(end,:)...
        * ( WcvPtZ( (knotspanIndex-degree):knotspanIndex )' )...
        / W;
end
curvePt = [PtX, PtY, PtZ];
% derivative. The NURBS book 2nd page125 (4.8)
specialCase = 0;
if knotspanIndex == length(knotVector) - degree % special case / not work
    specialCase = 1;
    knotspanIndex = knotspanIndex -1;
    basisFunValue_temp = basisFunValue(end,:);
    basisFunValue(end,1) = 0;
    basisFunValue(end,2:end) = basisFunValue_temp(1:end-1);
    dersBasisFunValue_temp = dersBasisFunValue;
    for i = 1:degree
        dersBasisFunValue(i,1) = 0;
        dersBasisFunValue(i,2:end) = dersBasisFunValue_temp(i,1:end-1);
    end
    W = basisFunValue(end,:)...
        * ( weightVector( (knotspanIndex-degree):knotspanIndex )' );
end
% Aders
AdersX = genAders(WcvPtX, degree, knotspanIndex, basisFunValue, dersBasisFunValue);
AdersY = genAders(WcvPtY, degree, knotspanIndex, basisFunValue, dersBasisFunValue);
AdersZ = genAders(WcvPtZ, degree, knotspanIndex, basisFunValue, dersBasisFunValue);
% wders
wders = genWders(degree, W, dersBasisFunValue, weightVector, knotspanIndex);
% dersCurvePt
dersPtX = genDersPt(AdersX, PtX, degree, wders);
dersPtY = genDersPt(AdersY, PtY, degree, wders);
dersPtZ = genDersPt(AdersZ, PtZ, degree, wders);
if specialCase == 1
    dersPtX(2) = genSpecialCase(cvPtX, degree, knotVector, weightVector);
    dersPtY(2) = genSpecialCase(cvPtY, degree, knotVector, weightVector);
    dersPtZ(2) = genSpecialCase(cvPtZ, degree, knotVector, weightVector);
end
dersCurvePt = [dersPtX, dersPtY, dersPtZ];
end

function Aders = genAders(WcvPt, degree, knotspanIndex, basisFunValue, dersBasisFunValue)
Aders = zeros(degree+1,1);
Aders(1) = basisFunValue(end,:)...
    * ( WcvPt( (knotspanIndex-degree):knotspanIndex )' ); % 零阶导数
for i = 1:degree
    Aders(i+1) = dersBasisFunValue(i,:)...
        * ( WcvPt( (knotspanIndex-degree):knotspanIndex )' );
end
end
function wders = genWders(degree, W, dersBasisFunValue, weightVector, knotspanIndex)
wders = zeros(degree+1,1);
wders(1) = W;
for i = 1:degree
    wders(i+1) = dersBasisFunValue(i,:)...
        * ( weightVector( (knotspanIndex-degree):knotspanIndex )' );
end
end
function dersPt = genDersPt(Aders, Pt, degree, wders)
dersPt = zeros(degree+1,1);
dersPt(1) = Pt;
for i = 1:degree
    wPt = 0; % initialize
    for j = 1:i
        wPt_temp = factorial(i)/factorial(j)/factorial(i-j)...
            * wders(j+1) * dersPt(i-j+1);
        wPt = wPt + wPt_temp;
    end
    dersPt(i+1) = ( Aders(i+1) - wPt ) / wders(1);
end
end
function dersPt = genSpecialCase(cvPt, degree, knotVector, weightVector)
dersPt = degree / ( 1-knotVector(end-degree) )...
    * weightVector(end-1) / weightVector(end)...
    * ( cvPt(end) - cvPt(end-1) );
end
