function DuplicateIndices = FindDuplicateIndicesBis(Values)
% This function returns the indices of duplicates (including the first occurence)

[~,ia,ic] = unique(Values,'stable','rows');
DuplicateIndices = setdiff(1:size(Values,1),ia,'stable');
DuplicateIndices = [ia(ic(DuplicateIndices))' DuplicateIndices];
end