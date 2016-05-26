% This is a copy of generateJNNSaliencyMaps except with the KNN parts
% switched for GMM parts

rawImageDir = fullfile('..', 'MSRA-B');
outputDir = fullfile('GMMOutput');
mkdir(outputDir);

imageSaliencyMapDir = fullfile('..', 'MSRA-B-SegmentationSaliencyMaps');
smapDirectories = dir(imageSaliencyMapDir);
% Remove '.' and '..'
ind = [];
for ix = 1 : length(smapDirectories)
    if strcmp(smapDirectories(ix).name, '.') || strcmp(smapDirectories(ix).name, '..') ...
            || strcmp(smapDirectories(ix).name, 'Progress.txt')
        ind = [ind ix];
        continue;
    end
end
smapDirectories(ind) = [];
numSmapDirs = length(smapDirectories);

featureMatrix = csvread('featureMatrix.csv');
correctWeightsMatrix = csvread('outputMatrix.csv');

imageNameList = dir(fullfile(imageSaliencyMapDir, '1', '*.jpg'));
numImages = length(imageNameList);

% TODO move this to another file and optimize the loss (the choice of 10
% here is arbitrary and should be choosen so that the error in minimized
% (AUC score is maximized)
rng(123573);
[numDataPoints, numWeights] = size(correctWeightsMatrix);
numClusters = 10;
GMModel = fitgmdist(featureMatrix, numClusters, 'RegularizationValue', 0.01);
clusterWeights = zeros(numClusters, numWeights);
clusterAssignments = cluster(GMModel, featureMatrix);
for i = 1:numClusters
    clusterWeights(i, :) = mean(correctWeightsMatrix(clusterAssignments == i, :));
end

parfor imageIter = 1:numImages

    outputFile = fullfile(outputDir, imageNameList(imageIter).name);

    if exist(outputFile, 'file')
       continue;
    end
    
    rawImage = imread(fullfile(rawImageDir, ...
        imageNameList(imageIter).name(1), ...
        imageNameList(imageIter).name));

    [imh, imw] = size(rawImage);
    smaps = zeros(imh, imw, numSmapDirs);
    for segmentationIter = 1:numSmapDirs
      smaps(:, :, segmentationIter) = im2double(imread( ...
          fullfile(imageSaliencyMapDir, int2str(segmentationIter), ...
          imageNameList(imageIter).name)));
    end
    
    % weight and smap prediction using GMM
    imageFeatures = combinorGlobalFeatures(rawImage);
    clusterScores = posteriors(GMModel, imageFeatures);
    clusterScores = clusterScores / sum(clusterScores);
    weights = zeros(1, numWeights);
    for clusIter = 1:numClusters
       weights = weights + clusterWeights(clusIter, :) * clusterScores(clusIter) 
    end
    smap = combineSmapsWithWeights( weights, smaps )

    imwrite(smap, outputFile);
end