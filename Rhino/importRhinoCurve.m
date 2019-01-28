%% function
% import Rhino 'List'
%
% Xu Yi, 2019

%%
function importRhinoCurve(fileID)
temp = 0; % temp = fscanf(fid,'%s',1);
while temp ~= 'order'
    temp = fscanf(fileID,'%s',1); % A = fscanf(fileID,formatSpec,sizeA)
end
fscanf(fileID,'%s',1);
order = fscanf(fileID,'%d',1);

while temp ~= 'cv_count'
    temp = fscanf(fileID,'%s',1); % A = fscanf(fileID,formatSpec,sizeA)
end
fscanf(fileID,'%s',1);
cv_count = fscanf(fileID,'%d',1);

while temp ~= 'Knot'
    temp = fscanf(fileID,'%s',1); % A = fscanf(fileID,formatSpec,sizeA)
end
temp = fscanf(fileID,'%s',1);
temp = fscanf(fileID,'%s',1);
knotNum = fscanf(fileID,'%d',1);
knotNum = knotNum+2; % Rhino的节点向量少了两个(第一个与最后一个)
fgetl(fileID);
fgetl(fileID);

knotVector = zeros(1,knotNum);
i = 2;
while temp ~= 'Control'
    fscanf(fileID,'%f',1);
    temp = fscanf(fileID,'%f',1);
    knotVector(i) = temp;
    i = i+1;
    knotMult = fscanf(fileID,'%d',1);
    fgetl(fileID);
    for j = 1:knotMult-1
        temp = fscanf(fileID,'%f',1);
        knotVector(i) = temp;
        i = i+1;
    end
end
knotVector(1) = knotVector(2);
knotVector(end) = knotVector(end-1);

fgetl(fileID);
fgetl(fileID);
cvPt = zeros(cv_count,3);
for i = 1:cv_count
    
end


end
