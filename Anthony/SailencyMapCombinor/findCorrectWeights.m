function [ correctWeights ] = findCorrectWeights( gTruth, smaps )
% This code was adapted from LearnSaliencyFusionWeights

t = tic;

   % Resize images to induce blur
   resizeSize = [200, 200];
   gTruth = imresize(gTruth, resizeSize);
   [~, ~, num_segmentation] = size(smaps);
   oldSmaps = smaps;
   smaps = zeros([resizeSize, num_segmentation]);
   for i = 1:num_segmentation
      smaps(:, :, i) = imresize(oldSmaps(:, :, i), resizeSize);
   end
   
    H = zeros(num_segmentation, num_segmentation);
    f = zeros(num_segmentation, 1);
    
    for ii = 1 : num_segmentation * num_segmentation
        [ix, jx] = ind2sub([num_segmentation num_segmentation], ii);
        Ani = im2double(smaps(:, :, ix));
        Anj = im2double(smaps(:, :, jx));

        H(ix, jx) = H(ix, jx) + sum(sum(Ani .* Anj));
    end
    H = H * 2;
    
    gTruth = im2double(gTruth);
    for ix = 1 : num_segmentation   
        Ani = im2double(smaps(:, :, ix));
        A = gTruth;
        f(ix) = f(ix) - 2 * sum(sum(A .* Ani));
    end   
    
    w_init = ones(num_segmentation, 1) / num_segmentation;
    
    Aeq = ones(1, num_segmentation);
    beq = 1;
    
    lb = zeros(num_segmentation, 1);
    ub = ones(num_segmentation, 1);
    
    opt = optimset( 'Algorithm', 'active-set' );
    w = quadprog(H, f, [], [], Aeq, beq, lb, ub, w_init, opt );
    
    w( w < 1e-6 ) = 0;
    
    correctWeights = w;

    % A method I attempted
%     [~, ~, numSmapDirs] = size(smaps);
%     gTruth = im2double(gTruth);
%     errorFn = @(weights) weightsErrorFunction(weights, gTruth, smaps);
%     lb = zeros(numSmapDirs, 1);
%     ub = ones(numSmapDirs, 1);
%     Aeq = ones(1, numSmapDirs);
%     beq = 1;
%     fminconoptions = optimoptions('fmincon','Display','iter');
%     %psoptions = optimoptions('particleswarm','Display','iter', 'MaxIterations', 4);
%     correctWeights = ones(numSmapDirs, 1)/numSmapDirs;
% %     correctWeights = particleswarm(errorFn, numSmapDirs, lb, ub, psoptions);
%     correctWeights = fmincon(errorFn, correctWeights/sum(correctWeights), ...
%         [], [], Aeq, beq, lb, ub, [], fminconoptions);
%     correctWeights( correctWeights < 1e-6 ) = 0;
    
    
timeToSolveForWeights = toc(t)
    
    % debugging
%     correctWeights'
%     test = im2double(combineSmapsWithWeights(correctWeights, oldSmaps));
%     imshow(test);
%     figure();
%     imshow(gTruth);
%     pause


end

% function [ error ] = weightsErrorFunction( weights, gt, smaps )
%     smapSum = combineSmapsWithWeights(weights, smaps);
%     error = sum(sum(abs(gt - im2double(smapSum)).^2)); 
%     return;
%     % .^2 or abs? Do we want to penalize greater differences in saliecy
%     % AUC should be the error we minimize TODO
% 
% saliencyThresholds = linspace(0, 255, 20);
% 
% gt = logical(gt);
% [tp, fp, tn, fn] = imageStats(gt, smapSum, saliencyThresholds);
% 
% recall = tp ./ (tp + fn);
% falsePositiveRate = fp ./(tn + fp);
% 
% AUCScore = trapz(flipud(falsePositiveRate), flipud(recall));
% error = -AUCScore;
% 
% end

% groundTruth [input] the ground thruth saliency map - should be logical)
% testSMap [input] the saliency map being evaluated
% thresholdBoundaries [input] the thresholds at which to compute the
                        % true/false positive/negatives
% function [ truePositive, falsePositive, trueNegative, falseNegative] = imageStats(groundTruth, testSMap, thresholdBoundaries)
% 
% numThresholdVals = numel(thresholdBoundaries);
% truePositive = zeros(numThresholdVals, 1);
% falsePositive = zeros(numThresholdVals, 1);
% trueNegative = zeros(numThresholdVals, 1);
% falseNegative = zeros(numThresholdVals, 1);
% 
% for i = 1:numThresholdVals
%     binarySMap = testSMap > thresholdBoundaries(i);
%     truePositive(i) = sum(sum(binarySMap & groundTruth));
%     falsePositive(i) = sum(sum((binarySMap - groundTruth) > 0));
%     trueNegative(i) = sum(sum(~(binarySMap | groundTruth)));
%     falseNegative(i) = sum(sum((~binarySMap - ~groundTruth) > 0));
% end
% 
% end



