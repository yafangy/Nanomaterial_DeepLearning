%% User Inputs

dataPath = fullfile(pwd, 'Test_example');

imageFolder = 'images';
resultFolder = 'classified';
imageExtensions = {'.jpg'};
netExtensions = {'.mat'};

croppedImageSize = 1000;
numberOfDataPoints = 50;

%% initialization

configure(pwd); % configure the paths for the package

imagePath = fullfile(dataPath, imageFolder);
netPath = pwd;
resultPath = fullfile(dataPath, resultFolder);

%% creat new folders for the results (if not existed)

if ~exist(resultPath, 'dir')
    mkdir(resultPath);
end

%% read the image files

% read the image list
imageList = {};
for iter = 1:length(imageExtensions)
    imageList = [imageList;...
        getAllFiles(imagePath, sprintf('*_normalized%s',imageExtensions{iter}), 0)];
end

imageListOriginal = {};
for iter = 1:length(imageExtensions)
    imageListOriginal = [imageListOriginal;...
        getAllFiles(imagePath, sprintf('*_o%s',imageExtensions{iter}), 0)];
end

%% read the net files

netName = 'trainNet.mat';  % load the trained SegNet from current directory
load(fullfile(netPath,netName));

%% For each image, do a pixel-wise classification with each trained SegNet
numberOfImages = length(imageList);
for index_imag = 1:numberOfImages   % for each image
    
    % Read image
    imageFilename = imageList{index_imag};
    imageFilenameOriginal = imageListOriginal{index_imag};
    [path, name, ext] = fileparts(imageFilename);    
    
    % Plot original image
    imageOriginal = imread(fullfile(imagePath,imageFilenameOriginal));
    figure(100); clf(100);
    figure(100);
    subplot(1,2,1);
    imshow(imageOriginal);
    title('original');
    pause(0.05);
    
    % Predict label by SegNet and plot the result
    image = imread(fullfile(imagePath,imageFilename));
    image = imresize(image,0.1);
    
    label = uint8(semanticseg(image, net));
    imageWithLabelBoundaries = ...
        drawregionboundaries(label==2, image ,[255,0,0]);
    
    imageWithLabelBoundaries = ...
        drawregionboundaries(label==3, imageWithLabelBoundaries,[0,0,255]);
    
    figure(100);
    subplot(1,2,2);
    imshow(imageWithLabelBoundaries);
    title('classified');
    pause(1);
    saveas(gcf,fullfile(resultPath,sprintf('Test_data%s.fig',name)));  % Save the result
    
    figure(200);
    subplot(4,5,index_imag);
    imshow(imageWithLabelBoundaries);
    pause(0.5);
    
end
