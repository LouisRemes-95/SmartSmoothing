function MeshStruct = RemoveSmallClusters(MeshStruct,NumberOfFaces)
% This function will find small mesh clusters and delete them according to
% the specified NumberOfFaces

if nargin == 1
    NumberOfFaces = max(size(MeshStruct.Faces,1)*.001,4);
end

% Find small clusters
SurfaceMesh = surfaceMesh(MeshStruct.Vertices, MeshStruct.Faces);

[FaceClusterIndexes,ClusterNumFaces,~] = clusterConnectedFaces(SurfaceMesh);

FacesToRemoveIndexes = find(ismember(FaceClusterIndexes,find(ClusterNumFaces<=NumberOfFaces)));
VerticesToRemoveIndexes = unique(reshape(MeshStruct.Faces(FacesToRemoveIndexes,:),[],1));

% Remove faces
MeshStruct.Faces(FacesToRemoveIndexes,:) = [];

% Remove Edges
if isfield(MeshStruct,"Edges") && isfield(MeshStruct,"EdgeLength") && isfield(MeshStruct,"EdgeTagging")
    EdgesConnectivityToSmallClusters = sum(ismember(MeshStruct.Edges, VerticesToRemoveIndexes),2);
    VerticesToRemoveIndexes = VerticesToRemoveIndexes(~ismember(VerticesToRemoveIndexes,MeshStruct.Edges(EdgesConnectivityToSmallClusters == 1,:)));
    EdgesToRemove = find(EdgesConnectivityToSmallClusters == 2);
    MeshStruct.Edges(EdgesToRemove,:) = [];
    MeshStruct.EdgeLength(EdgesToRemove) = [];
    MeshStruct.EdgeTagging(EdgesToRemove) = [];

    % Usefull check, but time consiming
    % if ~EdgeCheck(MeshStruct)
    %     error('Bad Edge Matrix');
    % end
end

MeshStruct = DeleteVertices(MeshStruct,VerticesToRemoveIndexes);
end