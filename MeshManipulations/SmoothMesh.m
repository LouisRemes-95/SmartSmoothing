function MeshStruct = SmoothMesh(MeshStruct, NumberOfIterations, Mask, Method, ScaleFactor, Directions)
% Sets undefined input arguments
if nargin < 1
    error("No input MeshStruct")
end
if nargin < 2
    NumberOfIterations = 1;
end
if nargin < 3
    Mask = []; % Empty mask equals no mask.
end
if nargin < 4
    Method = "Average"; % Method can be "Average", "Laplacian", "Directionnal".
end
if nargin < 5
    ScaleFactor = .5; % The scale weighs the mix of connected vertex 
                      % average (1) and the vertex himself (0).
end
if nargin < 6 && Method == "Directionnal"
    Error("No direction")
end

if ScaleFactor<0 || ScaleFactor>1
    error("ScaleFactor out of bounds")
end

% Finds the number of edges of each vertex
VertexConnections = histcounts(MeshStruct.Edges,size(MeshStruct.Vertices,1))';

for i = 1:NumberOfIterations
    
    if Method ~= "Directionnal"
        % Finds the accumulated position of the surrounding vertices
        ConnectedPositionAccumulation = zeros(size(MeshStruct.Vertices));
        ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,1)),:) =...
            [accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),1)) ...
            accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),2)) ...
            accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),3))];
        ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,2)),:) =...
            ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,2)),:) +...
            [accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),1)) ...
            accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),2)) ...
            accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),3))];

        % Smoothed positions
        if Method == "Average"
            SmoothedVertices = (ConnectedPositionAccumulation + MeshStruct.Vertices)./repmat(VertexConnections+1,1,3);
        elseif Method == "Laplacian"
            SmoothedVertices = ConnectedPositionAccumulation./repmat(VertexConnections,1,3).*repmat(ScaleFactor,size(MeshStruct.Vertices,1),3)...
                + MeshStruct.Vertices.*repmat(1-ScaleFactor,size(MeshStruct.Vertices,1),3);
        else
            error("Bad method")
        end
    else
        EdgeWeights(:,1) = abs(dot(Directions(MeshStruct.Edges(:,1),:),MeshStruct.Vertices(MeshStruct.Edges(:,1),:) - MeshStruct.Vertices(MeshStruct.Edges(:,2),:),2));
        EdgeWeights(:,2) = abs(dot(Directions(MeshStruct.Edges(:,2),:),MeshStruct.Vertices(MeshStruct.Edges(:,1),:) - MeshStruct.Vertices(MeshStruct.Edges(:,2),:),2));
        EdgeWeights = EdgeWeights.^3;

        ConnectedPositionAccumulation = zeros(size(MeshStruct.Vertices));
        ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,1)),:) =...
            [accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),1).*EdgeWeights(:,1)) ...
            accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),2).*EdgeWeights(:,1)) ...
            accumarray(MeshStruct.Edges(:,1),MeshStruct.Vertices(MeshStruct.Edges(:,2),3).*EdgeWeights(:,1))];
        ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,2)),:) =...
            ConnectedPositionAccumulation(1:max(MeshStruct.Edges(:,2)),:) +...
            [accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),1).*EdgeWeights(:,2)) ...
            accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),2).*EdgeWeights(:,2)) ...
            accumarray(MeshStruct.Edges(:,2),MeshStruct.Vertices(MeshStruct.Edges(:,1),3).*EdgeWeights(:,2))];

        WeightsAccumulation = zeros(size(MeshStruct.Vertices,1),1);
        WeightsAccumulation(1:max(MeshStruct.Edges(:,1))) = [accumarray(MeshStruct.Edges(:,1),EdgeWeights(:,1))];
        WeightsAccumulation(1:max(MeshStruct.Edges(:,2))) = WeightsAccumulation(1:max(MeshStruct.Edges(:,2)),:) +...
            [accumarray(MeshStruct.Edges(:,2),EdgeWeights(:,2))];
        
        SmoothedVertices = ConnectedPositionAccumulation./repmat(WeightsAccumulation,1,3).*repmat(ScaleFactor,size(MeshStruct.Vertices,1),3)...
            + MeshStruct.Vertices.*repmat(1-ScaleFactor,size(MeshStruct.Vertices,1),3);
    end

    % Mask application
    if isempty(Mask)
        MeshStruct.Vertices = SmoothedVertices;
    else
        MeshStruct.Vertices(Mask,:) = SmoothedVertices(Mask,:);
    end
end
end