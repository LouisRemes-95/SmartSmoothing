function MeshStruct = BoundaryTagging(MeshStruct)
% This function populates the MeshStruct.BoundaryTagging variable. Liking
% vertices to boundaries in the process.

% Rows = [Xmin Xmax Ymin Ymax Zmin Zmax]
MeshStruct.BoundaryTagging = false(size(MeshStruct.Vertices,1),6);

for i = 1:size(MeshStruct.Boundaries,1)
    for j = 1:size(MeshStruct.Boundaries,2)
        MeshStruct.BoundaryTagging(:,j+(i-1)*2) = MeshStruct.Vertices(:,i)==MeshStruct.Boundaries(i,j);
    end
end

end