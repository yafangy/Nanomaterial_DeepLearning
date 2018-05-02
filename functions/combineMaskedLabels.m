function imageLabelsCombined = combineMaskedLabels(cellImageLabels,cellMasks)
%COMBINEMASKEDLABELS combine the labels of images in each masked regions
%(ignore the labeling in the unmasked regions
%   imageLabelsCombined = combineMaskedLabels(cellImageLabels,cellMasks)
%       Input: 
%           cellImageLabels: a cell array of matrices with labels
%           cellMasks: a cell array of matrices with logicals indicating
%               masks of each label matrix
%       Output:
%           imageLabelsCombined: a matrix that combined the labels with in
%               each masked regions, reordered as 1,2,3,...

imageLabelsCombined = zeros(size(cellImageLabels{1}));
currentLabel = 1;
for iter = 1:length(cellImageLabels)
    imageLabels = cellImageLabels{iter};
    masks = cellMasks{iter};
    
    oldLabels = unique(imageLabels(masks));
    
    for iter2 = 1:length(oldLabels)
        oldLabel = oldLabels(iter2);
        imageLabelsCombined(imageLabels==oldLabel) = ...
            imageLabelsCombined(imageLabels==oldLabel)+currentLabel;
        currentLabel = currentLabel + 1;
    end
    
end

end

