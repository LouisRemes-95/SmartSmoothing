function Mask = MaskExtension(MeshStruct, Mask)
% Outputs a mask of the surrounding of the original mask

% Finds the extending edges and the corresponding vertices
EdgeConnectivityToMask = ismember(MeshStruct.Edges,find(Mask));
SurroundingVerticesIndexes = unique(MeshStruct.Edges(repmat(sum(EdgeConnectivityToMask,2) == 1, 1, 2) ...
                                                  & ~EdgeConnectivityToMask));
Mask = ismember(transpose(1:size(MeshStruct.Vertices,1)),SurroundingVerticesIndexes);

end