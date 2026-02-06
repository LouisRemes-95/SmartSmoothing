function [PipeDissociated, MeshStruct] = DissociateIfPipe(MeshStruct, ConnectedEdgeIndexes, SurroundingFaceIndexes_con2, Edge)
% This function looks if a "pipe" is collapsing when merging the Edge. If
% so, the function instead dissociates the "pipe" properly.

% Looking for the third node that completes an empty triangle
SurroundingVertexIndexes = MeshStruct.Edges(ConnectedEdgeIndexes,:); % Vertices directly connected to the edge.
SurroundingVertexIndexes = SurroundingVertexIndexes(~ismember(SurroundingVertexIndexes,MeshStruct.Faces(SurroundingFaceIndexes_con2,:)));
NodesOfConnectedEmptyTriangles = SurroundingVertexIndexes(FindSecondOccurenceIndices(SurroundingVertexIndexes));

% If pipe is collapsing
if ~isempty(NodesOfConnectedEmptyTriangles) & length(SurroundingFaceIndexes_con2) == 2
    
    % Splits an empty triangle and fills both sides with a face.
    EmptyTriangles = [repmat(MeshStruct.Edges(Edge,:),length(NodesOfConnectedEmptyTriangles),1) NodesOfConnectedEmptyTriangles];
    EmptyTriangle = EmptyTriangles(1,:);
    MeshStruct = DissociateMesh(MeshStruct, EmptyTriangle, true);
    PipeDissociated = true;
    return
end

PipeDissociated = false;
end