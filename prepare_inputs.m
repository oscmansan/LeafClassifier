files = dir('subconjunt');
n = length(files)-2;

imsize = 512;

inputs = zeros(imsize^2,n);
targets = zeros(15,n);

for i = 1:n
    fn = files(i+2).name;
    
    I = imread(fn);
    BW = preprocess(I,imsize);
    inputs(:,i) = BW(:);
    
    class = int32(str2num(fn(2:end-9)));
    targets(class,i) = 1;
    
    imshow(BW);
end