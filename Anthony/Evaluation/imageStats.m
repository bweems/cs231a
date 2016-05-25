% groundTruth [input] the ground thruth saliency map - should be logical)
% testSMap [input] the saliency map being evaluated
% thresholdBoundaries [input] the thresholds at which to compute the
                        % true/false positive/negatives
function [ truePositive, falsePositive, trueNegative, falseNegative] = imageStats(groundTruth, testSMap, thresholdBoundaries)

numThresholdVals = numel(thresholdBoundaries);
truePositive = zeros(numThresholdVals, 1);
falsePositive = zeros(numThresholdVals, 1);
trueNegative = zeros(numThresholdVals, 1);
falseNegative = zeros(numThresholdVals, 1);

for i = 1:numThresholdVals
    binarySMap = testSMap > thresholdBoundaries(i);
    truePositive(i) = sum(sum(binarySMap & groundTruth));
    falsePositive(i) = sum(sum((binarySMap - groundTruth) > 0));
    trueNegative(i) = sum(sum(~(binarySMap | groundTruth)));
    falseNegative(i) = sum(sum((~binarySMap - ~groundTruth) > 0));
end

end

