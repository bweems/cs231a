function [embedding] = getFisherEmbedding(im, means, covariances, priors)
    
    im = imread(im);
    img = single(rgb2gray(im));
    img_sift = vl_sift(img);
    embedding = vl_fisher(img_sift, means, covariances, priors);

end

