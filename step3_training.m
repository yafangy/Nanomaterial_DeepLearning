%% configure the paths for the package

dataPath = fullfile(pwd, 'Training_data');
imageFolder = 'images';
labelFolder = 'labels';
labelPath = fullfile(dataPath, labelFolder);
imagePath = fullfile(dataPath, imageFolder);

imageSize = [100,100,3];

configure(pwd); % configure the paths for the package

%% generate training, validation data
imds = imageDatastore(imagePath);

classNames = ["background","monolayer","multilayer"];
pixelLabelIDs = [1,2,3];
numClasses = 3;

pxds = pixelLabelDatastore(labelPath, classNames, pixelLabelIDs);

% partition the dataset into training and validation
% 60 percent for training, 30 percent for validation, 10 percent for test
[imdsTrain, imdsValid, imdsTest, pxdsTrain, pxdsValid, pxdsTest] = partitionSemanticData(imds, pxds); 
trainingData = pixelLabelImageSource(imdsTrain, pxdsTrain);
validData = pixelLabelImageSource(imdsValid, pxdsValid);

%% Network
% count pixel numbers for each class
tbl = countEachLabel(pxds);
imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;

% assign class weights
classWeights = median(imageFreq) ./ imageFreq;  % this is the natural choice
classWeights = [0.2, 4, 1];  % class weight can be adjusted to achieve best performance

% assign network depth
depth = 4;  % depth of SegNet = 4

% define architecture of semantic neural network
pxLayer = pixelClassificationLayer('Name','labels','ClassNames', tbl.Name, 'ClassWeights', classWeights);
layers = segnetLayers(imageSize, numClasses, depth);
layers = removeLayers(layers,'pixelLabels');
layers = addLayers(layers, pxLayer);
layers = connectLayers(layers, 'softmax', 'labels');

% options
opts = trainingOptions('sgdm',...
    'Momentum', 0.9, ...
    'ExecutionEnvironment','gpu',...   % use GPU/CPU for training
    'InitialLearnRate', 1e-2, ...
    'MaxEpochs', 20,...  % max epochs, default = 20
    'MiniBatchSize',16,...
    'Shuffle', 'every-epoch', ...
    'Plots','training-progress',...
    'VerboseFrequency', 2);

%% train and save training info
% training
[net, traininfo] = trainNetwork(trainingData, layers, opts);
% save the training info
save(sprintf('train_depth%i_classweight_%d_%d_%d.mat',depth, classWeights(1), classWeights(2), classWeights(3)), 'net', 'traininfo', 'layers','classWeights');

%% Validation
pxdsResults = semanticseg(imdsValid,net,'WriteLocation',tempdir,'Verbose',true);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsValid,'Verbose',true);
metrics.DataSetMetrics,
metrics.ClassMetrics,

%% test
pxdsResults = semanticseg(imdsTest,net,'WriteLocation',tempdir,'Verbose',true);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',true);
metrics.DataSetMetrics,
metrics.ClassMetrics,

% visualize test
numValid = 16; % randomly choose 16 validation image and plot the classification result
for p = 1:numValid
    index = ceil(randNum*numel(imdsValid.Files));
    imageFile = imdsValid.Files(index);
    labelFile = pxdsResults.Files(index);
    
    image = imread(imageFile{1});
    label = imread(labelFile{1});
    
    imageWithLabelBoundaries = ...
        drawregionboundaries(label==2, image,[255,0,0]);
    
    imageWithLabelBoundaries = ...
        drawregionboundaries(label==3, ...
        imageWithLabelBoundaries,[0,0,255]);
    
    figure(100);
    subplot(ceil(sqrt(numValid)),ceil(sqrt(numValid)),p);
    imshow(imageWithLabelBoundaries);
end