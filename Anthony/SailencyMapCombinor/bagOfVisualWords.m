function [bag] = bagOfVisualWords()
    imgSet = getImageSetFromTextFile('train.txt', 'MSRA-B');
    bag = bagOfFeatures(imgSet,'Verbose',true)
%     save('BOW.mat', 'bag')

end