function [means, covariances, priors] = generateGMMForFisherEmbeddings()
    run('SailencyMapCombinor/vlfeat/toolbox/vl_setup');
    imgSets = getImageSetFromTextFile('train.txt', 'MSRA-B');
    data = [];
    for i=1:length(imgSets)
        imgset = imgSets(i);
        for j=1:length(imgset.ImageLocation)
            im_path = char(imgset.ImageLocation(j));
            train_img = imread(im_path);
            train_img = single(rgb2gray(train_img));
            data = [data vl_sift(train_img)];
        end
    end
    numClusters = 30;
    [means, covariances, priors] = vl_gmm(data, numClusters);

end

