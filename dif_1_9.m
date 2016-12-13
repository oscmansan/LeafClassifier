f1 = dir('../data/leaf1/*.tif');
f9 = dir('../data/leaf9/*.tif');
files = [f1,f9]
n = length(f1);
textura = zeros(2,n);
h = fspecial('sobel');
d = strel('disk',20);
for i = 1:2
    for j = 1:n
        fn = files(j,i).name
        I = rgb2gray(imread(fn));
        bw = preprocess(I,512);
        bw = imerode(bw,d);
%         imshow(double(imfilter(I,h)),[]);
%         figure
        Isobel = double(imfilter(I,h)).*double(bw);
%         imshow(Isobel,[])
        textura(i,j) = sum(sum(bw))/sum(sum(Isobel));
    end
end