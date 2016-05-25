image_name = './drfi_code_cvpr2013/data/1_45_45397.png';
image = imread( image_name );

addpath(genpath('.'));

% parameters including the number of segmentations and saliency fusion
% weight
para = makeDefaultParameters();

imsegs = im2superpixels(image, 'pedro');
segimage = double(imsegs.segimage);
normalized = (segimage - min(segimage(:)))/(max(segimage(:)) - min(segimage(:)));
imshow(normalized);

pause

num_segmentation = para.num_segmentation;


% Weights used for saliency fusion
w = para.w;
ind = para.ind;

% Parameters for multiple segmentations
k = [5:5:35 40:10:120 150:30:600 660:60:1200 1300:100:1800];
k = k(ind(1 : num_segmentation));

[imh imw imc] = size(image);

gpb_file_name = [image_name(1:end-4), '.mat'];
gpb_data = load( gpb_file_name, 'textons' );
textons = gpb_data.textons;

    % Get proprocessed features, which will be used in the following feature extraction steps
    imdata = getImageData( image, textons, imsegs );
    spfeat = getSuperpixelData( imdata );

    % Generate the features to predict the similarity of two adjacent regions
    efeat = getEdgeData( spfeat, imdata );

    % predict the similarity of two adjacent regions
    same_label_likelihood = test_boosted_dt_mc( same_label_classifier, efeat );
    same_label_likelihood = 1 ./ (1+exp(ecal(1)*same_label_likelihood+ecal(2)));

    
nSuperpixel = imsegs.nseg;
multi_segmentations = mexMergeAdjRegs_Felzenszwalb( imdata.adjlist, same_label_likelihood, nSuperpixel, k, imsegs.npixels );


