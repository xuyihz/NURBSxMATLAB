%% Compute point on non-uniform rational B-spline curve
% Input:  u, degree, knotVector, cvPt(X,Y), weightVector
% Output: point on non-uniform rational B-spline curve
%
% Xu Yi, 2019

%%
function [curvePt, dersCurvePt] = NurbsCrvPt(u, degree, knotVector, cvPtX, cvPtY, weightVector)
% u
knotspanIndex = FindSpan(u, knotVector);
[basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector);
%
WcvPtX = cvPtX.* weightVector;
WcvPtY = cvPtY.* weightVector;
if knotspanIndex == length(knotVector) - degree % special case
    PtX = cvPtX(end);
    PtY = cvPtY(end);
else
    W = basisFunValue(end,:)...
        * ( weightVector( (knotspanIndex-degree):knotspanIndex )' ); % 此处与surface不同
    PtX = basisFunValue(end,:)...
        * ( WcvPtX( (knotspanIndex-degree):knotspanIndex )' )...
        / W;
    PtY = basisFunValue(end,:)...
        * ( WcvPtY( (knotspanIndex-degree):knotspanIndex )' )...
        / W;
end
curvePt = [PtX, PtY];

Aders = 

wders

end
