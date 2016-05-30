% This file should use matlab 2016

rng(346374);

weightsOnly = false;
featuresOnly = true;

totalNumImages = 5000;
trainingImageList = fullfile('..', 'train.txt');
validationImageList = fullfile('..', 'valid.txt');
testImageList = fullfile('..', 'test.txt');

fid = fopen(trainingImageList);
trainingImageNames = textscan(fid, '%s\n');
trainingImageNames = trainingImageNames{1};
numTrainingImages = length(trainingImageNames);
fclose(fid);

rawImageDir = fullfile('..', 'MSRA-B');
imageSaliencyMapDir = fullfile('..', 'MSRA-B-SegmentationSaliencyMaps');
groundTruthDir = fullfile('..', 'MSRA-B-annot' ,'annotation');

% Note the raw images and smaps are in jpg format but annotations are png

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

load(fullfile('BOW.mat'));
featureExtractorParams = bag;

featureCellArray = {numTrainingImages, 1};
correctWeightsCellArray = {numTrainingImages, 1};

parfor imageIter = 1:numTrainingImages
    
    fprintf('Image Iteration %d\n', imageIter);

    % Load the image, smaps, and ground truth
    [~, imName, imExt] = fileparts(trainingImageNames{imageIter});
    inx = 1;
    if strcmp(imName(2), '0')
      inx = 1:2;
    end
    rawImage = imread(fullfile(rawImageDir, imName(inx), strcat(imName, '.jpg')));

    if ~featuresOnly

    [imh, imw, ~] = size(rawImage);
    smaps = zeros(imh, imw, numSmapDirs);
    for smapDirIter = 1:numSmapDirs
        smaps(:, :, smapDirIter) = imread(fullfile(imageSaliencyMapDir, ...
            smapDirectories(smapDirIter).name, strcat(imName, '.jpg')));
    end
    gTruth = imread(fullfile(groundTruthDir, strcat(imName, '.png')));
    
    % Find the combination weights that minimize error

    correctWeights = findCorrectWeights(gTruth, smaps);
    
    correctWeightsCellArray{imageIter, 1} = correctWeights';
    
    end

    if ~weightsOnly
        % get features and put them in matricies
        featureCellArray{imageIter, 1} = combinorGlobalFeatures(rawImage, featureExtractorParams);
    end
end

if ~weightsOnly
	[~, featureSize] = size(featureCellArray{1});
        featureMatrix = zeros(numTrainingImages, featureSize);
        for i = 1:numTrainingImages
	    featureMatrix(i, :) = featureCellArray{i};
        end
        % featureMatrix = cell2mat(featureCellArray); did not work
	csvwrite('featureMatrix.csv', featureMatrix);
end
if ~featuresOnly
        [~, numWeights] = size(correctWeightsCellArray{1});
        outputMatrix = zeros(numTrainingImages, numWeights);
        for i = 1:numTrainingImages
            outputMatrix(i, :) = correctWeightsCellArray{i};
        end
	% outputMatrix = cell2mat(correctWeightsCellArray); did not work
	csvwrite('outputMatrix.csv', outputMatrix);
end
