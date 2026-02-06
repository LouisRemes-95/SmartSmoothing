function [CorrectionApplied, MeshStruct] = CorrectiveMeasure(MeshStruct, PreviousMesh, K2Max)

MeshStruct = ComputeCurvatures(MeshStruct);
MaskedVertexIndexes = find(abs(MeshStruct.K2)>K2Max);
MaskEdges = ismember(MeshStruct.Edges,MaskedVertexIndexes);

DistanceToOldVertices = vecnorm(PreviousMesh.Vertices-MeshStruct.Vertices,2,2);

MaskedEdgeDistanceToOldVertices = sum(DistanceToOldVertices(MeshStruct.Edges).*MaskEdges,2);

[~, OrderedProblemEdges] = sort(MaskedEdgeDistanceToOldVertices,'descend');
OrderedProblemEdges = OrderedProblemEdges(1:sum(MaskedEdgeDistanceToOldVertices>0));

for i = 1:length(OrderedProblemEdges)
    % Looks if a pipe should be collapsed to insure mesh convergence
    FacesConnectivityToEdge = sum(ismember(MeshStruct.Faces,MeshStruct.Edges(OrderedProblemEdges(i),:)),2);
    SurroundingFaceIndexes_con2 = find(FacesConnectivityToEdge==2); % All faces with 2 nodes common to the Edge
    ConnectedEdgeIndexes = FindConnectedEdgeIndexes(MeshStruct, OrderedProblemEdges(i));

    [PipeDissociated, MeshStruct] = DissociateIfPipe(MeshStruct, ConnectedEdgeIndexes, SurroundingFaceIndexes_con2, OrderedProblemEdges(i));
    if PipeDissociated
        CorrectionApplied = true;
        return
    end
end

CorrectionApplied = false;
end