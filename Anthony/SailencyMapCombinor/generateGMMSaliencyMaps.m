% This is a copy of generateKNNSaliencyMaps except with the KNN parts
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

rng(123573);
[numDataPoints, numWeights] = size(correctWeightsMatrix);

numClusterList = 6:20;
AIC = zeros(1,length(numClusterList));
GMModels = cell(1,length(numClusterList));
for i = 1:length(numClusterList)
    fprintf('%d\n', i);
    GMModels{i} = fitgmdist(featureMatrix,numClusterList(i),'RegularizationValue', 0.01);
    AIC(i)= GMModels{i}.AIC;
end

[minAIC,index] = min(AIC);

GMModel = GMModels{index};
numClusters = numClusterList(index);

clusterWeights = zeros(numClusters, numWeights);
clusterAssignments = cluster(GMModel, featureMatrix);
for i = 1:numClusters
    clusterWeights(i, :) = mean(correctWeightsMatrix(clusterAssignments == i, :));
end

parfor imageIter = 1:numImages
    
    fprintf('Image iter: %d\n', imageIter);

    outputFile = fullfile(outputDir, imageNameList(imageIter).name);

    if exist(outputFile, 'file')
       continue;
    end
    
    inx = 1;
    if strcmp(imageNameList(imageIter).name(2), '0')
      inx = 1:2;
    end

    rawImage = imread(fullfile(rawImageDir, ...
        imageNameList(imageIter).name(inx), ...
        imageNameList(imageIter).name));

    [imh, imw, ~] = size(rawImage);
    smaps = zeros(imh, imw, numSmapDirs);
    for segmentationIter = 1:numSmapDirs
      smaps(:, :, segmentationIter) = im2double(imread( ...
          fullfile( imageSaliencyMapDir, int2str(segmentationIter), imageNameList(imageIter).name )));
    end
    
    % weight and smap prediction using GMM
    imageFeatures = combinorGlobalFeatures(rawImage);
    clusterScores = posterior(GMModel, imageFeatures);
    clusterScores = clusterScores / sum(clusterScores);
    weights = zeros(1, numWeights);
    for clusIter = 1:numClusters
       weights = weights + clusterWeights(clusIter, :) * clusterScores(clusIter);
    end
    smap = combineSmapsWithWeights( weights, smaps );

    imwrite(smap, outputFile);
end
