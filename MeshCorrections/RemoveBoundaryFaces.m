function MeshStruct = RemoveBoundaryFaces(MeshStruct)

FacesToRemove = false(size(MeshStruct.Faces,1),1);
for Boundary = 1:6
    FacesToRemove = FacesToRemove | all(ismember(MeshStruct.Faces,find(MeshStruct.BoundaryTagging(:,Boundary))),2);
end

% Delete faces
MeshStruct.Faces(FacesToRemove,:) = [];

VerticesToRemoveIndexes = find(~ismember(1:size(MeshStruct.Vertices,1), MeshStruct.Faces));

% Delete Edges
EdgesToRemove = any(ismember(MeshStruct.Edges,VerticesToRemoveIndexes),2);
MeshStruct.Edges(EdgesToRemove,:) = [];
MeshStruct.EdgeLength(EdgesToRemove) = [];
MeshStruct.EdgeTagging(EdgesToRemove,:) = [];

% Delete vertices
MeshStruct = DeleteVertices(MeshStruct,VerticesToRemoveIndexes);

end