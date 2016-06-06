outputDir = 'CombinedResults17SMapsFisher';
mkdir(outputDir);
prefix = 'Additional Saliency Maps ';
PRCurveName = [prefix, 'PR Curve'];
ROCCurveName = [prefix, 'ROC Curve'];
AUCPlotName = [prefix, 'AUC Comparison'];

% Note that I added the Train suffix to the inputDirs and outputDir

% update output dir as well
inputSuffix = '17SMapsFisher';
%inputDir = {'BenEvalOutput'};
%inputDir = {inputDir{:}, 'KaranEvalOutput'};
inputDir = {'DRFIEvalOutput'};
inputDir = {inputDir{:}, ['KNNEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['GMMEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['SoftClusterModelEvalOutput', inputSuffix]};
inputDir = {inputDir{:}, ['HardClusterModelEvalOutput', inputSuffix]};
inputNames = { 'DRFI', 'KNN', 'GMM', 'Soft', 'Hard' };

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

