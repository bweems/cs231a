%inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
%outputDir = 'KNNOutput';
%inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
%outputDir = 'KNNEvalOutput';
inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutput');
outputDir = 'GMMEvalOutput';
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');
