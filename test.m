files = dir('../data/leaf*/*.tif');

n = length(files);

imsize = 512;

Props = {'Area','Perimeter','Eccentricity','Solidity'};
nprops = length(Props)-1;
inputs = zeros(n,nprops);
targets = zeros(n,1);

for i = 1:n
    fn = files(i+2).name;
    
    I = imread(fn);
    BW = preprocess(I,imsize);
    T = struct2table(regionprops(BW,Props));
    [M, I] = max(T.Area);
    Area = T.Area(I);
    Perimeter = T.Perimeter(I);
    Eccentricity = T.Eccentricity(I);
    Solidity = T.Solidity(I);    
    
    Compactness = (4*pi) / (Perimeter^2 / Area);
    inputs(i,:) = [Compactness;Eccentricity;Solidity];
    
    class = int32(str2num(fn(2:end-9)));
    targets(i) = class;
    
    BW = bwmorph(BW,'remove');
    imshow(BW);
end

[labels,scores] = predict(classifier,inputs);

labels = cellfun(@str2num,labels);
disp(sum(labels ~= targets));