function [imageNames, scores] = findImagesToDisplay(groundTruthDir, evalDir, evalFileExtension, imageNamesListFilePath, outputDir, PRCurveName, ROCCurveName, AUCScoreName)
% Assumes the ground truths are binary (0 or 255)
% Assumes all saliency maps are noramlized to be in the range 0 to 255
% Assumes that each directory has .png files with matching names and these
% matching names indicate the predicted/groundtruth saliency maps of the
% same image

fid = fopen(imageNamesListFilePath);
imageNames = textscan(fid, '%s\n');
imageNames = imageNames{1};
numImages = length(imageNames);
fclose(fid);

mkdir(outputDir);

saliencyThresholds = [-Inf, linspace(0, 255, 70), Inf];
truePositives = zeros(length(saliencyThresholds), 1);
falsePositives = zeros(length(saliencyThresholds), 1);
trueNegatives = zeros(length(saliencyThresholds), 1);
falseNegatives = zeros(length(saliencyThresholds), 1);

scores= zeros(numImages, 1);

for imageIter = 1:numImages
    [~, imName, imExt] = fileparts(imageNames{imageIter});
    evalSMap = imread(fullfile(evalDir, strcat(imName, evalFileExtension)));
    gtSMap = imread(fullfile(groundTruthDir, strcat(imName, '.png')));
    gtSMap = logical(gtSMap);
    [tp, fp, tn, fn] = imageStats(gtSMap, evalSMap, saliencyThresholds);
    truePositives = truePositives + tp;
    falsePositives = falsePositives + fp;
    trueNegatives = trueNegatives + tn;
    falseNegatives = falseNegatives + fn;

    score = (tp + tn) ./ (tp + fp + tn + fn);

    evalSMap = imread(fullfile('..', 'DRFI-Output', strcat(imName, '.png')));
    gtSMap = imread(fullfile(groundTruthDir, strcat(imName, '.png')));
    gtSMap = logical(gtSMap);
    [tp, fp, tn, fn] = imageStats(gtSMap, evalSMap, saliencyThresholds);
    truePositives = truePositives + tp;
    falsePositives = falsePositives + fp;
    trueNegatives = trueNegatives + tn;
    falseNegatives = falseNegatives + fn;

    score = score - ((tp + tn) ./ (tp + fp + tn + fn));


    scores(imageIter, 1) = mean(mean(score));

end

end

