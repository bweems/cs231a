%inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
%outputDir = 'KNNEvalOutputOldFeatures15Segments';
inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutput');
outputDir = 'GMMEvalOutputOldFeatures15Segments';
%inputDir = fullfile('..', 'DRFI-Output');
%outputDir = 'DRFIEvalOutputOldFeatures15Segments';
%inputFileExtension = '.png';
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');
