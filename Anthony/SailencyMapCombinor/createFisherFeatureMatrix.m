% This file should use matlab 2016

rng(346374);

trainingImageList = fullfile('..', 'train.txt');
validationImageList = fullfile('..', 'valid.txt');
testImageList = fullfile('..', 'test.txt');

fid = fopen(trainingImageList);
trainingImageNames = textscan(fid, '%s\n');
trainingImageNames = trainingImageNames{1};
numTrainingImages = length(trainingImageNames);
fclose(fid);

rawImageDir = fullfile('..', 'MSRA-B');

featureCellArray = {numTrainingImages, 1};

run('vlfeat/toolbox/vl_setup');

load(fullfile('FisherModels', 'priors.mat'));
load(fullfile('FisherModels', 'means.mat'));
load(fullfile('FisherModels', 'covariances.mat'));

parfor imageIter = 1:numTrainingImages
    
    fprintf('Image Iteration %d\n', imageIter);

    % Load the image, smaps, and ground truth
    [~, imName, imExt] = fileparts(trainingImageNames{imageIter});
    inx = 1;
    if strcmp(imName(2), '0')
      inx = 1:2;
    end
    rawImageFile = fullfile(rawImageDir, imName(inx), strcat(imName, '.jpg'));

    featureCellArray{imageIter, 1} = getFisherEmbedding(rawImageFile, means, covariances, priors);
end

	[~, featureSize] = size(featureCellArray{1});
        featureMatrix = zeros(numTrainingImages, featureSize);
        for i = 1:numTrainingImages
	    featureMatrix(i, :) = featureCellArray{i};
        end
        % featureMatrix = cell2mat(featureCellArray); did not work
	csvwrite('featureMatrix.csv', featureMatrix);
