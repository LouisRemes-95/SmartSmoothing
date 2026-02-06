function MeshStruct = SmartSmoothPeeks(MeshStruct, MaxK2)
% This function smooths the mesh where one of the principal curvatures
% is to high. Usually, MaxK1 is set to Inf in this overall process.

% Mask generation
MeshStruct = ComputeCurvatures(MeshStruct);
Mask = (abs(MeshStruct.K2) > MaxK2) & ((MeshStruct.K1 > 0) == (MeshStruct.K2 > 0));
Mask = ExtendMaskToBoundaries(MeshStruct, Mask);

while any(Mask)
    MeshStruct = SmoothMesh(MeshStruct,1,Mask);
    MeshStruct = BackOnBoundary(MeshStruct);
    MeshStruct = MergeSplitByDistance(MeshStruct,2);

    % Disconnect single vertices from boundary (Should maybe be done in
    % MergeSplit, but seems more eficient here)
    MeshStruct = ComputeCurvatures(MeshStruct);
    MeshStruct = CorrectBoundaryTagging(MeshStruct);

    % Mask updating
    Mask = (abs(MeshStruct.K2) > MaxK2) & ((MeshStruct.K1 > 0) == (MeshStruct.K2 > 0));
    Mask = ExtendMaskToBoundaries(MeshStruct, Mask);
end

end