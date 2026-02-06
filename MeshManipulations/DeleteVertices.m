function MeshStruct = DeleteVertices(MeshStruct,IndexesToDel)
% This function deletes vertices and adjusts following referencings
% !!! Doesn't delete direct references to the deleted nodes, hence the 
% IndexesToDel souldn't be referenced at this stage.

IndexesToDel = sort(IndexesToDel,'descend');

% Vertex deletion and derivatives
MeshStruct.Vertices(IndexesToDel,:) = [];
if isfield(MeshStruct,"VertexNormals")
    MeshStruct.VertexNormals(IndexesToDel,:) = [];
end
if isfield(MeshStruct,"BoundaryTagging")
    MeshStruct.BoundaryTagging(IndexesToDel,:) = [];
end
if isfield(MeshStruct,"K1")
    MeshStruct.K1(IndexesToDel,:) = [];
end
if isfield(MeshStruct,"K2")
    MeshStruct.K2(IndexesToDel,:) = [];
end

% Adjusts the following references to the deleted vertices.
for i = 1:length(IndexesToDel)
    MeshStruct.Faces(MeshStruct.Faces > IndexesToDel(i)) = MeshStruct.Faces(MeshStruct.Faces > IndexesToDel(i))-1;
    if isfield(MeshStruct,"Edges")
        MeshStruct.Edges(MeshStruct.Edges > IndexesToDel(i)) = MeshStruct.Edges(MeshStruct.Edges > IndexesToDel(i))-1;
    end
end

end