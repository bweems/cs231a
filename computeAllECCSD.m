prefix2 = 'ECCSDimagesMaps/';


% for i = 0:9
%     inputPath = strcat(prefix, strcat(num2str(i), suffix));
%     outPutPath = strcat(prefix2, strcat(num2str(i), suffix));
%     for file = files'
%         imgPath = strcat(prefix, strcat(num2str(i), strcat('/',file.name)))
%         outPath = strcat(prefix2, strcat(num2str(i), strcat('/',file.name)));
%         I = imread(imgPath);
%         n = size(I,1);
%         m = size(I,2);
%         S = Saliency(I,0);
%         S1 = imresize(S, [n m]);
%         imwrite(S1,outPath);
%         
%     end
% end

    imageNames = dir(fullfile('ECCSDimages', '*.jpg'));
    
    parfor n=1:length(imageNames)
        imageNames(n).name
        I = imread(fullfile('ECCSDimages', imageNames(n).name));
        outPath = strcat(prefix2, imageNames(n).name);
        n1 = size(I,1);
        m = size(I,2);
        S = Saliency(I,0);
        S1 = imresize(S, [n1 m]);
        imwrite(S1,outPath);
        % TODO
    end
    