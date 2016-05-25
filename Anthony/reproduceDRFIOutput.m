outputDir = fullfile('DRFI-Output');
mkdir(outputDir);

cd('drfi_code_cvpr2013');
para = makeDefaultParameters();
w = para.w;
cd('..')

imageSaliencyMapDir = fullfile('MSRA-B-SegmentationSaliencyMaps');

smapDirectories = dir(imageSaliencyMapDir);
% Remove '.' and '..'
ind = [];
for ix = 1 : length(smapDirectories)
    if strcmp(smapDirectories(ix).name, '.') || strcmp(smapDirectories(ix).name, '..') ...
            || strcmp(smapDirectories(ix).name, 'Progress.txt')
        ind = [ind ix];
        continue;
    end
end
smapDirectories(ind) = [];
numSmapDirs = length(smapDirectories);

imageNameList = dir(fullfile(imageSaliencyMapDir, '1', '*.jpg'));
numImages = length(imageNameList);

parfor imageIter = 1:numImages

    outputFile = fullfile(outputDir, imageNameList(imageIter).name);

    if exist(outputFile, 'file')
       continue;
    end

    temp_smap = imread(fullfile(imageSaliencyMapDir, '1', imageNameList(imageIter).name))
    temp_smap = im2double(temp_smap);
    smap = w(1) * exp( 1.5 * temp_smap );
    for segmentationIter = 2:numSmapDirs
      temp_smap = imread(fullfile(imageSaliencyMapDir, int2str(segmentationIter), imageNameList(imageIter).name));
      temp_smap = im2double(temp_smap);
      % saliency map fusion
      % a little bit tricky,
      % exp() is used to enhance the difference of the saliency between the object and the background
      smap = smap + w(segmentationIter) * exp( 1.5 * temp_smap );
      % smap = smap + w(s) * temp_smap;
    end


    smap = smap / num_segmentation;
    smap = (smap - min(smap(:))) / (max(smap(:)) - min(smap(:)) + eps) * 255;
    smap = uint8(smap);
    imwrite(smap, outputFile);
end
