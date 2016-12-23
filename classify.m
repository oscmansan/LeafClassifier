close all;

K = 65;

I = imread('./subconjunt/l10nr006.tif');
I = imresize(I,0.25);
I = square(I);
I = imresize(I,[512 512]);
GS = rgb2gray(I);
features = extractHOGFeatures(GS,'CellSize',[K K]);
hogFeatureSize = length(features);

%% feature extraction

files = dir('../data/leaf*/*.tif');
n = length(files);

inputs = zeros(n,hogFeatureSize);
targets = zeros(n,1);

for i = 1:n
    folder = files(i).folder;
    fn = files(i).name;
    
    I = imread(strcat(folder,'/',fn));
    I = imresize(I,0.25);
    I = square(I);
    I = imresize(I,[512 512]);
    GS = rgb2gray(I);
    
    inputs(i,:) = extractHOGFeatures(GS,'CellSize',[K K]);
    
    class = int32(str2num(fn(2:end-9)));
    targets(i) = class;

    fprintf('Extracting features of %s\n',fn);
end


%% k-fold cross-validation

k = 10;
indices = crossvalind('Kfold',targets,k);

cp = classperf(targets);
for i = 1:k
    fprintf('fold %d\n',i);
    
    test = (indices == i); train = ~test;
    
    classifier = fitcecoc(inputs(train,:),targets(train,:)); % svm
    
    labels = predict(classifier,inputs(test,:));
    
    classperf(cp,labels,test);
end

disp(cp.CountingMatrix);
fprintf('accuracy: %f\n',cp.CorrectRate);