function [ imageFeatures ] = CombinorGlobalFeatures( image )
%COMBINORLOCALFEATURES Summary of this function goes here
%   Detailed explanation goes here
% imageFeatures should be a row vector [ 1 x numFeatures ]

  image = imresize(image, [200, 200]);
  imageFeatures = [mean(mean(image(:, :, 1))), mean(mean(image(:, :, 2))), mean(mean(image(:, :, 3)))];
  imageFeatures = [std2(image(:, :, 1)), std2(image(:, :, 2)), std2(image(:, :, 3)), imageFeatures];
  gray = rgb2gray(image);
  h = histogram(gray(:), 0:256 - 0.5);
  imageFeatures = [h.Values, imageFeatures];
end
