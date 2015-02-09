data = load('digits.mat');

% scale vectors between 0 and 1
scaledData = data.data/255;
scaledData16 = reshape(scaledData,16,16,1100,10);

% compute variance for columns and rows and combine to a feature vector.
colVar = var(scaledData16);
rowVar = var(permute(scaledData16, [2,1,3,4]));
combinedVar = cat(2,rowVar,colVar);

% split combinedVar into training and testing data sets (indices).
randSplitSeq = randperm(size(combinedVar, 3));
splitSet = reshape(randSplitSeq, [], 1, 5);

randSplitOrigSeq = randperm(size(data.data,2));
splitSetOrig = reshape(randSplitOrigSeq, [],1,5);

% Arrays to hold correct predictions for each split.
numCorrect5 = [];
numCorrect8 = [];

numOrigCorrect5 = [];
numOrigCorrect8 = [];

for i = 1:5
   % Extract test data from combined variance set.
   testData = combinedVar(1, :,splitSet(:,1,i),:);
   testOrigData = data.data(:, splitSetOrig(:,1,i),:);
   
   % Extract indexes and data for training set from combined variance set.
   trainingIndices = setdiff((1:size(combinedVar,3)), splitSet(:,1,i));
   trainingData = combinedVar(1, :, trainingIndices,:);
   
   trainingOrigIndices = setdiff(1:size(data.data,2), splitSetOrig(:,1,i));
   trainingOrigData = data.data(:, trainingOrigIndices, :);
   
   % Compute mu5 (mean of variance for pictures with 5, class 1) 
   mu5 = mean(trainingData(1, :, :, 5),3);
   % Compute mu8 (mean of variance for pictures with 8, class 2)
   mu8 = mean(trainingData(1, :, :, 8),3);
   
   mu5Orig = mean(trainingOrigData(:,:,5),2);
   mu8Orig = mean(trainingOrigData(:,:,8),2);
   
   % Counters for correct predictions
   testCorrect5 = 0;
   testCorrect8 = 0;
   
   testOrigCorrect5 = 0;
   testOrigCorrect8 = 0;
   
   for j = 1:size(testData,3)
       % Run classifier for each test data.
       test5 = new_classifier(testData(1,:,j,5), mu5, mu8);
       test8 = new_classifier(testData(1,:,j,8), mu8, mu5);
       testOrig5 = new_classifier(testOrigData(:,j,5)', mu5Orig', mu8Orig');
       testOrig8 = new_classifier(testOrigData(:,j,8)', mu8Orig', mu5Orig');
       
       if test5 == 1
           testCorrect5 = testCorrect5 + 1;
       end
       if test8 == 1
           testCorrect8 = testCorrect8 + 1;
       end
       
       if testOrig5 == 1
           testOrigCorrect5 = testOrigCorrect5 + 1;
       end
       if testOrig8 == 1
           testOrigCorrect8 = testOrigCorrect8 + 1;
       end
   end
   numCorrect5 = [numCorrect5, testCorrect5];
   numCorrect8 = [numCorrect8, testCorrect8];
   numOrigCorrect5 = [numOrigCorrect5, testOrigCorrect5];
   numOrigCorrect8 = [numOrigCorrect8, testOrigCorrect8];
end
numCorrect5
numCorrect8
numOrigCorrect5
numOrigCorrect8
