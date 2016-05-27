function [] = produceEvaluationGraphs(groundTruthDir, evalDir, evalFileExtension, imageNamesListFilePath, outputDir, PRCurveName, ROCCurveName, AUCScoreName)
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

saliencyThresholds = [linspace(0, 255, 70), Inf];
truePositives = zeros(length(saliencyThresholds), 1);
falsePositives = zeros(length(saliencyThresholds), 1);
trueNegatives = zeros(length(saliencyThresholds), 1);
falseNegatives = zeros(length(saliencyThresholds), 1);

best = 0;
bestScore = -Inf;
worst = 0;
worstScore = Inf;

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
    score = max(score);

    if score > bestScore
	best = imageIter;
        bestScore = score;
    end
    if score < worstScore
	worst = imageIter;
        worstScore = score;
    end

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
fprintf(fid, '%8.3f\n', AUCScore);
fclose(fid);

dataMatrix = [truePositives'; falsePositives'; trueNegatives'; falseNegatives'; saliencyThresholds];
save(fullfile(outputDir, 'evalMatrix.mat'), 'dataMatrix');

fid = fopen(fullfile(outputDir, 'bestImage.txt'), 'w');
fprintf(fid, imageNames{best});
fclose(fid);

fid = fopen(fullfile(outputDir, 'worstImage.txt'), 'w');
fprintf(fid, imageNames{worst});
fclose(fid);


    [~, imName, imExt] = fileparts(imageNames{best});
    evalSMap = imread(fullfile(evalDir, strcat(imName, evalFileExtension)));

imwrite(evalSMap, fullfile(outputDir, 'best.png'));


    [~, imName, imExt] = fileparts(imageNames{worst});
    evalSMap = imread(fullfile(evalDir, strcat(imName, evalFileExtension)));

   imwrite(evalSMap, fullfile(outputDir, 'worst.png'));

end

