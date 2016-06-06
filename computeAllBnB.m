prefix2 = 'CroppedMaps/';

for i=0:9
    imageNames = dir(fullfile('Maps', int2str(i), '*.jpg'));
    
    parfor n=1:length(imageNames)
        imageNames(n).name
        I = imread(fullfile('Maps', int2str(i), imageNames(n).name));
        outPath = strcat(prefix2, strcat(num2str(i), strcat('/',imageNames(n).name)));
        bnbFile (I,I,0,0,outPath);
    end
end    