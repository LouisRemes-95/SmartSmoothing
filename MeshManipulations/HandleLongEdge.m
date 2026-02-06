function MeshStruct = HandleLongEdge(MeshStruct,LongEdge)
% This function splits the given LongEdge

%% Needed info
FacesConnectivityToEdge = sum(ismember(MeshStruct.Faces,MeshStruct.Edges(LongEdge,:)),2);
SurroundingFaceIndexes_con2 = find(FacesConnectivityToEdge==2); % All faces with 2 nodes common to the Edge

% Vertex addition
MeshStruct.Vertices = [MeshStruct.Vertices; (MeshStruct.Vertices(MeshStruct.Edges(LongEdge,1),:)...
                                           + MeshStruct.Vertices(MeshStruct.Edges(LongEdge,2),:))./2];

% Update BoundaryTagging
MeshStruct.BoundaryTagging = [MeshStruct.BoundaryTagging; all(MeshStruct.BoundaryTagging(MeshStruct.Edges(LongEdge,:)',:),1)];

% Face updating
InitialFaces_con2 = MeshStruct.Faces(SurroundingFaceIndexes_con2,:);
ReplacementFaces = InitialFaces_con2;
ReplacementFaces(ReplacementFaces == MeshStruct.Edges(LongEdge,1)) = size(MeshStruct.Vertices,1);
MeshStruct.Faces = [MeshStruct.Faces; ReplacementFaces];
ReplacementFaces = InitialFaces_con2;
ReplacementFaces(ReplacementFaces == MeshStruct.Edges(LongEdge,2)) = size(MeshStruct.Vertices,1);
MeshStruct.Faces(SurroundingFaceIndexes_con2,:) = ReplacementFaces;

% Edge updating
DoubleConnectivityVertices = InitialFaces_con2(~ismember(InitialFaces_con2,MeshStruct.Edges(LongEdge,:)));
MeshStruct.Edges = [MeshStruct.Edges; [[DoubleConnectivityVertices; MeshStruct.Edges(LongEdge,2)] repmat(size(MeshStruct.Vertices,1),length(DoubleConnectivityVertices)+1,1)]];
MeshStruct.Edges(LongEdge,2) = size(MeshStruct.Vertices,1);
MeshStruct = ComputeEdgeLength(MeshStruct,[LongEdge size(MeshStruct.Edges,1)-2:size(MeshStruct.Edges,1)]);
MeshStruct.EdgeTagging = false(size(MeshStruct.Edges,1),1);

% Adjust size of the rest
MeshStruct.VertexNormals = [MeshStruct.VertexNormals; zeros(1,3)];
MeshStruct.K1 = [MeshStruct.K1; 0];
MeshStruct.K2 = [MeshStruct.K2; 0];

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
end