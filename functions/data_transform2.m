%% User Inputs

packagePath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project';
dataPath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project';

sourceFolder = 'data_cropped';

resultFolder = 'data_transform_2';

croppedImageFolder = 'images';

pixelLabelFolder = 'labels';

imageExtensions = '.jpg';
imageTags = {'transformed'};

labelExtension = '.png';

dataFilenameFormat = 'data%04d%s'; % e.g. data0001.jpg

% uniform size of image
numrows = 100; 
numcols = 100;

%% initialization

configure(packagePath); % configure the paths for the package

sourcePath = fullfile(dataPath, sourceFolder);
resultPath = fullfile(dataPath, resultFolder);
croppedImagePath = fullfile(sourcePath,croppedImageFolder);
pixelLabelPath = fullfile(sourcePath, pixelLabelFolder);
transformImagePath = fullfile(resultPath,croppedImageFolder);
transformPixelLabelPath = fullfile(resultPath, pixelLabelFolder);

%% creat new folders for the results (if not existed)

if ~exist(resultPath, 'dir')
    mkdir(resultPath);
end

if ~exist(transformImagePath, 'dir')
    mkdir(transformImagePath);
end

if ~exist(transformPixelLabelPath, 'dir')
    mkdir(transformPixelLabelPath);
end

%% read the image and label files

% read the image list
imageList = {};


imageList = [imageList;...
    getAllFiles(sourcePath, sprintf('*%s',imageExtensions), 0)];


%% generate data

figure(1);clf(1);
figure(1);

numberOfImages = length(imageList);

for iter = 1:numberOfImages
    % pick up one image randomly from the list
    imageFilename = imageList{iter};
    
    [path, name, ext] = fileparts(imageFilename);
    
    labelFilename = sprintf('%s%s',name, labelExtension);
    
    image = imread(fullfile(croppedImagePath,imageFilename)); % read the image file
    
    label = imread(fullfile(pixelLabelPath,labelFilename));
    
    
    % shear the image
    
    % X direction
    tform = affine2d([1 0 0; rand() 1 0; 0 0 1]);
    warpImage = imresize(imwarp(image,tform), [numrows numcols]);
    warpLabel = imresize(imwarp(label,tform), [numrows numcols]);
    tags = sprintf('_shear1_%f',rand());
    imwrite(warpImage, fullfile(transformImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
    imwrite(warpLabel, fullfile(transformPixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
    figure(1);
    imshow(warpImage);
    pause(0.01);
 
    % Y direction shear
    tform = affine2d([1 rand() 0; 0 1 0; 0 0 1]);
    warpImage = imresize(imwarp(image,tform), [numrows numcols]);
    warpLabel = imresize(imwarp(label,tform), [numrows numcols]);
    tags = sprintf('_shear2_%f',rand());
    imwrite(warpImage, fullfile(transformImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
    imwrite(warpLabel, fullfile(transformPixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
    figure(1);
    imshow(warpImage);
    pause(0.01);
    
    %rotate image
    rotateAngle = rand()*360;
    rotateImage = imrotate(image, rotateAngle);
    rotateLabel = imrotate(label, rotateAngle);
    tags = sprintf('_rotate%f',rotateAngle);
    imwrite(rotateImage, fullfile(transformImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
    imwrite(rotateLabel, fullfile(transformPixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
    figure(1);
    imshow(rotateImage);
    pause(0.01);
            
end