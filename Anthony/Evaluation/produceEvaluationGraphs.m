function [] = produceEvaluationGraphs(groundTruthDir, evalDir, outputDir, PRCurveName, ROCCurveName, AUCScoreName)
% Assumes the ground truths are binary (0 or 255)
% Assumes all saliency maps are noramlized to be in the range 0 to 255
% Assumes that each directory has .png files with matching names and these
% matching names indicate the predicted/groundtruth saliency maps of the
% same image

evalImageNames = dir(fullfile(evalDir, '*.png'));
mkdir(outputDir);

saliencyThresholds = linspace(0, 255, 20);
truePositives = zeros(length(saliencyThresholds), 1);
falsePositives = zeros(length(saliencyThresholds), 1);
trueNegatives = zeros(length(saliencyThresholds), 1);
falseNegatives = zeros(length(saliencyThresholds), 1);

for imageIter = 1:length(evalImageNames)
    evalSMap = imread(fullfile(evalDir, evalImageNames(imageIter).name));
    gtSMap = imread(fullfile(groundTruthDir, evalImageNames(imageIter).name));
    gtSMap = logical(gtSMap);
    [tp, fp, tn, fn] = imageStats(gtSMap, evalSMap, saliencyThresholds);
    truePositives = truePositives + tp;
    falsePositives = falsePositives + fp;
    trueNegatives = trueNegatives + tn;
    falseNegatives = falseNegatives + fn;
    imageIter
end

precision = truePositives ./ (truePositives + falsePositives);
recall = truePositives ./ (truePositives + falseNegatives);
falsePositiveRate = falsePositives ./(trueNegatives + falsePositives);

prCurve = figure('visible','off');
plot(recall, precision);
ylabel('Precision');
xlabel('Recall');
title(PRCurveName);
print(prCurve, fullfile(outputDir, PRCurveName),'-dpng')

rocCurve = figure('visible','off');
plot(falsePositiveRate, recall);
ylabel('True Positive Rate');
xlabel('False Positive Rate');
title(ROCCurveName);
print(rocCurve, fullfile(outputDir, ROCCurveName),'-dpng')

AUCScore = trapz(flipud(falsePositiveRate), flipud(recall));
fid = fopen(fullfile(outputDir, AUCScoreName), 'w');
fprintf(fid, '%8.3f', AUCScore);
fclose(fid);

dataMatrix = [truePositives; falsePositives; trueNegatives; falseNegatives; sailiencyThresholds];
save('evalMatrix.mat', 'dataMatrix');

end

