function [ weights ] = centerWeight( im )
    weights = zeros(size(im, 1), size(im, 2));
    center = uint8([size(weights, 1)/2, size(weights, 2)/2]);
    for row=1:size(im, 1)
        for col = 1:size(im, 2)
            point = double([row, col]);
            weights(row, col) = distance(point, center);
        end
    end
    weights = -1*(weights - max(weights(:)))/max(weights(:));
end

function [dist] = distance(a, b)
    d = double(a)-double(b);
    dist = sqrt(sum(d .^ 2));
end