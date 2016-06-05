outputDir = 'CombinedResultsDatasetComparison';
mkdir(outputDir);
prefix = 'Dataset ';
PRCurveName = [prefix, 'PR Curve'];
ROCCurveName = [prefix, 'ROC Curve'];
AUCPlotName = [prefix, 'AUC Comparison'];

% Note that I added the Train suffix to the inputDirs and outputDir

% update output dir as well
inputSuffix = 'NewFisher';
inputDir = {'DRFIEvalOutput'};
inputDir = {inputDir{:}, 'DRFIEvalOutputECSSD'};
inputDir = {inputDir{:}, ['KNNEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['KNNEvalOutput', inputSuffix, 'ECSSD']};
inputDir = {inputDir{:}, ['GMMEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['GMMEvalOutput', inputSuffix, 'ECSSD']};
inputDir = {inputDir{:}, ['SoftClusterModelEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['SoftClusterModelEvalOutput', inputSuffix, 'ECSSD']};
inputDir = {inputDir{:}, ['HardClusterModelEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['HardClusterModelEvalOutput', inputSuffix, 'ECSSD']};
inputNames = { 'DRFI-MSRA', 'DRFI-ECSSD', 'KNN-MSRA', 'KNN-ECSSD', ...
          'GMM-MSRA', 'GMM-ECSSD', 'Soft-MRSA', 'Soft-ECSSD', 'Hard-MRSA', 'Hard-ECSSD' };

prCurve = figure('visible','off');
ylabel('Precision');
xlabel('Recall');
title(PRCurveName);

hold on
for i = 1:length(inputDir)
   load(fullfile(inputDir{i}, 'evalMatrix.mat'));
   tp = dataMatrix(1, :);
   fp = dataMatrix(2, :);
   tn = dataMatrix(3, :);
   fn = dataMatrix(4, :);
   
   precision = tp ./ (tp + fp);
   recall = tp ./ (tp + fn);
   falsePositiveRate = fp ./(tn + fp);

   plot(recall, precision);
end

legend(inputNames, 'Location', 'SouthWest');
print(prCurve, fullfile(outputDir, PRCurveName),'-dpng')
hold off

rocCurve = figure('visible','off');
ylabel('True Positive Rate');
xlabel('False Positive Rate');
title(ROCCurveName);

hold on
for i = 1:length(inputDir)
   load(fullfile(inputDir{i}, 'evalMatrix.mat'));
   tp = dataMatrix(1, :);
   fp = dataMatrix(2, :);
   tn = dataMatrix(3, :);
   fn = dataMatrix(4, :);

   precision = tp ./ (tp + fp);
   recall = tp ./ (tp + fn);
   falsePositiveRate = fp ./(tn + fp);

   plot(falsePositiveRate, recall);
end

legend(inputNames);
print(rocCurve, fullfile(outputDir, ROCCurveName),'-dpng')
hold off

aucPlot = figure('visible', 'off');
aucScores = zeros(1, length(inputDir));
for i = 1:length(inputDir)
   fid = fopen(fullfile(inputDir{i}, 'AUCScore'));
   aucScores(i) = str2num(fgetl(fid));
   fclose(fid);
end
bar(aucScores);
set( gca, 'XTickLabels', inputNames);
% set(gca, 'XTickLabelRotation', 45);
ylim([0.9, 1.0]);
ylabel('AUC Score');
title(AUCPlotName);
print(aucPlot, fullfile(outputDir, AUCPlotName), '-dpng')

