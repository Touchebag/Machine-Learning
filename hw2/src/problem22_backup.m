data = load('digits.mat');

% scale vectors between 0 and 1
scaledData = data.data/255;
scaledData16 = reshape(scaledData,16,16,1100,10);

% compute variance for columns and rows and combine to a feature vector.
colVariance = var(scaledData16);
rowVariance = var(permute(scaledData16, [2,1,3,4]));
combinedVariance = cat(2,rowVariance,colVariance);

% split combinedVariance into training and testing data sets (indices).
randomSplitSeq = randperm(size(combinedVariance, 3));
splitSet = reshape(randomSplitSeq, [], 1, 5);

randomSplitSeqOrig = randperm(size(data.data,2));
splitSetOrig = reshape(randomSplitSeqOrig, [],1,5);

% Arrays to hold correct predictions for each split.
numCorrect5 = [];
numCorrect8 = [];

numCorrectOrig5 = [];
numCorrectOrig8 = [];

for i = 1:5
   % Extract test data from combined variance set.
   testData = combinedVariance(1, :,splitSet(:,1,i),:);
   testDataOrig = data.data(:, splitSetOrig(:,1,i),:);
   
   % Extract indexes and data for training set from combined variance set.
   trainingIndices = setdiff((1:size(combinedVariance,3)), splitSet(:,1,i));
   trainingData = combinedVariance(1, :, trainingIndices,:);
   
   trainingIndicesOrig = setdiff(1:size(data.data,2), splitSetOrig(:,1,i));
   trainingDataOrig = data.data(:, trainingIndicesOrig, :);
   
   % Compute mu5 (mean of variance for pictures with 5, class 1) 
   mu5 = mean(trainingData(1, :, :, 5),3);
   % Compute mu8 (mean of variance for pictures with 8, class 2)
   mu8 = mean(trainingData(1, :, :, 8),3);
   
   mu5Orig = mean(trainingDataOrig(:,:,5),2);
   mu8Orig = mean(trainingDataOrig(:,:,8),2);
   
   % Counters for correct predictions
   testCorrect5 = 0;
   testCorrect8 = 0;
   
   testCorrect5Orig = 0;
   testCorrect8Orig = 0;
   
   for j = 1:size(testData,3)
       % Run classifier for each test data.
       test5 = new_classifier(testData(1,:,j,5), mu5, mu8);
       test8 = new_classifier(testData(1,:,j,8), mu8, mu5);
       test5Orig = new_classifier(testDataOrig(:,j,5)', mu5Orig', mu8Orig');
       test8Orig = new_classifier(testDataOrig(:,j,8)', mu8Orig', mu5Orig');
       
       if test5 == 1
           testCorrect5 = testCorrect5 + 1;
       end
       if test8 == 1
           testCorrect8 = testCorrect8 + 1;
       end
       
       if test5Orig == 1
           testCorrect5Orig = testCorrect5Orig + 1;
       end
       if test8Orig == 1
           testCorrect8Orig = testCorrect8Orig + 1;
       end
   end
   numCorrect5 = [numCorrect5, testCorrect5];
   numCorrect8 = [numCorrect8, testCorrect8];
   numCorrectOrig5 = [numCorrectOrig5, testCorrect5Orig];
   numCorrectOrig8 = [numCorrectOrig8, testCorrect8Orig];
end
numCorrect5
numCorrect8
numCorrectOrig5
numCorrectOrig8