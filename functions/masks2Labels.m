function imageLabels = masks2Labels(cellMasks)
%MASKS2LABELS convert a cell array of mask matrices into a single label
%matrix
%   imageLabels = masks2Labels(cellMasks)
%       Input: 
%           cellMasks: a cell array of mask matrices
%       Output:
%           imageLabels: a matrix of labels (1,2,3...)
imageLabels = zeros(size(cellMasks{1}));
for label = 1:length(cellMasks)
    mask = cellMasks{label};
    
    % check if current mask has already (partially) labeled. This step is
    % to make sure the input masks do not overlap

    if any(imageLabels(mask))
        warning('The input masks are overlapping with each other')
    end
    
    imageLabels(mask) = imageLabels(mask)+label;
end

