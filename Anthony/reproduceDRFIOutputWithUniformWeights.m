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
% % % Set weights to uniform % % %
numWeights = length(para.w);
para.w = ones(1, numWeights)/numWeights;

outputDir = fullfile('..', 'DRFI-UW-Output');
mkdir(outputDir);

fid = fopen(fullfile('..', 'test.txt'));
imageNames = textscan(fid, '%s\n');
imageNames = imageNames{1};
numImages = length(imageNames);
fclose(fid);

rawImageDir = fullfile('..', 'MSRA-B');

parfor i=1:numImages
    fprintf('ImageIter %d\n', i);

    outputFile = fullfile(outputDir, imageNames{i});
    if exist(outputFile, 'file')
       continue;
    end

    [~, imName, imExt] = fileparts(imageNames{i});
    inx = 1;
    if strcmp(imName(2), '0')
      inx = 1:2;
    end
    image = imread(fullfile(rawImageDir, imName(inx), strcat(imName, '.jpg')));
    
    smap = Saliency_DRFI(image, classifiers, para, []);
    imwrite(smap, outputFile);
end

