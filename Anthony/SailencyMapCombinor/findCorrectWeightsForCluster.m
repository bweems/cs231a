function [ weights ] = findCorrectWeightsForCluster( imageNameList )
%FINDCORRECTWEIGHTSFORCLUSTER Summary of this function goes here
%   Detailed explanation goes here

groundTruthDir = fullfile('..', 'MSRA-B-annot' ,'annotation');

imageSaliencyMapDir = fullfile('..', 'MSRA-B-SegmentationSaliencyMaps');
smapDirectories = dir(imageSaliencyMapDir);
% Remove '.' and '..'
ind = [];
for ix = 1 : length(smapDirectories)
    if strcmp(smapDirectories(ix).name, '.') || strcmp(smapDirectories(ix).name, '..') ...
            || strcmp(smapDirectories(ix).name, 'Progress.txt')
        ind = [ind ix];
        continue;
    end
end
smapDirectories(ind) = [];
num_segmentation = length(smapDirectories);

numImages = length(imageNameList);

resizeSize = [200, 200];

% Create and solve optimization problem

    H = zeros(num_segmentation, num_segmentation);
    f = zeros(num_segmentation, 1);
    
    for ii = 1 : num_segmentation * num_segmentation
        [ix, jx] = ind2sub([num_segmentation num_segmentation], ii);
        for n = 1 : numImages
            [~, imName, ~] = fileparts(imageNameList{n});
            imName = strcat(imName, '.jpg');
            Ani = imread(fullfile(imageSaliencyMapDir, smapDirectories(ix).name, imName));
            Anj = imread(fullfile(imageSaliencyMapDir, smapDirectories(jx).name, imName));
            Ani = im2double(imresize(Ani, resizeSize));
            Anj = im2double(imresize(Anj, resizeSize));

            H(ix, jx) = H(ix, jx) + sum(sum(Ani .* Anj));
        end
        fprintf( 'Computing H, ix: %d, jx: %d\n', ix, jx );
    end
    H = H * 2;

    for ix = 1 : num_segmentation   
        for n = 1 : numImages
            [~, imName, ~] = fileparts(imageNameList{n});
            Ani = imread(fullfile( imageSaliencyMapDir, smapDirectories(ix).name, strcat(imName, '.jpg') ));
            Ani = im2double(imresize(Ani, resizeSize));
            A = imread(fullfile(groundTruthDir, strcat(imName, '.png')));
            A = im2double(imresize(A, resizeSize));
            
            
            f(ix) = f(ix) - 2 * sum(sum(A .* Ani));
        end     
        
        fprintf( 'comupting f, ix: %d\n', ix );
    end   
    
    H = H / numImages;
    f = f / numImages;
    
    % Solve the quadratic programming problem
    w_init = ones(num_segmentation, 1) / num_segmentation;
    
    Aeq = ones(1, num_segmentation);
    beq = 1;
    
    lb = zeros(num_segmentation, 1);
    ub = ones(num_segmentation, 1);
    
    opt = optimset( 'Algorithm', 'active-set' );
    weights = quadprog(H, f, [], [], Aeq, beq, lb, ub, w_init, opt );
    
    weights( weights < 1e-6 ) = 0;

end

