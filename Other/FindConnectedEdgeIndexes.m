function ConnectedEdgeIndexes = FindConnectedEdgeIndexes(MeshStruct, Edge)
% This function returns the indexes of edges connected to Edge

EdgesConnectivityToEdge = sum(ismember(MeshStruct.Edges,MeshStruct.Edges(Edge,:)),2);
ConnectedEdgeIndexes = find(EdgesConnectivityToEdge == 1);
end