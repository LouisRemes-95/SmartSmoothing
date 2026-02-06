function MeshStruct = RemoveDuplicateFaces(MeshStruct)
% This funciton will only update vertices and faces to remove duplicate faces

Faces = sort(MeshStruct.Faces,2);

% Find duplicate faces and deletes them
DuplicateFaceIndices = FindDuplicateIndices(Faces);
MeshStruct.Faces(DuplicateFaceIndices,:) = [];

% Updates Edges and derivatives
if isfield(MeshStruct,"Edges") && isfield(MeshStruct,"EdgeLength") && isfield(MeshStruct,"EdgeTagging")
    Edges = sort(MeshStruct.Edges,2);
    MeshStruct = InitialiseEdges(MeshStruct);
    [~,EdgeIndexesToRemove] = setdiff(Edges,MeshStruct.Edges,'stable','rows');
    MeshStruct.Edges = Edges;
    MeshStruct.Edges(EdgeIndexesToRemove,:) = [];
    MeshStruct.EdgeLength(EdgeIndexesToRemove) = [];
    MeshStruct.EdgeTagging(EdgeIndexesToRemove) = [];
end

% Removes vertices that might now be unreferenced
MeshStruct = RemoveUnreferencedVertices(MeshStruct);
end