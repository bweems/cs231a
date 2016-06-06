% This is a copy of generateKNNSaliencyMaps except with the KNN parts
% switched for GMM parts

rawImageDir = fullfile('..', 'MSRA-B');
outputDir = fullfile('GMMOutputFisher17SMaps')
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

modelsDir = 'ClusterModels';
load(fullfile(modelsDir, 'GMModel.mat')); % 'BestModel'
GMModel = BestModel;
numClusters = GMModel.NumComponents;

% For 64 cluster version
% numClusters = 64;
% GMModel = fitgmdist(featureMatrix, numClusters, 'RegularizationValue' , 0.001);

clusterWeights = zeros(numClusters, numWeights);
clusterAssignments = cluster(GMModel, featureMatrix);
for i = 1:numClusters
    clusterWeights(i, :) = mean(correctWeightsMatrix(clusterAssignments == i, :));
end

%load('BOW.mat');
%featureParameters = bag;
run('vlfeat/toolbox/vl_setup');
load(fullfile('FisherModels', 'priors.mat'));
load(fullfile('FisherModels', 'means.mat'));
load(fullfile('FisherModels', 'covariances.mat'));

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
   
    rawImageFile = fullfile(rawImageDir, ...
        imageNameList(imageIter).name(inx), ...
        imageNameList(imageIter).name);

    rawImage = imread(rawImageFile);

    [imh, imw, ~] = size(rawImage);
    smaps = zeros(imh, imw, numSmapDirs);
    for segmentationIter = 1:numSmapDirs
      smaps(:, :, segmentationIter) = im2double(imread( ...
          fullfile( imageSaliencyMapDir, int2str(segmentationIter), imageNameList(imageIter).name )));
    end
    
    % weight and smap prediction using GMM
    % imageFeatures = combinorGlobalFeatures(rawImage, featureParameters);
    imageFeatures = getFisherEmbedding(rawImageFile, means, covariances, priors);
    clusterScores = posterior(GMModel, imageFeatures);
    clusterScores = clusterScores / sum(clusterScores);
    weights = zeros(1, numWeights);
    for clusIter = 1:numClusters
       weights = weights + clusterWeights(clusIter, :) * clusterScores(clusIter);
    end
    smap = combineSmapsWithWeights( weights, smaps );

    imwrite(smap, outputFile);
end
