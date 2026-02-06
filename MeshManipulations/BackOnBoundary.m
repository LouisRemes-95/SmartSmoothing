function MeshStruct = BackOnBoundary(MeshStruct)
% This function moves vertices back on the appropriate boundary

% BoundaryTagging check
if any((MeshStruct.BoundaryTagging(:,1) & MeshStruct.BoundaryTagging(:,2))|...
        (MeshStruct.BoundaryTagging(:,3) & MeshStruct.BoundaryTagging(:,4))|...
        (MeshStruct.BoundaryTagging(:,5) & MeshStruct.BoundaryTagging(:,6)))
    error("Impossible boundary tagging")
end

MinimumsToSet = repmat(MeshStruct.Boundaries(:,1)',size(MeshStruct.Vertices,1),1);
MeshStruct.Vertices(MeshStruct.BoundaryTagging(:,[1 3 5])) = MinimumsToSet(MeshStruct.BoundaryTagging(:,[1 3 5]));
MaximumsToSet = repmat(MeshStruct.Boundaries(:,2)',size(MeshStruct.Vertices,1),1);
MeshStruct.Vertices(MeshStruct.BoundaryTagging(:,[2 4 6])) = MaximumsToSet(MeshStruct.BoundaryTagging(:,[2 4 6]));
end