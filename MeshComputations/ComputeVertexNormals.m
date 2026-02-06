function MeshStruct = ComputeVertexNormals(MeshStruct)
% Slow, so can probably be improved

ABVectors = MeshStruct.Vertices(MeshStruct.Faces(:,2),:) - MeshStruct.Vertices(MeshStruct.Faces(:,1),:);
ACVectors = MeshStruct.Vertices(MeshStruct.Faces(:,3),:) - MeshStruct.Vertices(MeshStruct.Faces(:,1),:);
FaceNonNormilizedNormals = cross(ABVectors, ACVectors, 2);

% Vertex normals computed by averaging face normals weighted by face areas.
Ordering = reshape(repmat(1:size(FaceNonNormilizedNormals,1),3,1),[],1);
FaceNonNormilizedNormalsNodes = FaceNonNormilizedNormals(Ordering,:);
MeshStruct.VertexNormals = normr(TransferFaceToVert_mex(MeshStruct, FaceNonNormilizedNormalsNodes));
end