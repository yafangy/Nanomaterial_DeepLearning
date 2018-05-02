function [backgroundLabel, backgroundMask] = findBackgroundCluster(imageLabels)
%FINDBACKGROUNCLUSTER find the background cluster (with the largest area)
%and return the label
%   [backgroundLabel, backgroundMask] = findBackgroundCluster(imageLabels)
%       Input:
%           imageLabels: matrix of positive integers as the cluster labels
%               obtained by "spdbscan"
%       Output:
%           backgroundLabel: the integer of the background label
%           backgroundMask: matrix of logicals indicating the background
%               cluster
imageLabelsUniq = unique(imageLabels);
maxArea = 0;
for iter = 1:length(imageLabelsUniq)
    label = imageLabelsUniq(iter);
    inds = find(imageLabels==label);
    area = length(inds);
    if area>maxArea
        maxArea = area;
        backgroundLabel = label;
        backgroundMask = (imageLabels==label);
    end
end

end

