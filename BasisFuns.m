%% Compute the nonvanishing basis functions
% Input:  u, knotspanIndex, degree, knotVector
% Output: the basis function values
% only works for knotVector is not repeated except first & last 3 terms
% Xu Yi, 2019

%%
function basisFunValue = BasisFuns(u, knotspanIndex, degree, knotVector)
N = zeros(1,degree+1); N(1,1) = 1; % initialize. N0 = 1
N_temp = zeros(1,degree+1);
for i = 1:degree % order = degree+1;
    for j = 1:i+1 % the NURBS book 2nd. P70
        left1 = u - knotVector( knotspanIndex+1-( i-(j-1) ) );
        left2 = u - knotVector( knotspanIndex+1-( i-(j-2) ) );
        right1 = knotVector( knotspanIndex+j-1 ) - u;
        right2 = knotVector( knotspanIndex+j ) - u;
        Para1 = left2/(right1+left2);
        Para2 = right2/(right2+left1);
        if right1+left2 == 0 % define 0/0=0
            Para1 = 0;
        elseif right2+left1 == 0
            Para2 = 0;
        end
        if j == 1 % the first term of Eq. (2.14) are not computed, since Ni = 0;
            N_temp(j) = Para2 * N(j);
        elseif j == i+1 % the last term of Eq. (2.16) are not computed, since Ni = 0;
            N_temp(j) = Para1 * N(j-1);
        else
            N_temp(j) = Para1 * N(j-1) + Para2 * N(j);
        end
    end
    N = N_temp;
end
basisFunValue = N;
end
