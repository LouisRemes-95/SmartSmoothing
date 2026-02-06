function MeshStruct = DissociateMesh(MeshStruct, VerticesToDissociate, Fill)
% This function will look for different face "cycles" surrounding each
% VerticesToDissociate. If multiple cycles are found, dissociation is done.

if ~Fill
    VerticesStillToDissociate = VerticesToDissociate;
    for VertexToDissociate = VerticesToDissociate
        SurroundingFacesIndexes = find(any(ismember(MeshStruct.Faces,VertexToDissociate),2));
        SurroundingFaces = MeshStruct.Faces(SurroundingFacesIndexes,:);

        UsedFaces = false(size(SurroundingFaces,1),1);
        while ~all(UsedFaces)
            Start = find(~UsedFaces,1);
            UsedFaces(Start) = true;

            Cycle = false(size(UsedFaces));
            Cycle(Start) = true;

            AnalysedFaces = Start;
            while ~isempty(AnalysedFaces)
                SimilarVerts = ismember(SurroundingFaces,SurroundingFaces(AnalysedFaces(1),:));
                AdjacentFaces = find(sum(SimilarVerts,2) == 2 & sum(SimilarVerts & ismember(SurroundingFaces,VerticesStillToDissociate),2) ~= 2);
                AdjacentFaces(UsedFaces(AdjacentFaces)) = [];
                AnalysedFaces = [AnalysedFaces(2:end); AdjacentFaces];
                UsedFaces(AdjacentFaces) = true;
                Cycle(AdjacentFaces) = true;
            end

            % If MultiFold, then seperate
            if ~all(UsedFaces)
                MeshStruct.Vertices = [MeshStruct.Vertices; MeshStruct.Vertices(VertexToDissociate,:)]; % Adding vertex

                if isfield(MeshStruct,"VertexNormals")
                    MeshStruct.VertexNormals = [MeshStruct.VertexNormals; zeros(1, 3)];
                end

                if isfield(MeshStruct,"K1") && isfield(MeshStruct,"K2")
                    MeshStruct.K1 = [MeshStruct.K1; 0];
                    MeshStruct.K2 = [MeshStruct.K2; 0];
                end

                if isfield(MeshStruct,"BoundaryTagging")
                    MeshStruct.BoundaryTagging = [MeshStruct.BoundaryTagging; MeshStruct.BoundaryTagging(VertexToDissociate,:)]; % Update boundary tagging
                end

                if isfield(MeshStruct,"Edges") && isfield(MeshStruct,"EdgeLength") && isfield(MeshStruct,"EdgeTagging")
                    EdgesToRerefIndexes.Faces = SurroundingFaces(Cycle,:);
                    EdgesToRerefIndexes = InitialiseEdges(EdgesToRerefIndexes);
                    EdgesToRerefIndexes = [EdgesToRerefIndexes.Edges(:,[1 2]); EdgesToRerefIndexes.Edges(:,[2 1])];
                    [~, EdgesToRerefIndexes, ~] = intersect(MeshStruct.Edges,EdgesToRerefIndexes,'rows');
                    EdgesToDupIndexes = EdgesToRerefIndexes(all(ismember(MeshStruct.Edges(EdgesToRerefIndexes,:), VerticesStillToDissociate),2));

                    % Edge adding
                    MeshStruct.Edges = [MeshStruct.Edges; MeshStruct.Edges(EdgesToDupIndexes,:)];
                    MeshStruct = ComputeEdgeLength(MeshStruct, size(MeshStruct.Edges,1)-length(EdgesToDupIndexes)+1:size(MeshStruct.Edges,1)); % Update edge lengths
                    MeshStruct.EdgeTagging = [MeshStruct.EdgeTagging; false(length(EdgesToDupIndexes),1)];

                    % Rereferencing
                    MeshStruct = RereferenceVertex(MeshStruct, size(MeshStruct.Vertices,1), VertexToDissociate, SurroundingFacesIndexes(Cycle), EdgesToRerefIndexes);
                    MeshStruct = ComputeEdgeLength(MeshStruct, EdgesToRerefIndexes); % Update edge lengths

                    clear EdgesToRerefIndexes;
                else
                    % Rereferencing
                    MeshStruct = RereferenceVertex(MeshStruct, size(MeshStruct.Vertices,1), VertexToDissociate, SurroundingFacesIndexes(Cycle), []);
                end
            end
        end
        VerticesStillToDissociate = VerticesStillToDissociate(2:end);
    end

else
    % For Splitting pipes (the full loop is done at once)
    SurroundingFacesIndexes = find(any(ismember(MeshStruct.Faces,VerticesToDissociate),2));
    SurroundingFaces = MeshStruct.Faces(SurroundingFacesIndexes,:);

    UsedFaces = false(length(SurroundingFacesIndexes),1);
    LoopFound = false;
    while ~LoopFound
        Start = find(~UsedFaces,1);
        if isempty(Start)
            error("No more face for loop!")
        end

        UsedFaces(Start) = true;

        Cycle = false(length(SurroundingFacesIndexes),1);
        Cycle(Start) = true;

        AnalysedFaces = Start;

        LoopFound = true;
        while ~isempty(AnalysedFaces)

            SimilarVerts = ismember(SurroundingFaces,SurroundingFaces(AnalysedFaces(1),:));
            AdjacentFaces = find(sum(SimilarVerts,2) == 2 & sum(SimilarVerts & ismember(SurroundingFaces,VerticesToDissociate),2) ~= 2);
            
            if length(AdjacentFaces) <2
                LoopFound = false;
            end

            AdjacentFaces(UsedFaces(AdjacentFaces)) = [];
            AnalysedFaces = [AnalysedFaces(2:end); AdjacentFaces];
            UsedFaces(AdjacentFaces) = true;
            Cycle(AdjacentFaces) = true;
        end
    end

    % Mesh separation

    % Finding order for vertices if fill
    if length(VerticesToDissociate) ~= 3
        error("Wrong number of vertices to fill")
    end

    % Finds Node order for consistent normals
    OneConnectedFace = SurroundingFaces(find(sum(ismember(SurroundingFaces,VerticesToDissociate),2) == 2 & Cycle,1),:);
    ConnectivityOfOneConnectedFace = ismember(OneConnectedFace, VerticesToDissociate);
    VerticesOrdered = OneConnectedFace;
    VerticesOrdered(~ConnectivityOfOneConnectedFace) = VerticesToDissociate(~ismember(VerticesToDissociate,VerticesOrdered));
    VerticesOrdered = VerticesOrdered([2 1 3]);

    MeshStruct.Vertices = [MeshStruct.Vertices; MeshStruct.Vertices(VerticesOrdered,:)]; % Adding vertex

    MeshStruct.Faces = [MeshStruct.Faces; VerticesOrdered([1 3 2]); size(MeshStruct.Vertices,1)-2:size(MeshStruct.Vertices,1)]; % Face adding

    if isfield(MeshStruct,"VertexNormals")
        MeshStruct.VertexNormals = [MeshStruct.VertexNormals; zeros(length(VerticesToDissociate), 3)];
    end

    if isfield(MeshStruct,"K1") && isfield(MeshStruct,"K2")
        MeshStruct.K1 = [MeshStruct.K1; zeros(length(VerticesToDissociate),1)];
        MeshStruct.K2 = [MeshStruct.K2; zeros(length(VerticesToDissociate),1)];
    end

    if isfield(MeshStruct,"BoundaryTagging")
        MeshStruct.BoundaryTagging = [MeshStruct.BoundaryTagging; MeshStruct.BoundaryTagging(VerticesToDissociate,:)]; % Update boundary tagging
    end

    if isfield(MeshStruct,"Edges") && isfield(MeshStruct,"EdgeLength") && isfield(MeshStruct,"EdgeTagging")
        EdgesToRerefIndexes.Faces = SurroundingFaces(Cycle,:);
        EdgesToRerefIndexes = InitialiseEdges(EdgesToRerefIndexes);
        EdgesToRerefIndexes = [EdgesToRerefIndexes.Edges(:,[1 2]); EdgesToRerefIndexes.Edges(:,[2 1])];
        [~, EdgesToRerefIndexes, ~] = intersect(MeshStruct.Edges,EdgesToRerefIndexes,'rows');
        EdgesToDupIndexes = EdgesToRerefIndexes(all(ismember(MeshStruct.Edges(EdgesToRerefIndexes,:), VerticesToDissociate),2));
        % EdgesToRerefIndexes(all(ismember(MeshStruct.Edges(EdgesToRerefIndexes,:), VerticesToDissociate),2)) = [];

        % Edge adding
        MeshStruct.Edges = [MeshStruct.Edges; MeshStruct.Edges(EdgesToDupIndexes,:)];
        MeshStruct = ComputeEdgeLength(MeshStruct, size(MeshStruct.Edges,1)-length(EdgesToDupIndexes)+1:size(MeshStruct.Edges,1)); % Update edge lengths
        MeshStruct.EdgeTagging = [MeshStruct.EdgeTagging; false(length(EdgesToDupIndexes),1)];

        % Rereferencing
        for i = 1:length(VerticesToDissociate)
            MeshStruct = RereferenceVertex(MeshStruct, size(MeshStruct.Vertices,1)-length(VerticesToDissociate)+i, VerticesToDissociate(i), SurroundingFacesIndexes(Cycle), EdgesToRerefIndexes);
        end
        MeshStruct = ComputeEdgeLength(MeshStruct, EdgesToRerefIndexes); % Update edge lengths

        clear EdgesToRerefIndexes;
    else
        % Rereferencing
        for i = 1:length(VerticesToDissociate)
            MeshStruct = RereferenceVertex(MeshStruct, size(MeshStruct.Vertices,1)-length(VerticesToDissociate)+i, VerticesToDissociate(i), SurroundingFacesIndexes(Cycle), []);
        end
    end

end
end