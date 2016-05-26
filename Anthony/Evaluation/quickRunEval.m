inputDir = fullfile('..', 'DRFI-Output');
outputDir = 'EvalOutput';
produceEvaluationGraphs('gtDir', inputDir, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');
