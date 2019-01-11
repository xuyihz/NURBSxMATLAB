%% Determine the knot span index (left)
% Input:  u, degree, knotVector
% Output: the knot span index
%
% Xu Yi, 2019

%%
function knotspanIndex = FindSpan(u, degree, knotVector)
knotNum = length(knotVector);
if u == knotVector(knotNum) % special case
    knotspanIndex = knotNum-1;
else % do binary search
    temp_low = degree; % degree = order -1;
    temp_high = knotNum;
    temp_mid = floor( (temp_low+temp_high) /2);
    while u < knotVector(temp_mid) || u >= knotVector(temp_mid+1)
        if u < knotVector(temp_mid)
            temp_high = temp_mid;
        else
            temp_low = temp_mid;
        end
        temp_mid = floor( (temp_low+temp_high) /2);
        knotspanIndex = temp_mid;
    end
end
