function MeshStruct = MergeSplitByDistance(MeshStruct,factor)
% This function merges and splits too small and large edges respectively.
% Merges if edge is shorter than current mean edge length divided by factor.
% Splits if edge is longer than current mean edge length multiplied by factor.

MeshStruct = ComputeEdgeLength(MeshStruct);

MeanLength = mean(MeshStruct.EdgeLength);

% Waitbar
InitialAmountOfEdgesToHandle = sum(MeshStruct.EdgeLength<MeanLength/factor) + sum(MeshStruct.EdgeLength>MeanLength*factor);
WaitbarState = 0;
SecondWaitbar = InitialiseSecondWaitbar('Merging/Splitting edges...');

Flag = true; % Flags if mesh changed during loop
while Flag
    Flag = false;
    MeanLength = mean(MeshStruct.EdgeLength);

    %% Mesh Merging
    % Find shortest viable edge
    ShortestEdge = find(MeshStruct.EdgeLength<MeanLength/factor...
        & MeshStruct.EdgeLength == min(MeshStruct.EdgeLength),1);

    % Loops as long as viable short edges are found
    while ~isempty(ShortestEdge)

        WaitbarState = UpdateSecondWaitbar(MeshStruct, MeanLength, factor, InitialAmountOfEdgesToHandle, WaitbarState, SecondWaitbar);

        MeshStruct = HandleShortEdge(MeshStruct,ShortestEdge);
        ShortestEdge = find(MeshStruct.EdgeLength<MeanLength/factor...
            & MeshStruct.EdgeLength == min(MeshStruct.EdgeLength(~MeshStruct.EdgeTagging))...
            & ~MeshStruct.EdgeTagging,1);

    end

    %% Mesh Splitting
    % Find longest viable edge
    LongestEdge = find(MeshStruct.EdgeLength>MeanLength*factor...
        & MeshStruct.EdgeLength == max(MeshStruct.EdgeLength),1);

    % Loops as long as viable long edges are found
    while ~isempty(LongestEdge)
        Flag = true;
        
        WaitbarState = UpdateSecondWaitbar(MeshStruct, MeanLength, factor, InitialAmountOfEdgesToHandle, WaitbarState, SecondWaitbar);

        MeshStruct = HandleLongEdge(MeshStruct,LongestEdge);
        LongestEdge = find(MeshStruct.EdgeLength>MeanLength*factor...
            & MeshStruct.EdgeLength == max(MeshStruct.EdgeLength),1);
    end
end

MeshStruct = RemoveSmallClusters(MeshStruct);
MeshStruct = BackOnBoundary(MeshStruct);

close(SecondWaitbar);
end

%% Local functions
function WaitbarState = UpdateSecondWaitbar(MeshStruct, MeanLength, factor, InitialAmountOfEdgesToHandle, WaitbarState, Handler)
Progress = (InitialAmountOfEdgesToHandle - sum(MeshStruct.EdgeLength<MeanLength/factor) - sum(MeshStruct.EdgeLength>MeanLength*factor))/InitialAmountOfEdgesToHandle;
WaitbarState = UpdateWaitbar(Progress, WaitbarState, Handler, .05);
end