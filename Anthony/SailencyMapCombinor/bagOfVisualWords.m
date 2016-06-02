function [bag] = bagOfVisualWords()
    imgSet = getImageSetFromTextFile('train.txt', 'MSRA-B');
    set1 = partition(imgSet, 1000);
    bag = bagOfFeatures(set1,'Verbose',true)
    save('BOW.mat', 'bag')

end