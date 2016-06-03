%Much of this was copied from Saliency_DRFI.m and demo.m

addpath(genpath('drfi_code_cvpr2013'));

cd('drfi_code_cvpr2013');

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

cd('..');

outputDir = 'ECSSD-SegmentationSaliencyMaps';
mkdir(outputDir);
for i=1:para.num_segmentation
   mkdir(fullfile(outputDir,  int2str(i)));
end

numSeg = para.num_segmentation;
    imageNames = dir(fullfile('ECSSD', '*.jpg'));
    parfor n=1:length(imageNames)
        fprintf('ImageIteration %d\n', n);
        image = imread(fullfile('ECSSD', imageNames(n).name));
        exists = true;
        for j=1:numSeg
            exists = exists && exist(fullfile(outputDir, int2str(j), imageNames(n).name), 'file');
        end
        if ~exists
            generateSegSMaps( image, classifiers, para, [], outputDir, imageNames(n).name);
        end
    end
