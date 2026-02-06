function MeshStruct = SetBoundaries(MeshStruct, Boundaries)
% This function populates the MeshStruct.Boundaries variable according to
% Boundaries (limits of the mesh by default)

switch nargin
    case 2
        MeshStruct.Boundaries = Boundaries;
    otherwise
        for i = 1:3
            MeshStruct.Boundaries(i,:) = [min(MeshStruct.Vertices(:,i)) max(MeshStruct.Vertices(:,i))];
        end
end

% Tags each vertex
MeshStruct = BoundaryTagging (MeshStruct);
end