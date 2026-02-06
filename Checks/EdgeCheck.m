function OK = EdgeCheck(MeshStruct)

Edges = sort(MeshStruct.Edges,2);
MeshStruct = InitialiseEdges(MeshStruct);
OK = isempty(setdiff(Edges,MeshStruct.Edges,'rows')) & isempty(setdiff(MeshStruct.Edges,Edges,'rows')) & all(size(Edges) == size(MeshStruct.Edges));