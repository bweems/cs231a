function [] = color_parser(im)

[labels, numlabels] = slicmex(im,5000,100);%numlabels is the same as number of superpixels
imagesc(labels);
colorTransform = makecform('srgb2lab');
lab = applycform(im, colorTransform);
imshow(lab)


end

