%% Determine the knot span index (left)
% Input:  u, degree, knotVector
% Output: the knot span index
% only works for knotVector's first 3 terms are equal && last 3 terms are equal
% Xu Yi, 2019

%%
function knotspanIndex = FindSpan(u, degree, knotVector)
knotNum = length(knotVector);
if u == knotVector(knotNum) % special case
    knotspanIndex = knotNum-(degree+1); % only when last 3 terms are equal
elseif u == knotVector(1) % special case
    knotspanIndex = degree+1; % only when first 3 terms are equal
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
