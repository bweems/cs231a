function [] = trainRegressors( featureMatrix, outputMatrix, outputDir )

[~, numRegressors] = size(outputMatrix);

addpath(genpath('../drfi_code_cvpr2013'));

for regressorIter = 1:numRegressors
    X = featureMatrix;
    Y = outputMatrix(:, regressorIter);
    mdl = regRF_train(X,Y);
    regDir = fullfile(outputDir, int2str(regressorIter));
    save(fullfile(regDir, 'regressorModel'), mdl);
end

end
