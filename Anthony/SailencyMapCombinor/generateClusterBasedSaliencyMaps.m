% This is a copy of generateKNNSaliencyMaps except with the KNN parts
% switched for GMM parts

rawImageDir = fullfile('..', 'MSRA-B');

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

modelsDir = 'ClusterModels';
load(fullfile(modelsDir, 'GMModel.mat')); % 'BestModel'
load(fullfile(modelsDir, 'ClusterWeights.mat')); %'clusterWeights');
[numClusters, numWeights] = size(clusterWeights);

imageNameList = dir(fullfile(imageSaliencyMapDir, '1', '*.jpg'));
numImages = length(imageNameList);

softOutputDir = fullfile('SoftClusterModelOutputFisher17SMaps');
mkdir(softOutputDir);
hardOutputDir = fullfile('HardClusterModelOutputFisher17SMaps');
mkdir(hardOutputDir);

%load('BOW.mat');
%featureParameters = bag;
run('vlfeat/toolbox/vl_setup');
load(fullfile('FisherModels', 'priors.mat'));
load(fullfile('FisherModels', 'means.mat'));
load(fullfile('FisherModels', 'covariances.mat'));

parfor imageIter = 1:numImages
    softOutputFile = fullfile(softOutputDir, imageNameList(imageIter).name);

    if exist(softOutputFile, 'file')
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
          fullfile( imageSaliencyMapDir, smapDirectories(segmentationIter).name, imageNameList(imageIter).name )));
    end
    
    % weight and smap prediction using GMM
    % imageFeatures = combinorGlobalFeatures(rawImage, featureParameters);
    imageFeatures = getFisherEmbedding(rawImageFile, means, covariances, priors);
    clusterScores = posterior(BestModel, imageFeatures);
    clusterScores = clusterScores / sum(clusterScores);
    weights = zeros(1, numWeights);
    for clusIter = 1:numClusters
       weights = weights + clusterWeights(clusIter, :) * clusterScores(clusIter);
    end
    smap = combineSmapsWithWeights( weights, smaps );

    imwrite(smap, softOutputFile);
    
    
    hardOutputFile = fullfile(hardOutputDir, imageNameList(imageIter).name);
    
    clusterIndex = cluster(BestModel, imageFeatures);
    smap = combineSmapsWithWeights( clusterWeights(clusterIndex, :), smaps );

    imwrite(smap, hardOutputFile);
end
