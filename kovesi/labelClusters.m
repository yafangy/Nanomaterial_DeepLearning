function imageWithLabels = labelClusters(imageLabels, imageOriginal, labelColor)
%LABELCLUSTERS label the clusters in the image by 1,2,3,...
%   imageWithLabels = labelClusters(imageLabels, imageOriginal, labelColor)
%       Input:
%           imageLabels: a matrix of labels
%           imageOriginal: image to be labeled
%           labelColor: a string that indicates the color of the labels,
%               e.g. 'red', 'green', 'blue', 'white', 'black', ...
%       Output:
%           imageWithLabels: labeled image

% find the centers of each cluster
centers = findClusterCenters(imageLabels);

labels = unique(imageLabels);

imageWithLabels = imageOriginal;

for iter = 1:length(labels)
    label = labels(iter);

    labelPosition = centers(iter,:);
    imageWithLabels = insertText(imageWithLabels, labelPosition, label,...
        'FontSize',50,'BoxColor',...
    'white','BoxOpacity',0,'TextColor',labelColor,'AnchorPoint','Center');
end

end

