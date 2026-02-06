function MeshStruct = RereferenceVertex(MeshStruct, IndexToRerefTo, IndexToReref, FacesToRerefIndexes, EdgeToRerefIndexes)
% This function rereferences a vertex to another one.

% Rereferencing faces
FacesToReref = MeshStruct.Faces(FacesToRerefIndexes,:);
FacesToReref(FacesToReref == IndexToReref) = IndexToRerefTo;
MeshStruct.Faces(FacesToRerefIndexes,:) = FacesToReref;

% Rereferencing edges
if isfield(MeshStruct, "Edges")
    EdgeToReref = MeshStruct.Edges(EdgeToRerefIndexes,:);
    EdgeToReref(EdgeToReref == IndexToReref) = IndexToRerefTo;
    MeshStruct.Edges(EdgeToRerefIndexes,:) = EdgeToReref;
end
end