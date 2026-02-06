function Mask = ExtendMaskToBoundaries(MeshStruct, Mask)
% This function extends a Mask to the boundaries
% Complex function since it encompasses a lot of edge cases
% Works for a binary and a double masks

BoundaryVertexIndexes = find(any(MeshStruct.BoundaryTagging,2));
SuroundingVertexIndices = reshape(MeshStruct.Faces(any(ismember(MeshStruct.Faces,BoundaryVertexIndexes),2),:),[],1);
SuroundingVertexIndices(ismember(SuroundingVertexIndices,BoundaryVertexIndexes)) = [];

BoundaryVertices = repmat(reshape(MeshStruct.Vertices(BoundaryVertexIndexes,:),length(BoundaryVertexIndexes),1,3),1,length(SuroundingVertexIndices),1);
SurroundingVertices = repmat(reshape(MeshStruct.Vertices(SuroundingVertexIndices,:),1,length(SuroundingVertexIndices),3),length(BoundaryVertexIndexes),1,1);
Distances = vecnorm(SurroundingVertices-BoundaryVertices,2,3);
[~,MinimumIndices] = min(Distances,[],2);
Mask(BoundaryVertexIndexes) = Mask(SuroundingVertexIndices(MinimumIndices));
end