%% Compute the nonvanishing basis functions & their derivatives
% Input:  u, knotspanIndex, degree, knotVector
% Output: the basis function values & their derivatives
% only works for knotVector has no double knots or more except first & last 3 terms
% Xu Yi, 2019

%%
function [basisFunValue, dersBasisFunValue] = BasisFuns(u, degree, knotVector)
% basisFunValue N(u) % knotspanIndex = i+1;
knotspanIndex = FindSpan(u, degree, knotVector);
N = zeros(degree+1,degree+1); N(1,1) = 1; % initialize. N0 = 1
for i = 1:degree % order = degree+1;
    for j = 1:i+1 % the NURBS book 2nd. P70
        left1 = u - knotVector( knotspanIndex-( i-j ) );
        left2 = u - knotVector( knotspanIndex-( i-(j-1) ) );
        right1 = knotVector( knotspanIndex-1+j ) - u;
        right2 = knotVector( knotspanIndex+j ) - u;
        Para1 = left2/(right1+left2);
        Para2 = right2/(right2+left1);
        if right1+left2 == 0 % define 0/0=0
            Para1 = 0;
        elseif right2+left1 == 0
            Para2 = 0;
        end
        if j == 1 % the first term of Eq. (2.14) are not computed, since Ni = 0;
            N(i+1,j) = Para2 * N(i,j);
        elseif j == i+1 % the last term of Eq. (2.16) are not computed, since Ni = 0;
            N(i+1,j) = Para1 * N(i,j-1);
        else
            N(i+1,j) = Para1 * N(i,j-1) + Para2 * N(i,j);
        end
    end
end
% derivatives % the NURBS book 2nd. P61 (2.10)
% parameter a
Para_a = zeros(degree+1,degree+1); Para_a(1,1) = 1; % initialize. a0,0 = 1
for i = 1:degree % a0,0 is initialized
    for j = 1:i+1
        temp = knotVector( knotspanIndex-1 + degree +j-i+1 ) - knotVector( knotspanIndex-1 +j );
        if j == 1
            Para_a(i+1,j) = Para_a(i,1) / temp;
        elseif j == i+1
            Para_a(i+1,j) = - Para_a(i,i) / temp;
        else
            Para_a(i+1,j) = ( Para_a(i,j) - Para_a(i,j-1) ) / temp;
        end
        if temp == 0 % special case. a/0 = 0
            Para_a(i+1,j) = 0;
        end
    end
end
% dersBasisFunValue
ders = zeros(degree,degree+1); % initialize. [der x degree+1]
for i = 1:degree % derivative. k<=p
    for j = 1:degree+1
        temp1 = factorial(degree) / factorial(degree-i);
        temp2 = 0;
        for k = 1:i+1
            temp211 = j+k-i-1;
            if temp211 > degree+1
                temp21 = 0;
            elseif temp211 < 1
                temp21 = 0;
            else
                temp21 = N( degree+1-i,temp211 );
            end
            temp2 = temp2 + Para_a(i+1,k)*temp21 ;
        end
        ders(i,j) = temp1 * temp2;
    end
end

basisFunValue = N;
dersBasisFunValue = ders;
end
