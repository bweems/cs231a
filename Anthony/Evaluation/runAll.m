imageNamesFile = fullfile('..', 'test.txt');
outputSuffix = '';

inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutput');
outputDir = strcat('KNNEvalOutputOldFeatures15Segments', outputSuffix);
inputFileExtension = '.jpg';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutput');
outputDir = strcat('GMMEvalOutputOldFeatures15Segments', outputSuffix);
inputFileExtension = '.jpg';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', 'SoftClusterModelOutput');
outputDir = strcat('SoftClusterModelEvalOutputOldFeatures15Segments', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', 'HardClusterModelOutput');
outputDir = strcat('HardClusterModelEvalOutputOldFeatures15Segments', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');


inputDir = fullfile('..', 'DRFI-Output');
outputDir = strcat('DRFIEvalOutput', outputSuffix);
inputFileExtension = '.png';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'DRFI-UW-Output');
outputDir = strcat('DRFIWithUniformWeightsEvalOutput', outputSuffix);
inputFileExtension = '.png';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');



