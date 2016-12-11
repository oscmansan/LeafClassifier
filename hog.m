I = imread('./subconjunt/l10nr006.tif');
I = imresize(I,0.25);
BW = preprocess(I,512);
features = extractHOGFeatures(BW,'CellSize',[16 16]);
hogFeatureSize = length(features);


%% training

files = dir('../data/leaf*/*.tif');
n = length(files);

inputs = zeros(n,hogFeatureSize);
targets = zeros(n,1);

for i = 1:n
    folder = files(i).folder;
    fn = files(i).name;
    
    I = imread(strcat(folder,'/',fn));
    I = imresize(I,0.25);
    BW = preprocess(I,512);
    
    features = extractHOGFeatures(BW,'CellSize',[16 16]);
    inputs(i,:) = features;
    
    class = int32(str2num(fn(2:end-9)));
    targets(i) = class;

    fprintf('Extracting features of %s\n',fn);
end

classifier = fitcecoc(inputs,targets);


%% testing

files = dir('subconjunt/*.tif');
n = length(files);

testLabels = zeros(n,1);
predictedLabels = zeros(n,1);

for i = 1:n
    folder = files(i).folder;
    fn = files(i).name;
    
    I = imread(strcat(folder,'/',fn));
    I = imresize(I,0.25);
    BW = preprocess(I,512);
    
    features = extractHOGFeatures(BW,'CellSize',[16 16]);
    
    testLabels(i) = int32(str2num(fn(2:end-9)));
    predictedLabels(i) = predict(classifier,features);
end

confMat = confusionmat(testLabels, predictedLabels);
disp(confMat);