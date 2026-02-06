function OK = UnreferencedCheck(MeshStruct)
    OK = all(ismember(1:size(MeshStruct.Vertices,1), MeshStruct.Faces));
end