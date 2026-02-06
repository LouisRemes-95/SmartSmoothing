function MeshStruct = SmartSwellSadel(MeshStruct, MaxK2)
% This function swells the mesh where the second principal curvature
% is to high and a sadel point exists.

% Mask generation
MeshStruct = ComputeCurvatures(MeshStruct);
Mask1 = MeshStruct.K2 > MaxK2 & ((MeshStruct.K1 > 0) ~= (MeshStruct.K2 > 0));
Mask1 = ExtendMaskToBoundaries(MeshStruct, Mask1);
Mask2 = MeshStruct.K2 < -MaxK2 & ((MeshStruct.K1 > 0) ~= (MeshStruct.K2 > 0));
Mask2 = ExtendMaskToBoundaries(MeshStruct, Mask2);
NoMask = Mask1 & Mask2;
Mask1 = Mask1 & ~NoMask;
Mask2 = Mask2 & ~NoMask;

while any(Mask1) || any(Mask2)
    MeshStruct = SwellMesh(MeshStruct, Mask1, -.1);
    MeshStruct = SwellMesh(MeshStruct, Mask2, .1);
    MeshStruct = BackOnBoundary(MeshStruct);
    MeshStruct = MergeSplitByDistance(MeshStruct,2);

    % Mask updating
    MeshStruct = ComputeCurvatures(MeshStruct);
    Mask1 = MeshStruct.K2 > MaxK2 & ((MeshStruct.K1 > 0) ~= (MeshStruct.K2 > 0));
    Mask1 = ExtendMaskToBoundaries(MeshStruct, Mask1);
    Mask2 = MeshStruct.K2 < -MaxK2 & ((MeshStruct.K1 > 0) ~= (MeshStruct.K2 > 0));
    Mask2 = ExtendMaskToBoundaries(MeshStruct, Mask2);
    NoMask = Mask1 & Mask2;
    Mask1 = Mask1 & ~NoMask;
    Mask2 = Mask2 & ~NoMask;
end

end