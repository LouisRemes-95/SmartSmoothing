function MeshStruct = RemoveUnreferencedVertices(MeshStruct)
% The function removes any unreferenced vertex 
% (would be more efficient with a predifined set)

MeshStruct = DeleteVertices(MeshStruct,find(~ismember(1:size(MeshStruct.Vertices,1),MeshStruct.Faces)));
end