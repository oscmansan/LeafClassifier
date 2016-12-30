close all;

K = 65;

I = imread('../data/leaf1/l1nr001.tif');
I = square(I);
I = imresize(I,[512 512]);
I = rgb2gray(I);
features = extractHOGFeatures(I,'CellSize',[K K]);
hogFeatureSize = length(features);


%% feature extraction

files = dir('../data/leaf*/*.tif');
n = length(files);

inputs = zeros(n,hogFeatureSize);
targets = zeros(n,1);

tic
for i=1:n
    folder = files(i).folder;
    fn = files(i).name;
    
    I = imread(strcat(folder,'/',fn));
    I = square(I);
    I = imresize(I,[512 512]);
    I = rgb2gray(I);
    
    [featureVector,hogVisualization] = extractHOGFeatures(I,'CellSize',[K K]);
    inputs(i,:) = featureVector;
    plot(hogVisualization); drawnow;
    
    class = int32(str2num(fn(2:end-9)));
    targets(i) = class;

    fprintf('Extracting features of %s\n',fn);
end
toc
close all;


%% k-fold cross-validation

k = 10;
fprintf('\nRunning %d-fold cross-validation...\n\n',k);

classifier = fitcecoc(inputs,targets);
options = statset('UseParallel',true);
model = crossval(classifier,'KFold', k,'options',options);

[labels, scores] = kfoldPredict(model);
confmat = confusionmat(targets,labels);
disp(confmat);

accuracy = 1 - kfoldLoss(model, 'LossFun', 'ClassifError');
fprintf('accuracy: %f\n\n',accuracy);


%% test

files = dir('../data/test/*.tif');
n = length(files);

truelabels = zeros(n,1);
classout = zeros(n,1);

for i=1:n
    folder = files(i).folder;
    fn = files(i).name;
    
    I = imread(strcat(folder,'/',fn));
    I = square(I);
    I = imresize(I,[512 512]);
    I = rgb2gray(I);

    featureVector = extractHOGFeatures(I,'CellSize',[K K]);
    classout(i) = predict(classifier,featureVector);
    
    truelabels(i) = int32(str2num(fn(2:end-9)));
    
    fprintf('Predicting class of %s\n',fn);
end

fprintf('\nValidation confusion matrix:\n\n');
cp = classperf(truelabels,classout);
disp(cp.CountingMatrix);
fprintf('accuracy: %f\n',cp.CorrectRate);