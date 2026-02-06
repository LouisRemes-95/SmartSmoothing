function MeshStruct = CorrectBoundaryTagging(MeshStruct)
% This function removes single boundary taggings. By single boundary
% taggings, we refer to a vertex without any adjacent vertex that is part
% of the same boundary.

PotentialVerticesToCorrect = find(any(MeshStruct.BoundaryTagging,2));
for i = 1:size(PotentialVerticesToCorrect,1)
    SurroundingVerticesIndexes = reshape(MeshStruct.Faces(any(ismember(MeshStruct.Faces,PotentialVerticesToCorrect(i)),2),:),[],1);
    SurroundingVerticesIndexes = unique(SurroundingVerticesIndexes);
    SurroundingVerticesIndexes(SurroundingVerticesIndexes == PotentialVerticesToCorrect(i)) = [];
    SurroundingBoundaries = any(MeshStruct.BoundaryTagging(SurroundingVerticesIndexes,:),1);
    MeshStruct.BoundaryTagging(PotentialVerticesToCorrect(i),:) = all([MeshStruct.BoundaryTagging(PotentialVerticesToCorrect(i),:); SurroundingBoundaries],1);
end
end