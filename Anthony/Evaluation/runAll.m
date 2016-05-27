inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
outputDir = 'KNNEvalOutputOldFeatures15Segments';
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutput');
outputDir = 'GMMEvalOutputOldFeatures15Segments';
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');


inputDir = fullfile('..', 'DRFI-Output');
outputDir = 'DRFIEvalOutput';
inputFileExtension = '.png';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'DRFI-UW-Output');
outputDir = 'DRFIWithUniformWeightsEvalOutput';
inputFileExtension = '.png';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');



