%inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
%outputDir = 'KNNEvalOutputOldFeatures15Segments';
%inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutputBOW');
%outputDir = 'GMMEvalOutputOldFeatures15Segments';
%outputDir = 'GMMWithBOVW'
%inputDir = fullfile('..', 'DRFI-Output');
%outputDir = 'DRFIEvalOutput';
%inputDir = fullfile('..', 'DRFI-UW-Output');
%outputDir = 'DRFIWithUniformWeightsEvalOutput';
%inputFileExtension = '.png';
inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutputFisher');
outputDir = 'GMMEvalOutputNewFisher';
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, fullfile('..', 'test.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');
