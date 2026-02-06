function State = UpdateWaitbar(Progress, State, Handler, Step, Message)
% This function update the second waitbar
if (Progress > State + Step) || (Step < 0)
    if nargin == 5
        waitbar(Progress, Handler,Message);
    else
        waitbar(Progress, Handler);
    end
    State = Progress;
end

end