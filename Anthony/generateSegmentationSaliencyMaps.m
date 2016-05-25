%Much of this was copied from Saliency_DRFI.m and demo.m
addpath(genpath('.'));

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

outputDir = 'MSRA-B-SegmentationSaliencyMaps';
mkdir(outputDir);
for i=1:para.num_segmentation
   mkdir(fullfile(outputDir,  int2str(i)));
end

progressFile = fullfile(outputDir, 'Progress.txt');

numSeg = para.num_segmentation;
for i=0:9
    if exist(progressFile, 'file')
       fid = fopen(progressFile, 'r');
       lastDir = fgetl(fid);
       fclose(fid);
       if i <= str2num(lastDir)
           continue;
       end
    end
    imageNames = dir(fullfile('MSRA-B', int2str(i), '*.jpg'));
    numExisted = 0;
    parfor n=1:length(imageNames)
        image = imread(fullfile('MSRA-B', int2str(i), imageNames(n).name));
        exists = true;
        for j=1:numSeg
            exists = exists && exist(fullfile(outputDir, int2str(j), imageNames(n).name), 'file');
        end
        if exists
            numExisted = numExisted + 1;
        end
        if ~exists
            generateSegSMaps( image, classifiers, para, [], outputDir, imageNames(n).name);
        end  
        fprintf('ImageIteration %d\n', n);
    end
	numExisted
    dirInMSRAB = i
    fid = fopen(progressFile, 'w');
    fprintf(fid, '%d', i);
    fclose(fid);
end
