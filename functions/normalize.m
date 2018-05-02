function [ imageNormed ] = normalize( image )
%NORMALIZE normalize the image in terms of the background color in the Lab
%color space


imageLab = rgb2lab(image); % convert rgb image to lab space

normFactor = [1/median(median(imageLab(:,:,1)))*50, ...
    -median(median(imageLab(:,:,2))), ...
    -median(median(imageLab(:,:,3)))]; % normalize in lab space

imageLabNormed = imageLab;
imageLabNormed(:,:,1) = imageLabNormed(:,:,1)*normFactor(1);
imageLabNormed(:,:,2) = imageLabNormed(:,:,2)+normFactor(2);
imageLabNormed(:,:,3) = imageLabNormed(:,:,3)+normFactor(3);


imageNormed = lab2rgb(imageLabNormed); 

end

