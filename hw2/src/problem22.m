data1 = load('digits.mat');

% scale vectors between 0 and 1
scaledData = data1.data/255;
scaledData16 = reshape(scaledData,16,16,1100,10);

% compute variance for columns and rows and combine to a feature vector.
colVariance = var(scaledData16);
rowVariance = var(permute(scaledData16, [2,1,3,4]));
combinedVariance = cat(2,rowVariance,colVariance);

% split combinedVariance into training and testing data sets (indices).
randomSplitSeq = randperm(size(combinedVariance, 3));
splitSet = reshape(randomSplitSeq, [], 1, 5);

% Arrays to hold correct predictions for each split.
numCorrect5 = [];
numCorrect8 = [];

for i = 1:5
   % Extract test data from combined variance set.
   testData = combinedVariance(1, :,splitSet(:,1,i),:);
   % Extract indexes and data for training set from combined variance set.
   trainingIndices = setdiff((1:size(combinedVariance,3)), splitSet(:,1,i));
   trainingData = combinedVariance(1, :, trainingIndices,:);
   
   % Compute mu5 (mean of variance for pictures with 5, class 1) 
   mu5 = mean(trainingData(1, :, :, 5),3);
   % Compute mu8 (mean of variance for pictures with 8, class 2)
   mu8 = mean(trainingData(1, :, :, 8),3);
   
   % Counters for correct predictions
   testCorrect5 = 0;
   testCorrect8 = 0;
   for j = 1:size(testData,3)
       % Run classifier for each test data.
       test5 = new_classifier(testData(1,:,j,5), mu5, mu8);
       test8 = new_classifier(testData(1,:,j,8), mu8, mu5);
       
       if test5 == 1
           testCorrect5 = testCorrect5 + 1;
       end
       if test8 == 1
           testCorrect8 = testCorrect8 + 1;
       end
   end
   % Add number of correct predictions to corresponding counter array
   numCorrect5 = [numCorrect5, testCorrect5];
   numCorrect8 = [numCorrect8, testCorrect8];
end
numCorrect5
numCorrect8