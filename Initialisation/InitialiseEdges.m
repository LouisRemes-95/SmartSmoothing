function MeshStruct = InitialiseEdges(MeshStruct)
% This function populates the MeshStruct.Edges variable

MeshStruct.Edges = int32(zeros(size(MeshStruct.Faces,1)*3,2));

MeshStruct.Edges(1:3:end,:) = MeshStruct.Faces(:,1:2);
MeshStruct.Edges(2:3:end,:) = MeshStruct.Faces(:,2:3);
MeshStruct.Edges(3:3:end,:) = MeshStruct.Faces(:,[3 1]);

MeshStruct.Edges = sort(MeshStruct.Edges,2);

% Remove duplicates
MeshStruct.Edges = unique(MeshStruct.Edges, 'stable', 'rows');
end