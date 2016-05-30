function [imgset] = getImageSetFromTextFile(file, MSRABRoot)

fid = fopen(file);
imageNames = textscan(fid, '%s\n');
imageNames = imageNames{1};
numImages = length(imageNames);
fclose(fid);

for i = 1:numImages
    [~, imName, imExt] = fileparts(imageNames{i});
    inx = 1;
    if strcmp(imName(2), '0')
      inx = 1:2;
    end
    imageNames{i} = fullfile(MSRABRoot, imName(inx), strcat(imName, '.jpg'));
end

imgset = imageSet(imageNames);

end
