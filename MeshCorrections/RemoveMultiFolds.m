function MeshStruct = RemoveMultiFolds(MeshStruct)
% This function will remove multifolds

% MultiFolds are locations where 2 parts of a mesh connect, but there
% is no connection surface, i.e. an edge with 4 faces.

% !!! Will only update vertices and faces as this function should only be 
% used in the first cleaning step and multifolds shouldn't reappear.

% Waitbar
WaitbarState = 0;
SecondWaitbar = InitialiseSecondWaitbar('Removing multifolds...');

for Vertex = 1:int32(size(MeshStruct.Vertices,1))
    % Waitbar
    WaitbarState = UpdateWaitbar(double(Vertex)/size(MeshStruct.Vertices,1), WaitbarState, SecondWaitbar, .05);

    VertexQueue = Vertex;
    VertexesToDissociate = [];
    while ~isempty(VertexQueue)

        % Add the current vertex
        VertexesToDissociate = [VertexesToDissociate VertexQueue(1)];  % Unfortunatly no queue in matlab... (isn't a bottleneck here)

        % Find connected multifold vertexes
        [r,~] = find(MeshStruct.Faces == VertexQueue(1));
        VertSurroundingFaces = MeshStruct.Faces(r,:);
        SurroundingVertexes = reshape(VertSurroundingFaces,[],1);
        SurroundingVertexes = SurroundingVertexes(~ismember(SurroundingVertexes, VertexesToDissociate));
        [Count, UniqueVertexes] = groupcounts(SurroundingVertexes);
        VertexQueue = [VertexQueue(2:end) UniqueVertexes(Count == 4)];
    end

    MeshStruct = DissociateMesh(MeshStruct, VertexesToDissociate, false);
end

% Close Waitbar
close(SecondWaitbar);
end