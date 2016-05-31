function [bag] = bagOfVisualWords()
    imgSet = getImageSetFromTextFile(fullfile('..', 'train.txt'), fullfile('..', 'MSRA-B'));
    % quick run imgSet = select(imgSet, 1:20);
    bag = bagOfFeatures(imgSet,'Verbose',true);
    save('BOW.mat', 'bag');

end
