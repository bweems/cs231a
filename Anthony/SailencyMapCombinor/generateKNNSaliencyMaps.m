rawImageDir = fullfile('..', 'MSRA-B');
outputDir = fullfile('KNNOutput');
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

K = 20;

for imageIter = 1:numImages

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
          fullfile(imageSaliencyMapDir, int2str(segmentationIter), ...
          imageNameList(imageIter).name)));
    end
    
    smap = knnPrediction(featureMatrix, correctWeightsMatrix, rawImage, smaps, K);

    imwrite(smap, outputFile);
end
