imageNamesFile = fullfile('..', 'test.txt');
inputSuffix = 'Fisher17SMaps';
outputSuffix = '17SMapsFisher';

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



