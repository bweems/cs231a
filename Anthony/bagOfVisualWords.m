function [bag] = bagOfVisualWords(img)
    setDir  = fullfile('MSRA-B');
    imgSets = imageSet(setDir, 'recursive')
    trainingSets = partition(imgSets, 2);
    bag = bagOfFeatures(trainingSets,'Verbose',true);
    img = imread(img);
    featureVector = encode(bag, img)
end

