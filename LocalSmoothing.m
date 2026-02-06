function MeshStruct = LocalSmoothing(Vertices, Faces, Boundaries, K1_Max, K2_Max, FilePath)
% This function overarches the local smoothing process . It iteratively 
% reduces curvature based on the curvature features of the specific nodes
% for a triangulated suface mesh.

% Inputs:
%   Vertices = The nodes coordinates (vx3 matrix) [double]
%   Faces = The connetivity matrix (fx3 matrix) [uint32]
%   K1_Max = Maximum allowed first principal curvature in absolute value [double]
%   K2_Max = Maximum allowed second principal curvature in absolute value [double]
%   FilePath = Path to the saved files [string]

% Output:
%   MeshStruct = Struct holding all the relevant information for the process
%       MeshStruct.Vertices = The nodes coordinates (vx3) [double]
%       MeshStruct.Faces = The connetivity matrix (fx3) [uint32]
%       MeshStruct.Edges = The edge connectivity matrix (ex2) [uint32]
%       MeshStruct.EdgeLengths = Length of each edge (ex1) [double]
%       MeshStruct.EdgeTagging = Binary output variable (ex1) [logical]
%           Used to tag edges that should be merged (mainly small clusters)
%       MeshStruct.VertexNormals = Normalized normal vectors (vx3) [double]
%       MeshStruct.K1 = First principal curvature in absolute value (vx1) [double]
%       MeshStruct.K2 = Second principal curvature in absolute value (vx1) [double]
%       MeshStruct.Boundaries = Bounding box of the mesh (3x2) [double]
%           Rows = x ,y and z directions            Columns = min and max
%       MeshStruct.BoundaryTagging = Stores nodes to boundary linking (vx6) [logical]
%           Which node should remain on which boundary: [X_min X_max Y_min ...]

% Waitbar
FirstWaitbar = InitialiseFirstWaitbar('Initialisation...');

MeshStruct = InitialiseMeshStruct(Vertices,Faces);
MeshStruct = SetBoundaries(MeshStruct,Boundaries); % Can set custom boudaries
MeshStruct = MergeSplitByDistance(MeshStruct,2);

% Mesh after first cleaning process
save(append(FilePath,"MergedMesh.mat"),"MeshStruct");

%% Local smoothing process
load(append(FilePath,"MergedMesh.mat"),"MeshStruct");

MeshStruct = ComputeCurvatures(MeshStruct);

OverallMask = abs(MeshStruct.K2) > K2_Max | abs(MeshStruct.K1) > K1_Max;

% Waitbar
InitialOverallMaskSize = sum(OverallMask);

while any(abs(MeshStruct.K2) > K2_Max) || any(abs(MeshStruct.K1) > K1_Max)

    PreviousMesh = MeshStruct;

    % Waitbar (Smoothing)
    UpdateOverallWaitbar(MeshStruct, K1_Max, K2_Max, InitialOverallMaskSize, FirstWaitbar, 'Localy smoothing - Smoothing...')
    MeshStruct = SmartSmoothPeeks(MeshStruct, K2_Max);

    % Waitbar (SadelSwelling)
    UpdateOverallWaitbar(MeshStruct, K1_Max, K2_Max, InitialOverallMaskSize, FirstWaitbar, 'Localy smoothing - SadelSwelling...')
    MeshStruct = SmartSwellSadel(MeshStruct, K2_Max);

    % Waitbar (Swelling)
    UpdateOverallWaitbar(MeshStruct, K1_Max, K2_Max, InitialOverallMaskSize, FirstWaitbar, 'Localy smoothing - Swelling...')
    MeshStruct = SurroundSwelling(MeshStruct, K1_Max, K2_Max);

    % Corrective measure to boost convergence
    if AlmostEqual(PreviousMesh,MeshStruct)
        disp('Corrective measure is being applied')
        [CorrectionApplied, MeshStruct] = CorrectiveMeasure(MeshStruct, PreviousMesh, K2_Max);

        if ~CorrectionApplied
            warning('Corrective measure unsuccessfull!')
            break;
        end
    end

    MeshStruct = ComputeCurvatures(MeshStruct);

end

MeshStruct = RemoveDuplicateFaces(MeshStruct);
MeshStruct = RemoveBoundaryFaces(MeshStruct);
MeshStruct = CorrectBoundaryTagging(MeshStruct);

save(append(FilePath,"SmoothedMesh.mat"),"MeshStruct");
close(FirstWaitbar);
end
