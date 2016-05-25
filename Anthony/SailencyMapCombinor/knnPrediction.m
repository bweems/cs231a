function [smap] = knnPrediction(featureMatrix, correctWeightsMatrix, image, smaps, K)
% featureMatrix is the feature for each image in our training set, each row is one image's features
% correctWeightsMatrix [numImages x numWeights] are the correct weights for each image, images corresponding to the rows in
	% featureMatrix and correctWeightsMatrix should match
% smaps should be the saliency maps to combine with the weights

imageFeatures = CombinorGlobalFeatures(image);

indicies = knnsearch(featureMatrix, imageFeatures, 'K', K);
indicies = indicies';

weights = mean(correctWeightsMatrix(indicies, :));

smap = combineSmapsWithWeights(weights, smaps);

end
