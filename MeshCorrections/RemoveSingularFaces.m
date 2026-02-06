function MeshStruct = RemoveSingularFaces(MeshStruct)
% Remove singular faces (correctif mesure, not sure if best solution)
FacesToDelete = [];
VerticesToDelete = [];
for Face = 1:size(MeshStruct.Faces,1)
    ConnectedNodes = ismember(MeshStruct.Faces(Face,:), MeshStruct.Faces(1:size(MeshStruct.Faces,1) ~= Face,:));
    if sum(ConnectedNodes) == 1
        FacesToDelete = [FacesToDelete Face];
        VerticesToDelete = [VerticesToDelete MeshStruct.Faces(Face,~ConnectedNodes)];
    end
end
MeshStruct.Faces(FacesToDelete,:) = [];

% Edges deletion
EdgesToRemove = any(ismember(MeshStruct.Edges, VerticesToDelete),2);
MeshStruct.Edges(EdgesToRemove, :) = [];
MeshStruct.EdgeLength(EdgesToRemove) = [];
MeshStruct.EdgeTagging(EdgesToRemove) = [];
MeshStruct = DeleteVertices(MeshStruct, VerticesToDelete);
end