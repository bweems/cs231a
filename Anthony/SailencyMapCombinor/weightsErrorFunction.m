function [ error ] = weightsErrorFunction( weights, gt, smaps )
    smapSum = combineSmapsWithWeights(weights, smaps);
    % error = sum(sum(abs(gt - smapSum))); 
    % .^2 or abs? Do we want to penalize greater differences in saliecy
    % AUC should be the error we minimize TODO

saliencyThresholds = linspace(0, 255, 20);

gt = logical(gt);
[tp, fp, tn, fn] = imageStats(gt, smapSum, saliencyThresholds);

recall = tp ./ (tp + fn);
falsePositiveRate = fp ./(tn + fp);

AUCScore = trapz(flipud(falsePositiveRate), flipud(recall));
error = -AUCScore;

end

