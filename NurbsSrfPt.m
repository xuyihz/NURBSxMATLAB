%% Compute point on non-uniform rational B-spline surface
% Input:  u,v, degree(U,V), knotVector(U,V), cvPt(X,Y,Z), weightVector
% Output: point on non-uniform rational B-spline surface
% column:u / row:v
% Xu Yi, 2019

%%
function [surfacePt, dersSurfacePt] = NurbsSrfPt(u, degreeU, knotVectorU, v, degreeV, knotVectorV, cvPtX, cvPtY, cvPtZ, weightVector)
% u
knotspanIndexU = FindSpan(u, knotVectorU);
[basisFunValueU, dersBasisFunValueU] = BasisFuns(u, degreeU, knotVectorU);
% v
knotspanIndexV = FindSpan(v, knotVectorV);
[basisFunValueV, dersBasisFunValueV] = BasisFuns(v, degreeV, knotVectorV);
% w.*P
WcvPtX = cvPtX.* weightVector;
WcvPtY = cvPtY.* weightVector;
WcvPtZ = cvPtZ.* weightVector;
if knotspanIndexU == length(knotVectorU) - degreeU && knotspanIndexV == length(knotVectorV) - degreeV % special case
    PtX = cvPtX(end,end);
    PtY = cvPtY(end,end);
    PtZ = cvPtZ(end,end);
elseif knotspanIndexU == length(knotVectorU) - degreeU % special case / like curve @ V
    W = basisFunValueV(end,:)...
        * ( weightVector( end , (knotspanIndexV-degreeV):knotspanIndexV )' );
    PtX = basisFunValueV(end,:)...
        * ( WcvPtX( end , (knotspanIndexV-degreeV):knotspanIndexV )' )...
        / W;
    PtY = basisFunValueV(end,:)...
        * ( WcvPtY( end , (knotspanIndexV-degreeV):knotspanIndexV )' )...
        / W;
    PtZ = basisFunValueV(end,:)...
        * ( WcvPtZ( end , (knotspanIndexV-degreeV):knotspanIndexV )' )...
        / W;
elseif knotspanIndexV == length(knotVectorV) - degreeV % special case / like curve @ U
    W = basisFunValueU(end,:)...
        * ( weightVector( (knotspanIndexU-degreeU):knotspanIndexU , end ) );
    PtX = basisFunValueU(end,:)...
        * ( WcvPtX( (knotspanIndexU-degreeU):knotspanIndexU , end ) )...
        / W;
    PtY = basisFunValueU(end,:)...
        * ( WcvPtY( (knotspanIndexU-degreeU):knotspanIndexU , end ) )...
        / W;
    PtZ = basisFunValueU(end,:)...
        * ( WcvPtZ( (knotspanIndexU-degreeU):knotspanIndexU , end ) )...
        / W;
else
    W = basisFunValueU(end,:)...
        * weightVector( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
        * basisFunValueV(end,:)';
    PtX = basisFunValueU(end,:)...
        * WcvPtX( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
        * basisFunValueV(end,:)'...
        / W;
    PtY = basisFunValueU(end,:)...
        * WcvPtY( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
        * basisFunValueV(end,:)'...
        / W;
    PtZ = basisFunValueU(end,:)...
        * WcvPtZ( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
        * basisFunValueV(end,:)'...
        / W;
end
surfacePt = [PtX, PtY, PtZ];
% derivative. The NURBS book 2nd page136 (4.20)
% initialize / combination
dersBasisCombU = zeros(degreeU+1,degreeU+1);
dersBasisCombU(1,:) = basisFunValueU(end,:);
dersBasisCombU(2:end,:) = dersBasisFunValueU;
dersBasisCombV = zeros(degreeV+1,degreeV+1);
dersBasisCombV(1,:) = basisFunValueV(end,:);
dersBasisCombV(2:end,:) = dersBasisFunValueV;
% Aders
AdersX = genAders(WcvPtX,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV);
AdersY = genAders(WcvPtY,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV);
AdersZ = genAders(WcvPtZ,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV);
% wders
wders = genWders(weightVector,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV);
% dersSurfacePt
dersPtX = genDersPt(AdersX, PtX, degreeU, degreeV, wders);
dersPtY = genDersPt(AdersY, PtY, degreeU, degreeV, wders);
dersPtZ = genDersPt(AdersZ, PtZ, degreeU, degreeV, wders);
dersSurfacePt = [dersPtX, dersPtY, dersPtZ];
end

function Aders = genAders(WcvPt,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV)
Aders = zeros(degreeU+degreeV+1,degreeU+1);
for i = 1:degreeU+1
    for j = 1:degreeV+1
        Aders(i+j-1,i) = dersBasisCombU(i,:)... % index from i.
            * WcvPt( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
            * dersBasisCombV(j,:)';
    end
end
end
function wders = genWders(weightVector,...
    degreeU, knotspanIndexU, dersBasisCombU,...
    degreeV, knotspanIndexV, dersBasisCombV)
wders = zeros(degreeU+degreeV+1,degreeU+1);
for i = 1:degreeU+1
    for j = 1:degreeV+1
        wders(i+j-1,i) = dersBasisCombU(i,:)... % index from i.
            * weightVector( (knotspanIndexU-degreeU):knotspanIndexU, (knotspanIndexV-degreeV):knotspanIndexV )...
            * dersBasisCombV(j,:)';
    end
end
end
function dersPt = genDersPt(Aders, Pt, degreeU, degreeV, wders)
dersPt = zeros(degreeU+degreeV+1,degreeU+1);
for i = 1:degreeU+1
    for j = 1:degreeV+1
        if i == 1 && j == 1 % special case
            break
        end
        wPt = 0; % initialize
        for ii = 1:i
            wPt_temp = factorial(i)/factorial(ii)/factorial(i-ii)...
                * wders(ii+1,ii+1) * dersPt(i-ii+1+j,i-ii+2);
            wPt = wPt + wPt_temp;
        end
        for jj = 1:j
            wPt_temp = factorial(j)/factorial(jj)/factorial(j-jj)...
                * wders(jj+1,1) * dersPt(i+1+j-jj,i+1);
            wPt = wPt + wPt_temp;
        end
        for ii = 1:i
            for jj = 1:j
                wPt_temp = factorial(i)/factorial(ii)/factorial(i-ii)...
                    * factorial(j)/factorial(jj)/factorial(j-jj)...
                    * wders(ii+jj+1,ii+1) * dersPt(i-ii+1+j-jj,i-ii+1);
                wPt = wPt + wPt_temp;
            end
        end
        if i == 1 && j == 1 % special case
            dersPt(i,j) = Pt;
        else
            dersPt(i,j) = ( Aders(i+j-1,i) - wPt ) / wders(1,1);
        end
    end
end
end
