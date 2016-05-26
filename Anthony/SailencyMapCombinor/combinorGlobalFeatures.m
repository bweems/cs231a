function [ imageFeatures ] = CombinorGlobalFeatures( image )
%COMBINORLOCALFEATURES Summary of this function goes here
%   Detailed explanation goes here
% imageFeatures should be a row vector [ 1 x numFeatures ]

  % TODO below is a place holder
  imageFeatures = [mean(mean(image(:, :, 1))), mean(mean(image(:, :, 2))), mean(mean(image(:, :, 3)))];

end
