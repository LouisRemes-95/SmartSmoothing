function Mask = ExtendMaskToBoundariesBis(MeshStruct, Mask)
% This function extends a Mask to the boundaries
% Complex function since it encompasses a lot of edge cases
% Works for a binary and a double masks

if isa(Mask,'double')
    DoubleMask = Mask;
    Mask = Mask ~= 0;
end

% The Mask shouldn't include any boundary nodes, so these are removed.
Mask = Mask & ~any(MeshStruct.BoundaryTagging,2);

% Finds the extending edges and the corresponding vertices
EdgeConnectivityToMask = ismember(MeshStruct.Edges,find(Mask));
ExtendingEdgesIndexes = find(sum(EdgeConnectivityToMask,2) == 1);
Edges = MeshStruct.Edges';
ExtendingVerticesByEdgeIndexes = Edges((repmat(sum(EdgeConnectivityToMask,2) == 1, 1, 2) ...
                                               & ~EdgeConnectivityToMask)')';

% Loops over the boundaries
for Boundary = 1:size(MeshStruct.BoundaryTagging,2)
    % Finds the edges and corresponding vertices that connect to a specific
    % boundary.
    BoundaryConnectedEdgesIndexes = ExtendingEdgesIndexes(MeshStruct.BoundaryTagging(ExtendingVerticesByEdgeIndexes,Boundary));
    BoundaryConnectedEdges = MeshStruct.Edges(BoundaryConnectedEdgesIndexes,:);
    BoundaryVerticesByEdgeIndexes = ExtendingVerticesByEdgeIndexes(MeshStruct.BoundaryTagging(ExtendingVerticesByEdgeIndexes,Boundary));
    
    % Removes extrimity vertexes
    CheckedExtremityVertexIndexes = [];
    ExtremityVertexIndexes = NaN;
    while ~isempty(ExtremityVertexIndexes)
        ExtremityVertexIndexes = FindExtremities(MeshStruct, unique(BoundaryVerticesByEdgeIndexes));
        ExtremityVertexIndexes(ismember(ExtremityVertexIndexes,CheckedExtremityVertexIndexes)) = [];
        for i = 1:length(ExtremityVertexIndexes)
            ExtremityConnetivityToMask = BoundaryVerticesByEdgeIndexes == ExtremityVertexIndexes(i);
            if sum(ExtremityConnetivityToMask) > 1
                CheckedExtremityVertexIndexes = [CheckedExtremityVertexIndexes ExtremityVertexIndexes(i)];
            else
                EdgeToMaskIndex = BoundaryConnectedEdgesIndexes(ExtremityConnetivityToMask);
                [EdgesFromMaskVertex,~] = find(BoundaryConnectedEdges == setdiff(MeshStruct.Edges(EdgeToMaskIndex,:),ExtremityVertexIndexes(i)));
                EdgesFromMaskVertex = BoundaryConnectedEdgesIndexes(EdgesFromMaskVertex);
                if MeshStruct.EdgeLength(EdgeToMaskIndex) == min(MeshStruct.EdgeLength(EdgesFromMaskVertex))
                    CheckedExtremityVertexIndexes = [CheckedExtremityVertexIndexes ExtremityVertexIndexes(i)];
                else
                    BoundaryConnectedEdgesIndexes(ExtremityConnetivityToMask) = [];
                    BoundaryConnectedEdges(ExtremityConnetivityToMask) = [];
                    BoundaryVerticesByEdgeIndexes(ExtremityConnetivityToMask) = [];
                end
            end
        end
    end

    Mask(BoundaryVerticesByEdgeIndexes) = true;
end

% Looking for corners
PotentialCorners = any(MeshStruct.BoundaryTagging,2);
BoundaryVertices = find(PotentialCorners);
EdgesTouchingBoundary = MeshStruct.Edges(find(sum(ismember(MeshStruct.Edges,BoundaryVertices),2) > 0),:);
PotentialCorners(EdgesTouchingBoundary(~Mask(EdgesTouchingBoundary(:,1)),2)) = false;
PotentialCorners(EdgesTouchingBoundary(~Mask(EdgesTouchingBoundary(:,2)),1)) = false;
Mask = Mask | PotentialCorners;

% Handles double masks
if exist('DoubleMask', 'var') == 1
    InitialMask = DoubleMask ~= 0;
    InitialMask = InitialMask & ~any(MeshStruct.BoundaryTagging,2);
    MaskExtensionVertexIndexes = find(Mask & ~InitialMask);
    for ExtensionVertexIndex = MaskExtensionVertexIndexes'
        Distances = vecnorm(MeshStruct.Vertices(InitialMask,:)-repmat(MeshStruct.Vertices(ExtensionVertexIndex,:),sum(InitialMask),1),2,2);
        [~,MinimumIndex] = min(Distances);
        InitialMaskIndexes = find(InitialMask);
        DoubleMask(ExtensionVertexIndex) = DoubleMask(InitialMaskIndexes(MinimumIndex));
    end
    Mask = DoubleMask;
end

end

%% Local functions
function ExtremityVertices = FindExtremities(MeshStruct,Vertices)
% Finds the extremities of vertex chains

ExtremityVertices = MeshStruct.Edges(sum(ismember(MeshStruct.Edges,Vertices),2) == 2,:);
[Occ,ExtremityVertices] = groupcounts(reshape(ExtremityVertices,[],1));
ExtremityVertices = ExtremityVertices(Occ == 1);
ExtremityVertices(sum(MeshStruct.BoundaryTagging(ExtremityVertices,:),2) > 1) = [];
end