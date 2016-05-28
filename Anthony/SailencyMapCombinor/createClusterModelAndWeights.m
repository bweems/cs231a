outputDir = 'ClusterModels';
mkdir(outputDir);

%% first generate the model we will use for clustering

featureMatrix = csvread('featureMatrix.csv');
correctWeightsMatrix = csvread('outputMatrix.csv');

rng(123573);
[numDataPoints, numWeights] = size(correctWeightsMatrix);

numClusterList = 6:20;
AIC = zeros(1,length(numClusterList));
GMModels = cell(1,length(numClusterList));
for i = 1:length(numClusterList)
    GMModels{i} = fitgmdist(featureMatrix,numClusterList(i),'RegularizationValue', 0.01);
    AIC(i)= GMModels{i}.AIC;
end

[minAIC,index] = min(AIC);

BestModel = GMModels{index};
numClusters = numClusterList(index);

save(fullfile(outputDir, 'GMModel.mat'), 'BestModel');

%% cluster each image
clusterAssignments = cluster(BestModel, featureMatrix);

% will be in same order as train.txt
% Also this should not be used but is saved here just in case the computation
% needs to be stopped and resumed later.
save(fullfile(outputDir, 'ClusterAssignments.mat'), 'clusterAssignments');

%% compute the weights to use for each cluster
trainingImageList = fullfile('..', 'train.txt');
fid = fopen(trainingImageList);
trainingImageNames = textscan(fid, '%s\n');
trainingImageNames = trainingImageNames{1};
numTrainingImages = length(trainingImageNames);
fclose(fid);

clusterWeights = zeros(numClusters, numWeights);

for clusterIter = 1:numClusters
    clusterImageNames = trainingImageNames(clusterAssignments == clusterIter);
    clusterWeights(i, :) = findCorrectWeightsForCluster(clusterImageNames)';
end

save(fullfile(outputDir, 'ClusterWeights.mat'), 'clusterWeights');
