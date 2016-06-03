inputDir = fullfile('..', 'SailencyMapCombinor', 'GMMOutputBOW');

fileExtension = '.jpg';
inputRegex = fullfile(inputDir, strcat('*', fileExtension))
imageNames = dir(inputRegex);
numImages = length(imageNames)

outputDir = 'GMM-BOW-Output';
mkdir(outputDir);

    parfor n=1:length(imageNames)
        imageNames(n).name
        outPath = fullfile(outputDir, imageNames(n).name);

        if exist(outPath, 'file')
           continue;
        end
        I = imread(fullfile(inputDir, imageNames(n).name));
        bnbFile (I,I,0,0,outPath);
    end
