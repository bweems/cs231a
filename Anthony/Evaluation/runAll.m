imageNamesFile = fullfile('..', 'test.txt');
inputSuffix = 'Fisher';
outputSuffix = 'NewFisher';

inputDir = fullfile('..', 'SailencyMapCombinor', strcat('KNNOutput', inputSuffix));
outputDir = strcat('KNNEvalOutput', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', strcat('GMMOutput', inputSuffix));
outputDir = strcat('GMMEvalOutput', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', strcat('SoftClusterModelOutput', inputSuffix));
outputDir = strcat('SoftClusterModelEvalOutput', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'SailencyMapCombinor', strcat('HardClusterModelOutput', inputSuffix));
outputDir = strcat('HardClusterModelEvalOutput', outputSuffix);
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



