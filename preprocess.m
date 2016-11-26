function BW = preprocess(I, imsize)
    GS = rgb2gray(I);
    BW = GS < 200;
    BW = imfill(BW,'holes');
    BW = bwareaopen(BW,100);
    BW = centerobject(BW);
    BW = imresize(BW,[imsize imsize]);
end