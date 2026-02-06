function MeshStruct = ResetEdgeTagging(MeshStruct)
% This function resets the MeshStruct.EdgeTagging variable

MeshStruct.EdgeTagging = false(size(MeshStruct.Edges,1),1);

end