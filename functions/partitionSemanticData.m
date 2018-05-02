function [imdsTrain, imdsValid, pxdsTrain, pxdsValid] = partitionSemanticData(imds, pxds)
%PARTITIONSEMANTICDATA Summary of this function goes here
%   Detailed explanation goes here

% Partition CamVid data by randomly selecting 60% of the data for training. The
% rest is used for testing.

% Set initial random state for example reproducibility.
rng(0);
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% Use 60% of the images for training.
Ntrain = round(0.60 * numFiles);
trainingIdx = shuffledIndices(1:Ntrain);

% Use 30% of the images for validation.
Nvalid = round(0.30 * numFiles);
validIdx = shuffledIndices(Ntrain+1:Ntrain+Nvalid);

% Use the rest for testing.
testIdx = shuffledIndices(Ntrain+Nvalid+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
validImages = imds.Files(validIdx);
testImages = imds.Files(testIdx);
imdsTrain = imageDatastore(trainingImages);
imdsValid = imageDatastore(validImages);
imdsTest = imageDatastore(testImages);

% Extract class and label IDs info.
classes = pxds.ClassNames;
labelIDs = 1:numel(pxds.ClassNames);

% Create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
validLabels = pxds.Files(validIdx);
testLabels = pxds.Files(testIdx);
pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsValid = pixelLabelDatastore(validLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);

end

