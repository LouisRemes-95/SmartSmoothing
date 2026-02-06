function Output = TransferFaceToVert(MeshStruct, Value)
% Maybe test the accumarray function

FaceNodes = reshape(MeshStruct.Faces',[],1);
Output = zeros(size(MeshStruct.Vertices,1),size(Value,2));
    for i = 1:size(Value,1)
        Output(FaceNodes(i),:) = Output(FaceNodes(i),:) + Value(i,:);
    end
end