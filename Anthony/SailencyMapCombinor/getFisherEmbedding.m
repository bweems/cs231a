function [embedding] = getFisherEmbedding(im, means, covariances, priors)
    
    im = imread(im);
    img = single(rgb2gray(im));
    img_sift = vl_sift(img);
    embedding = vl_fisher(img_sift, means, covariances, priors);

    embedding = embedding'; % For consistency across the feature API we return row vectors
