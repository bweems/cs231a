outputDir = 'BB-GMM-Fisher-Output-ECSSD';
mkdir(outputDir);

 inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutputFisherECSSD');
% inputDir = fullfile('..', 'DRFI-Output-ECSSD');

fileExtension = '.jpg';
% inputRegex = fullfile(inputDir, strcat('*', fileExtension))
% imageNames = dir(inputRegex);
% numImages = length(imageNames)

%fid = fopen(fullfile('..', 'test.txt'));
fid = fopen(fullfile('..', 'ECSSDFiles.txt'));
imageNames = textscan(fid, '%s\n');
imageNames = imageNames{1};
numImages = length(imageNames);
fclose(fid);

    parfor n=1:length(imageNames)
        [~, name, ext] = fileparts(imageNames{n});
        fprintf('%s\n', name);
        outPath = fullfile(outputDir, strcat(name, fileExtension));

        if exist(outPath, 'file')
           continue;
        end
        I = imread(fullfile(inputDir, strcat(name, fileExtension)));
        bnbFile (I,I,0,0,outPath);
    end
