function MeshStruct = ComputeCurvatures(MeshStruct)
    %% Based on https://rodolphe-vaillant.fr/entry/33/curvature-of-a-triangle-mesh-definition-and-computation*
    %% http://multires.caltech.edu/pubs/diffGeoOps.pdf

    % Creates the principal vectors of each faces [AB1; AC1; BC1; AB2;...]
    FaceNodes = reshape(MeshStruct.Faces',[],1);
    FaceCoords = MeshStruct.Vertices(FaceNodes,:);
    Indexes_1 = (2:size(FaceCoords,1)+1) - (mod(1:size(FaceCoords,1),3)==0);
    Indexes_2 = (1:size(FaceCoords,1)) - (mod((1:size(FaceCoords,1))-1,3)~=0);
    Vectors = FaceCoords(Indexes_1,:) - FaceCoords(Indexes_2,:);
    
    % CrossProducts [AB1 x AC1; BC1 x BA1; CA1 x CB1;...] and DotProducts
    Indexes_1 = (1:size(Vectors,1)) - (mod(1:size(FaceCoords,1),3)==0) + (mod(1:size(FaceCoords,1),3)==2);
    Indexes_2 = (1:size(Vectors,1)) + (mod(1:size(FaceCoords,1),3)==1) - (mod(1:size(FaceCoords,1),3)==2);
    CrossProductsNorm = vecnorm(cross(repmat((-1).^(mod(1:size(Vectors,1),3)==0)',1,3).*Vectors(Indexes_1,:),...
                                      repmat((-1).^(mod(1:size(Vectors,1),3)~=1)',1,3).*Vectors(Indexes_2,:),2),2,2);
    DotProducts = dot(repmat((-1).^(mod(1:size(Vectors,1),3)==0)',1,3).*Vectors(Indexes_1,:),...
                      repmat((-1).^(mod(1:size(Vectors,1),3)~=1)',1,3).*Vectors(Indexes_2,:),2);
    
    % Area of each face
    FaceArea = CrossProductsNorm/2;

    % Angles of each angle of each face
    FaceAngles = real(acos(DotProducts./vecnorm(Vectors(Indexes_1,:),2,2)./vecnorm(Vectors(Indexes_2,:),2,2)));

    % Mixed Voronoi cell area
    FaceObtuseAngles = FaceAngles>pi/2;
    FaceObtuse = any(FaceObtuseAngles([(floor((0:length(FaceObtuseAngles)-1)/3)*3+1)' ...
                                       (floor((0:length(FaceObtuseAngles)-1)/3)*3+2)' ...
                                       (floor((0:length(FaceObtuseAngles)-1)/3)*3+3)']),2);
    Indexes_1 = (1:length(FaceAngles)) + 1 - 3*(mod(1:size(FaceCoords,1),3)==0);
    Indexes_2 = (1:length(FaceAngles)) - 1 + 3*(mod(1:size(FaceCoords,1),3)==1);
    FaceVoronoiRegions = (cot(FaceAngles(Indexes_1)) .* vecnorm(FaceCoords(Indexes_2,:) - FaceCoords,2,2).^2 +...
                          cot(FaceAngles(Indexes_2)) .* vecnorm(FaceCoords(Indexes_1,:) - FaceCoords,2,2).^2)./8;
    FaceMixedVoronoi = FaceVoronoiRegions.*~FaceObtuse +...
                       FaceArea./2.*FaceObtuseAngles +...
                       FaceArea./4.*FaceObtuse.*~FaceObtuseAngles;
    MixedVoronoiCellArea = TransferFaceToVert_mex(MeshStruct, FaceMixedVoronoi);

    % Angle summation for each node and Gaussian curvature (Kg)
    Angles = TransferFaceToVert_mex(MeshStruct, FaceAngles);
    Kg = (2*pi-Angles)./MixedVoronoiCellArea;
    Kg(any(MeshStruct.BoundaryTagging,2)) = 0; % Removes boundaries

    % Computation of the mean curvature
    % Laplace operator
    FaceDeltaP = repmat(cot(FaceAngles(Indexes_1)),1,3) .* (FaceCoords(Indexes_2,:) - FaceCoords) +...
                 repmat(cot(FaceAngles(Indexes_2)),1,3) .* (FaceCoords(Indexes_1,:) - FaceCoords);
    DeltaP = TransferFaceToVert_mex(MeshStruct, FaceDeltaP)./MixedVoronoiCellArea./2;
    
    % Absolute mean curvature
    AbsH = vecnorm(DeltaP,2,2)/2;
    AbsH(any(MeshStruct.BoundaryTagging,2)) = 0; % Removes boundaries

    % Mean curvature sign
    MeshStruct = ComputeVertexNormals(MeshStruct);
    Sign = dot(MeshStruct.VertexNormals,-DeltaP,2)<0;

    % Mean curvature (H)
    H = (-1).^Sign.*AbsH;

    % Principal curvatures with thresholding
    SqrtTerm = H.^2-Kg;

    SqrtTerm(SqrtTerm<0) = 0;

    K1 = H+sqrt(SqrtTerm);
    K2 = H-sqrt(SqrtTerm);

    % By absolute value
    MeshStruct.K1 = K1;
    MeshStruct.K1(abs(K1)<abs(K2)) = K2(abs(K1)<abs(K2));
    MeshStruct.K2 = K2;
    MeshStruct.K2(abs(K1)<abs(K2)) = K1(abs(K1)<abs(K2));

end