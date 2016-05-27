outputDir = 'CombinedResults';
mkdir(outputDir);
PRCurveName = 'PR Curve';
ROCCurveName = 'ROC Curve';

inputDir = {'DRFIEvalOutput'};
inputDir = {inputDir{:}, 'DRFIWithUniformWeightsEvalOutput'}
inputDir = {inputDir{:}, 'KNNEvalOutputOldFeatures15Segments'};
inputDir = {inputDir{:}, 'GMMEvalOutputOldFeatures15Segments'};
inputNames = {'DRFI', 'Uniform', 'KNN', 'GMM'};

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

legend(inputNames);
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
ylabel('AUC Score');
title('AUC Comparison');
aucScores = zeros(1, length(inputDir));
for i = 1:length(inputDir)
   fid = fopen(fullfile(inputDir{i}, 'AUCScore'));
   aucScores(i) = str2num(fgetl(fid));
   fclose(fid);
end
bar(aucScores);
set( gca, 'XTickLabels', inputNames);
ylim([0.9, 1.0]);
print(aucPlot, fullfile(outputDir, 'AUC Plot'), '-dpng')


