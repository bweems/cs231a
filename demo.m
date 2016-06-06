I = imread('leaf.png');
%S = SaliencyFast(I);
S = Saliency(I);
imshow(S, []);