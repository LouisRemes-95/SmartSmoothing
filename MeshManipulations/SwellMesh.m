function MeshStruct = SwellMesh(MeshStruct, Mask, SwellingFactor)
% This function swells (moves along normal) the mask by a SwellingFactor.
% Can be done proportionnaly to a masking value.

MeshStruct = ComputeEdgeLength(MeshStruct);

MeanLength = mean(MeshStruct.EdgeLength);

MeshStruct = ComputeVertexNormals(MeshStruct);
MeshStruct.Vertices = MeshStruct.Vertices + SwellingFactor*MeanLength*MeshStruct.VertexNormals.*repmat(Mask,1,3);
end