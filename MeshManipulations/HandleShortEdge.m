function MeshStruct = HandleShortEdge(MeshStruct, ShortEdge)
% This function "handles" the ShortEdge, usually merging its 2 vertices.

%% Needed info
FacesConnectivityToEdge = sum(ismember(MeshStruct.Faces,MeshStruct.Edges(ShortEdge,:)),2);
SurroundingFaceIndexes_con1 = find(FacesConnectivityToEdge==1); % All faces with 1 node common to the Edge
SurroundingFaceIndexes_con2 = find(FacesConnectivityToEdge==2); % All faces with 2 nodes common to the Edge

%% Small cluster identification
% This complex condition simply finds if a small cluster (tetrahedral) is
% gone collaps by merging the ShortEdge. In this case, the code tags this
% edge to not be merged. This cluster should be removed later on.
SurroundingFacesVertices_con1 = MeshStruct.Faces(SurroundingFaceIndexes_con1,:);
if size(SurroundingFaceIndexes_con1,1) == 2 &&...
        length(unique(SurroundingFacesVertices_con1)) == 4 &&...
        sum(sum(ismember(SurroundingFacesVertices_con1,MeshStruct.Edges(ShortEdge,1)))) == 1 &&...
        sum(sum(ismember(SurroundingFacesVertices_con1,MeshStruct.Edges(ShortEdge,2)))) == 1
    MeshStruct.EdgeTagging(ShortEdge) = true;
    return
end

%% Finding if a pipe is collapsing and collapses it
ConnectedEdgeIndexes = FindConnectedEdgeIndexes(MeshStruct, ShortEdge);


[PipeDissociated, MeshStruct] = DissociateIfPipe(MeshStruct, ConnectedEdgeIndexes, SurroundingFaceIndexes_con2, ShortEdge);
if PipeDissociated
    return
end

%% Merging of edge
MeshStruct.Vertices(MeshStruct.Edges(ShortEdge,1),:) = (MeshStruct.Vertices(MeshStruct.Edges(ShortEdge,1),:)...
                                                       + MeshStruct.Vertices(MeshStruct.Edges(ShortEdge,2),:))./2;
MeshStruct = RereferenceAndDeleteVertex(MeshStruct,MeshStruct.Edges(ShortEdge,1),MeshStruct.Edges(ShortEdge,2),SurroundingFaceIndexes_con1,ConnectedEdgeIndexes);
MeshStruct.Faces(SurroundingFaceIndexes_con2,:) = []; % Delete faces with 2 nodes common to the Edge

% Find duplicate edges
ConnectedEdges = MeshStruct.Edges(ConnectedEdgeIndexes,:)';
ConnectedNodes = ConnectedEdges(ConnectedEdges ~= MeshStruct.Edges(ShortEdge,1));
DuplicateConnectedNodes = FindSecondOccurenceIndices(ConnectedNodes);

EdgesToDelete = [ConnectedEdgeIndexes(DuplicateConnectedNodes);ShortEdge];

% Recomputes lengths
MeshStruct = ComputeEdgeLength(MeshStruct, ConnectedEdgeIndexes);

% Unreferenced vertex deletion (instead of the dedicated function for speed
% and infos)
PotentialUnreferencedNodes = ConnectedNodes(DuplicateConnectedNodes);
UnreferencedNodes = PotentialUnreferencedNodes(~ismember(PotentialUnreferencedNodes,MeshStruct.Faces));
if ~isempty(UnreferencedNodes)
    for i = 1:length(UnreferencedNodes)
        MeshStruct = RereferenceAndDeleteVertex(MeshStruct,MeshStruct.Edges(ShortEdge,1),UnreferencedNodes(i),[],1:size(MeshStruct.Edges,1));
        UnreferencedNodes(UnreferencedNodes>UnreferencedNodes(i)) = UnreferencedNodes(UnreferencedNodes>UnreferencedNodes(i))-1;
    end
    EdgesToDelete = unique([EdgesToDelete; find(MeshStruct.Edges(:,1) == MeshStruct.Edges(:,2))]);
end
PotentialUnconnectedNodes = setdiff(PotentialUnreferencedNodes,UnreferencedNodes);
for i = 1:length(PotentialUnconnectedNodes)
    if ~any(sum(ismember(MeshStruct.Faces,[PotentialUnconnectedNodes(i) MeshStruct.Edges(ShortEdge,1)]),2) == 2)
        EdgesToDelete = unique([EdgesToDelete; find(all(ismember(MeshStruct.Edges,[PotentialUnconnectedNodes(i) MeshStruct.Edges(ShortEdge,1)]),2))]);
    end
end

% Remove duplicate edges
VertexToCheck = MeshStruct.Edges(ShortEdge,1);
MeshStruct.Edges(EdgesToDelete,:) = [];
MeshStruct.EdgeLength(EdgesToDelete) = [];
MeshStruct.EdgeTagging(EdgesToDelete) = [];

% Remove new vertex if face collapsing
if ~any(any(ismember(MeshStruct.Faces, VertexToCheck)))
    MeshStruct = DeleteVertices(MeshStruct, VertexToCheck);
else
    % Check for local multifolds
    MeshStruct = DissociateMesh(MeshStruct, VertexToCheck, false);
end


% Usefull checks, but time consiming
% if ~EdgeCheck(MeshStruct)
%     error('Bad Edge Matrix');
% end
% if ~UnreferencedCheck(MeshStruct)
%     error('Unreferenced Vertices');
% end
% if ~VertDependentSizeCheck(MeshStruct)
%     error('Bad sizing')
% end
% MeshStructBis = ComputeEdgeLength(MeshStruct);
% if ~all(MeshStruct.EdgeLength == MeshStructBis.EdgeLength)
%     error('Bad Length capturing')
% end
end

%% LOCAL FUNCTIONS
function MeshStruct = RereferenceAndDeleteVertex(MeshStruct,IndexToRerefTo,IndexToDel,FacesToRerefIndexes,EdgeToRerefIndexes)

MeshStruct = RereferenceVertex(MeshStruct, IndexToRerefTo, IndexToDel, FacesToRerefIndexes, EdgeToRerefIndexes);

% Handles BoundaryTagging
MeshStruct.BoundaryTagging(IndexToRerefTo,:) = MeshStruct.BoundaryTagging(IndexToRerefTo,:) | MeshStruct.BoundaryTagging(IndexToDel,:);

MeshStruct = DeleteVertices(MeshStruct,IndexToDel);
end