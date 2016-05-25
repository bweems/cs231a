function [ smap ] = combineSmapsWithWeights( weights, smaps )
%COMBINESMAPSWITHWEIGHTS Summary of this function goes here
%   Detailed explanation goes here

smap = zeros(size(smaps(:, :, 1)));
for i = 1:numel(weights)
   smap = smap + exp(1.5 * smaps(:, :, i)) * weights(i); 
end

smap = smap / numel(weights);
smap = (smap - min(smap(:))) / (max(smap(:)) - min(smap(:)) + eps) * 255;
smap = uint8(smap);
    
end

