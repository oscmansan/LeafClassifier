I = imread('../data/leaf1/l1nr050.tif');
GS = rgb2gray(I);
BW = GS < 180;
BW = imfill(BW,'holes');
BW = bwareaopen(BW,100);
BW = centerobject(BW);
figure; imshow(BW);