%inputDir = fullfile('..', 'DRFI-Output-ECSSD');
%outputDir = 'DRFIEvalOutputECSSD';
inputDir = fullfile('..', 'SailencyMapCombinor', 'KNNOutputFisherECSSD');
outputDir = 'KNNEvalOutputNewFisherECSSD';
inputFileExtension = '.jpg';
produceEvaluationGraphs(fullfile('..', 'ECSSD-annot'), inputDir, inputFileExtension, fullfile('..', 'ECSSDFiles.txt'), outputDir, 'PR Curve', 'ROC Curve', 'AUCScore');




