function imageLabelsCorrected = correctLabels(imageLabels, imageClusters, labelsToBeCorrected, cellClusters)
%CORRECTLABELS corect the labels in imageLabels 
%   imageLabelsCorrected = correctLabels(imageLabels, imageClusters, labelsToBeCorected, cellClusters)
%       Input: 
%           imageLabels: label matrix to be corrected
%           imageClusters: cluster matrix (with smaller cluster regions)
%               used to correct the imageLabels matrix.
%           labelsToBeCorrected: a list of labels that needs to be
%               corrected
%           cellClusters: a cell array of cluster lists that associated
%               with the imageClusters matrix that needs to be corrected.
%               The cellClusters -> labelToBeCorrected mapping specifies
%               the connections between the cluster regions in imageCluster
%               matrix and the corrected label in imageLabels matrix

imageLabelsCorrected = imageLabels;

for iter = 1:length(labelsToBeCorrected)
    label = labelsToBeCorrected(iter);
    clusters = cellClusters{iter};
    
    for iter2 = 1:length(clusters)
        cluster = clusters(iter2);
        imageLabelsCorrected(imageClusters==cluster) = ...
            imageLabelsCorrected(imageClusters==cluster)*0 + label;
    end
end

end

