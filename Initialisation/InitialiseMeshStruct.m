function MeshStruct = InitialiseMeshStruct(Vertices, Faces, DoCleaning)
% This function initialises a MeshStruct

% Inputs:
%   Vertices = The nodes coordinates (vx3 matrix) [double]
%   Faces = The connetivity matrix (fx3 matrix) [uint32]
%   DoCleaning = Does mesh cleaning [logical], true by default

% Output:
%   MeshStruct = Struct holding all the relevant information for the process

if nargin ~= 3
    DoCleaning = true;
end

%% Creates an "basic" MeshStruct
MeshStruct.Vertices = Vertices;
MeshStruct.Faces = int32(Faces);

%% Cleans the mesh
if DoCleaning
    MeshStruct = RemoveDuplicateFaces(MeshStruct);
    MeshStruct = RemoveMultiFolds(MeshStruct);
    MeshStruct = RemoveSmallClusters(MeshStruct);
end

%% Edge Computation
MeshStruct = InitialiseEdges(MeshStruct);
MeshStruct = ComputeEdgeLength(MeshStruct);
MeshStruct = ResetEdgeTagging(MeshStruct);

%% Place holder
MeshStruct.VertexNormals = zeros(size(MeshStruct.Vertices));
MeshStruct.K1 = zeros(size(MeshStruct.Vertices,1),1);
MeshStruct.K2 = zeros(size(MeshStruct.Vertices,1),1);
end