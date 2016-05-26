weightsOnly = false;
featuresOnly = false;

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

addpath(genpath('../Evalutation/')); % the function that computes the error needs this

featureCellArray = {numTrainingImage, 1};
correctWeightsCellArray = {numTrainingImage, 1};

parfor imageIter = 1:numTrainingImages
    % Load the image, smaps, and ground truth
    [~, imName, imExt] = fileparts(trainingImageNames{imageIter});
    inx = 1;
    if strcmp(imName(2), '0')
      inx = 1:2;
    end
    rawImage = imread(fullfile(rawImageDir, imName(inx), strcat(imName, '.jpg')));

    [imh, imw, ~] = size(rawImage);
    smaps = zeros(imh, imw, numSmapDirs);
    for smapDirIter = 1:numSmapDirs
        smaps(:, :, smapDirIter) = imread(fullfile(imageSaliencyMapDir, ...
            smapDirectories(smapDirIter).name, strcat(imName, '.jpg')));
    end
    gTruth = im2double(imread(fullfile(groundTruthDir, strcat(imName, '.png'))));
    gTruth = 255*gTruth;
    
    % Find the combination weights that minimize error
    if ~featuresOnly

    t = tic;
    errorFn = @(weights) weightsErrorFunction(weights, gTruth, smaps);
    lb = zeros(numSmapDirs, 1);
    ub = ones(numSmapDirs, 1);
    Aeq = ones(1, numSmapDirs);
    beq = 1;
    correctWeights = fmincon(errorFn, ones(numSmapDirs, 1)/numSmapDirs, ...
        [], [], Aeq, beq, lb, ub);
%     correctWeights = particleswarm(errorFn, numSmapDirs, lb, ub);
    correctWeights( correctWeights < 1e-6 ) = 0;
    timeToSolveForWeights = toc(t)
    
    correctWeightsCellArray{imageIter, 1} = correctWeights;
    
    end

    if ~weightsOnly
        % get features and put them in matricies
        featureCellArray{imageIter, 1} = CombinorGlobalFeatures(rawImage);
    end
end

featureMatrix = cell2mat(featureCellArray);
outputMatrix = cell2mat(correctWeightsCellArray);

if ~weightsOnly
	csvwrite('featureMatrix.csv', featureMatrix);
end
if ~featureOnly
	csvwrite('outputMatrix.csv', outputMatrix);
end
