imageNamesFile = fullfile('..', 'test.txt');
inputSuffix = '';
outputSuffix = '';

inputDir = fullfile('..', 'BoundingBoxes', strcat('BB-DRFI-Output', inputSuffix));
outputDir = strcat('BB-DRFIEvalOutput', outputSuffix);
inputFileExtension = '.png';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'BoundingBoxes', strcat('BB-GMM-Fisher-Output', inputSuffix));
outputDir = strcat('BB-GMMEvalOutputNewFisher', outputSuffix);
inputFileExtension = '.jpg';
%produceEvaluationGraphs('gtDir', inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

% ----------------------------- %

imageNamesFile = fullfile('..', 'ECSSDFiles.txt');


inputDir = fullfile('..', 'BoundingBoxes', strcat('BB-DRFI-Output-ECSSD', inputSuffix));
outputDir = strcat('BB-DRFIEvalOutputECSSD', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs(fullfile('..', 'ECSSD-annot'), inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');

inputDir = fullfile('..', 'BoundingBoxes', strcat('BB-GMM-Fisher-Output-ECSSD', inputSuffix));
outputDir = strcat('BB-GMMEvalOutputNewFisherECSSD', outputSuffix);
inputFileExtension = '.jpg';
produceEvaluationGraphs(fullfile('..', 'ECSSD-annot'), inputDir, inputFileExtension, imageNamesFile, outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');





