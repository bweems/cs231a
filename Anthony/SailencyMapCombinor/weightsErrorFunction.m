function [ error ] = weightsErrorFunction( weights, gt, smaps )
    smapSum = combineSmapsWithWeights(weights, smaps);
    error = sum(sum(abs(gt - smapSum))); 
    % .^2 or abs? Do we want to penalize greater differences in saliecy
end

