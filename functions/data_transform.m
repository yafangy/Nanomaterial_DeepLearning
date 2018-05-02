%% User Inputs

packagePath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project';
dataPath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project';

sourceFolder = 'data_cropped';

resultFolder = 'data_transform';

croppedImageFolder = 'images';

pixelLabelFolder = 'labels';

imageExtensions = '.jpg';
imageTags = {'transformed'};

labelExtension = '.png';

dataFilenameFormat = 'data%04d%s'; % e.g. data0001.jpg

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


    % rotate the image
    for rotateTimes = 1:4
        image = imrotate(image, 90);
        label = imrotate(label, 90);
        tags = sprintf('_rotate%i',mod(rotateTimes*90,360));
        imwrite(image, fullfile(transformImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
        imwrite(label, fullfile(transformPixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
        figure(1); 
        imshow(image); 
        pause(0.01);
    end
    
    % flip the image
    for flipXY = 1:2 %flip in X or Y direction
        image_flip = flip (image,flipXY);
        label_flip = flip (label,flipXY);
        tags = sprintf('_flip%i',flipXY);
        imwrite(image, fullfile(transformImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
        imwrite(label, fullfile(transformPixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
        figure(1); 
        imshow(image_flip); 
        pause(0.01);
    end

end