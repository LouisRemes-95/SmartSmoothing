function IsEqual = AlmostEqual(PreviousMesh,MeshStruct)

    MeshStruct = ComputeEdgeLength(MeshStruct);

    if size(PreviousMesh.Vertices) ~= size(MeshStruct.Vertices)
        IsEqual = false;
    elseif size(PreviousMesh.Faces) ~= size(MeshStruct.Faces)
        IsEqual = false;
    elseif ~isequal(PreviousMesh.Faces,MeshStruct.Faces)
        IsEqual = false;
    elseif ~all(abs(PreviousMesh.Vertices - MeshStruct.Vertices)<.001*min(MeshStruct.EdgeLength))
        IsEqual = false;
    else
        IsEqual = true;
    end
end