function UpdateOverallWaitbar(MeshStruct, K1_Max, K2_Max, InitialOverallMaskSize, Handler, Message)
% This function update the overall Waitbar

MeshStruct = ComputeCurvatures(MeshStruct);
OverallMask = abs(MeshStruct.K2) > K2_Max | abs(MeshStruct.K1) > K1_Max;

Progress = (InitialOverallMaskSize-sum(OverallMask))/InitialOverallMaskSize;

UpdateWaitbar(Progress,0,Handler,-1,Message);

end