function [PrincipalDir1, PrincipalDir2] = ComputePrincipalDirections(MeshStruct)
% This function computes the principal curvature directions for every
% vertex. Uses addon to compute principal curvature directions (very slow)

FV.faces = MeshStruct.Faces;
FV.vertices=MeshStruct.Vertices;
[~,PrincipalDir1,PrincipalDir2,~,~,~]= GetCurvatures( FV ,0);
end