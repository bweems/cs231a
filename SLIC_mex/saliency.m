%======================================================================
%SLIC demo
% Copyright (C) 2015 Ecole Polytechnique Federale de Lausanne
% File created by Radhakrishna Achanta
% Please also read the copyright notice in the file slicmex.c 
%======================================================================
%Input parameters are:
%[1] 8 bit images (color or grayscale)
%[2] Number of required superpixels (optional, default is 200)
%[3] Compactness factor (optional, default is 10)
%
%Ouputs are:
%[1] labels (in raster scan order)
%[2] number of labels in the image (same as the number of returned
%superpixels
%
%NOTES:
%[1] number of returned superpixels may be different from the input
%number of superpixels.
%[2] you must compile the C file using mex slicmex.c before using the code
%below
%======================================================================
%img = imread('someimage.jpg');
clear all; close all; clc;
im = imread('bee.jpg');
colorTransform = makecform('srgb2lab');
im = applycform(im, colorTransform);
I = double(im);
X = reshape(I,size(I,1)*size(I,2),3);
coeff = pca(X);
% Itransformed = X*coeff;
% Ipc1 = reshape(Itransformed(:,1),size(I,1),size(I,2));
% Ipc2 = reshape(Itransformed(:,2),size(I,1),size(I,2));
% Ipc3 = reshape(Itransformed(:,3),size(I,1),size(I,2));
% figure, imshow(Ipc1,[]);
% figure, imshow(Ipc2,[]);
% figure, imshow(Ipc3,[]);
[l, Am, Sp, d] = slic(im,100,10, 1, 'mean');
cd = colorDistinctness(l, Sp);
cd = cd/max(cd(:));
pd = patternDistinctness(l, Sp, coeff);
pd = pd/max(pd(:));

perim = true(size(im,1), size(im,2));
for k = 1 : max(l(:))
    regionK = l == k;
    perimK = bwperim(regionK, 4);
    perim(perimK) = false;
end

brightness = zeros(size(im, 1), size(im, 2));
for k = 1 : max(l(:))
    regionC = l == k;
    brightness(regionC) = cd(k);
end

pattern_distinctness = zeros(size(im, 1), size(im, 2));
for k = 1 : max(l(:))
    regionC = l == k;
    pattern_distinctness(regionC) = pd(k);
end

perim = uint8(cat(3,perim,perim,perim));
brightness = cat(3, brightness, brightness, brightness);
pattern_distinctness = cat(3, pattern_distinctness, pattern_distinctness, pattern_distinctness);
center_weights = centerWeight(im);
G = fspecial('gaussian',[size(im, 1), size(im, 2)], max(size(im)));
G = G/max(G(:));
G = cat(3, G, G, G);

finalImage = uint8(pattern_distinctness .* brightness .* double(im) .* double(perim));
imshow(finalImage);
figure
im_saliency = pattern_distinctness .* brightness;
Ig_saliency = G .* im_saliency;
imshow(im_saliency)
figure
imshow(Ig_saliency)


