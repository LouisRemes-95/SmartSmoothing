function MeshStruct = SmartDirectionalSwelling(MeshStruct, MaxK1, MaxK2)
% This function swells arround the vertices where K1 is to high but not K2.
% This swelling is done in the first principal curvature direction.

% Masks generation
MeshStruct = ComputeCurvatures(MeshStruct);
Mask = DirectionnalMasking(MeshStruct, MaxK1, MaxK2);
ProblemMask = abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2;
ProblemMask = ExtendMaskToBoundaries(MeshStruct,ProblemMask);

while any(ProblemMask)
    MeshStruct = SwellMesh(MeshStruct, Mask, .1);
    MeshStruct = SmoothMesh(MeshStruct,1,ProblemMask);
    MeshStruct = BackOnBoundary(MeshStruct);
    MeshStruct = MergeSplitByDistance(MeshStruct,2);

    MeshStruct = ComputeCurvatures(MeshStruct);
    ProblemZone = (abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2) & any(MeshStruct.BoundaryTagging,2);
    MeshStruct = CorrectBoundaryTagging(MeshStruct,ProblemZone);

    % Mask updating
    MeshStruct = ComputeCurvatures(MeshStruct);
    Mask = DirectionnalMasking(MeshStruct, MaxK1, MaxK2);
    ProblemMask = abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2;
    ProblemMask = ExtendMaskToBoundaries(MeshStruct,ProblemMask);
end

end

%% Local functions
function Mask = DirectionnalMasking(MeshStruct, MaxK1, MaxK2)
% This function does the directionnal masking. The Mask1 is for K1
% positive, while Mask2 is for K1 negative. A vertex is part of the mask if
% it normal alignes more or less with the surrounding problematic principal
% direction. Seems odd but works, should nevertheless be a bit reworked.

[PrincipalDir1,~] = ComputePrincipalDirections(MeshStruct);
CurvedNodes = find(abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2);
Mask = zeros(size(MeshStruct.Vertices,1),2);
for CurvedNode = CurvedNodes'
    SurroundingVerticesIndexes = unique(MeshStruct.Faces(any(ismember(MeshStruct.Faces,CurvedNode),2),:));
    SurroundingVerticesIndexes(SurroundingVerticesIndexes == CurvedNode) = [];
    SurroundingVertices = MeshStruct.Vertices(SurroundingVerticesIndexes,:);
    ConnectingVector = repmat(MeshStruct.Vertices(CurvedNode,:),size(SurroundingVertices,1),1)-SurroundingVertices; % Vector from surrounding vertices to CurvedNode
    DistanceToTangentPlane = dot(ConnectingVector,repmat(MeshStruct.VertexNormals(CurvedNode,:),size(ConnectingVector,1),1),2);
    ProjectedSurroundingVertices = SurroundingVertices+repmat(MeshStruct.VertexNormals(CurvedNode,:),size(SurroundingVertices,1),1).*repmat(DistanceToTangentPlane,1,3);
    VectorToProjected = ProjectedSurroundingVertices-repmat(MeshStruct.Vertices(CurvedNode,:),size(ProjectedSurroundingVertices,1),1);
    AlignmentToP1 = abs(dot(VectorToProjected,repmat(PrincipalDir1(CurvedNode,:),size(VectorToProjected,1),1),2)); % No division by length cause further verticesshould be push more
    Mask(SurroundingVerticesIndexes,1) = max(Mask(SurroundingVerticesIndexes,1),sign(DistanceToTangentPlane).*AlignmentToP1);
    Mask(SurroundingVerticesIndexes,2) = min(Mask(SurroundingVerticesIndexes,2),sign(DistanceToTangentPlane).*AlignmentToP1);
end
Mask = mean(Mask,2);
Mask = ExtendMaskToBoundaries(MeshStruct,Mask);
end