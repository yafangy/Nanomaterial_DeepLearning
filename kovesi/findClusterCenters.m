function [centers, labels] = findClusterCenters(imageLabels)
%FINDCLUSTERCENTERS find the center coordinates of each cluster as
%indicated in the matrix imageLabels
%   [centers, labels] = findClusterCenters(imageLabels)
%       Input: 
%           imageLabels: matrix of labels
%       Output:
%           centers: a N by 2 matrix that indicates the coordinates of the
%               centers in the image; N is the number of labels
%           labels: a N by 1 vector of labels

labels = unique(imageLabels);
centers = zeros(length(labels),2);

for iter = 1:length(labels)
    label = labels(iter);
    inds = find(imageLabels==label);
    [rows, cols] = ind2sub(size(imageLabels), inds);
    row = median(rows);
    col = median(cols);
    centers(iter,:) = round([col, row]);
end

