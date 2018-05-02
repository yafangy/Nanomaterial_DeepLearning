function [ vectors ] = image2poslab( image )
%IMAGE2LABPOS Summary of this function goes here
%   Detailed explanation goes here

lab = rgb2lab(reshape(image,[],3));

normLab = lab/max(lab(:,1));

size_image = size(image);

numberOfRows = size_image(1);

numberOfCols = size_image(2);

[X, Y] = meshgrid((1:numberOfRows)/numberOfRows, (1:numberOfCols)/numberOfCols);

pos = [reshape(X,[],1),reshape(Y,[],1)];

vectors = [pos, normLab];

end

