function BW = preprocess(I, imsize)
    addpath('centerobject/');
    GS = rgb2gray(I);
    BW = GS < 200;
    BW = imfill(BW,'holes');
    BW = bwareaopen(BW,2000);
    BW = centerobject(BW);
    BW = imresize(BW,[imsize imsize]);
end