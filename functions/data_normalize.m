%% User Inputs

packagePath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project/data_forNN_Cosmi_1000images';
dataPath = '/Users/yafang/Dropbox (MIT)/6.867 hw/6.867 Study Group/Project/data_forNN_Cosmi_1000images';

resultFolder = 'normed_transformed';

ImageFolder = 'images';

pixelLabelFolder = 'labels';

imageExtensions = '.jpg';

labelExtension = '.png';

dataFilenameFormat = 'data%04d%s'; % e.g. data0001.jpg

% uniform size of image
numrows = 100; 
numcols = 100;

%% initialization

configure(packagePath); % configure the paths for the package

sourcePath = dataPath;
resultPath = fullfile(dataPath, resultFolder);
croppedImagePath = fullfile(sourcePath,ImageFolder);
pixelLabelPath = fullfile(sourcePath, pixelLabelFolder);
normalizeImagePath = fullfile(resultPath,ImageFolder);
normalizePixelLabelPath = fullfile(resultPath, pixelLabelFolder);

%% creat new folders for the results (if not existed)

if ~exist(resultPath, 'dir')
    mkdir(resultPath);
end

if ~exist(normalizeImagePath, 'dir')
    mkdir(normalizeImagePath);
end

if ~exist(normalizePixelLabelPath, 'dir')
    mkdir(normalizePixelLabelPath);
end

%% read the image and label files

% read the image list
imageList = {};


imageList = [imageList;...
    getAllFiles(croppedImagePath, sprintf('*%s',imageExtensions), 0)];


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
    
    % resize image if not 100*100 size
    [Xsize, Ysize, Zsize] = size(image);
    if Xsize ~= numrows || Ysize ~= numcols
        image = imresize(image, [numrows, numcols]);
        label = imresize(label, [numrows, numcols]);
    end
    
    % normalized the image
    
    imageNormed = normalize(image);
    tags = '_normalized';
    imwrite(imageNormed, fullfile(normalizeImagePath,sprintf('%s%s%s',name,tags,'.jpg')));
    imwrite(label, fullfile(normalizePixelLabelPath,sprintf('%s%s%s',name,tags,'.png')));
    figure(1);
    imshow(imageNormed);
    pause(0.01);
    
    
 
end