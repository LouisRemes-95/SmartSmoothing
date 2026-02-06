function MeshStruct = SurroundSwelling(MeshStruct, MaxK1, MaxK2)
% This function swells arround the vertices where K1 is to high but not K2.
% This swelling is done in the first principal curvature direction.

% Masks generation
[Mask, ProblemMask] = Masking(MeshStruct, MaxK1, MaxK2);

while any(ProblemMask)
    MeshStruct = SwellMesh(MeshStruct, Mask, .1);
    MeshStruct = SmoothMesh(MeshStruct,1,ProblemMask);
    MeshStruct = BackOnBoundary(MeshStruct);
    MeshStruct = MergeSplitByDistance(MeshStruct,2);

    % MeshStruct = ComputeCurvatures(MeshStruct);
    % ProblemZone = (abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2) & any(MeshStruct.BoundaryTagging,2);
    % MeshStruct = CorrectBoundaryTagging(MeshStruct,ProblemZone);

    % Mask updating
    [Mask, ProblemMask] = Masking(MeshStruct, MaxK1, MaxK2);
end

end

%% Local functions
function [Mask, ProblemMask] = Masking(MeshStruct, MaxK1, MaxK2)
% This function does the directionnal masking. The Mask1 is for K1
% positive, while Mask2 is for K1 negative. A vertex is part of the mask if
% it normal alignes more or less with the surrounding problematic principal
% direction. Seems odd but works, should nevertheless be a bit reworked.

MeshStruct = ComputeCurvatures(MeshStruct);
ProblemMask = abs(MeshStruct.K1) > MaxK1 & abs(MeshStruct.K2) < MaxK2;
ProblemMask = ExtendMaskToBoundaries(MeshStruct,ProblemMask);

CurvedNodes = find(ProblemMask);
Mask = zeros(size(MeshStruct.Vertices,1),1);
for CurvedNode = CurvedNodes'
    SurroundingVerticesIndexes = unique(MeshStruct.Faces(any(ismember(MeshStruct.Faces,CurvedNode),2),:));
    SurroundingVerticesIndexes(SurroundingVerticesIndexes == CurvedNode) = [];
    Mask(SurroundingVerticesIndexes) = Mask(SurroundingVerticesIndexes) + MeshStruct.K1(CurvedNode);
end

Mask(Mask>0) = 1;
Mask(Mask<0) = -1;
Mask = ExtendMaskToBoundaries(MeshStruct,Mask);

end