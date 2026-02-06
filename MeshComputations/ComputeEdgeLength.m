function MeshStruct = ComputeEdgeLength(MeshStruct,EdgesToRecompute)
% This function computes the length of specified edges (all by default) and
% store this information in MeshStruct.EdgeLength.

if nargin < 2
    EdgesToRecompute = 1:size(MeshStruct.Edges,1);
end

MeshStruct.EdgeLength(EdgesToRecompute,1) = vecnorm(MeshStruct.Vertices(MeshStruct.Edges(EdgesToRecompute,1),:)-...
                                MeshStruct.Vertices(MeshStruct.Edges(EdgesToRecompute,2),:),2,2);
end