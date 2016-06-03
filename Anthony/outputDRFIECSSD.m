cd('drfi_code_cvpr2013');

addpath(genpath('.'));
% load classifiers
% classifier for multiple segmentations
load('./trained_classifiers/same_label_classifier_200_20.mat');
classifiers.same_label_classifier = same_label_classifier;
classifiers.ecal = ecal;

% classifier for saliency regression
load( './trained_classifiers/segment_saliency_regressor_48_segmentations_MSRA_200_15_compressed_rf.mat' );
classifiers.segment_saliency_regressor = segment_saliency_regressor;

% parameters including the number of segmentations and saliency fusion
% weight
para = makeDefaultParameters();

outputDir = fullfile('..', 'DRFI-Output-ECSSD');
mkdir(outputDir);

rawImageDir = fullfile('..', 'ECSSD');

imageNames = dir(fullfile(rawImageDir, '*.jpg'));
numImages = length(imageNames);

parfor i=1:numImages
    fprintf('ImageIter %d\n', i);

    outputFile = fullfile(outputDir, imageNames(i).name);
    if exist(outputFile, 'file')
       continue;
    end

    image = imread(fullfile(rawImageDir, imageNames(i).name));
    imageSize = size(image);

    fprintf('Image Name: %s\n', imageNames(i).name);

    smap = Saliency_DRFI(image, classifiers, para, []);
    imwrite(smap, outputFile);
end

