function [labels, imageLabelsMasked] = findLabelsInMaskedRegion(imageLabels, mask)
%FINDLABELSINMASKEDREGION return the list of labels that are within the
%mask
%   [labels, imageLabelsMasked] = findLabelsInMaskedRegion(imageLabels, mask)
%       Input:
%           imageLabels: matrix of positive integers as the cluster labels
%               obtained by "spdbscan"
%           mask: matrix of logicals indicating a masked region
%       Output:
%           labels: list of labels in the mask
%           imageLabelsMasked: matrix of labels in which the unmasked
%           region labels are forced to zero

imageLabelsMasked = imageLabels.*mask;
labels = unique(imageLabelsMasked);
labels = labels(2:end);
end

