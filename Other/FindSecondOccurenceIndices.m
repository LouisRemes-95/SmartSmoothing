function SecondOccurenceIndices = FindSecondOccurenceIndices(Values)
% This function returns the indices of duplicates (excluding the first occurence)

[~,ia,~] = unique(Values,'stable','rows');
SecondOccurenceIndices = setdiff(1:size(Values,1),ia,'stable');
end