data = load('dataset2.mat');

% call to classify xnew in class 1 or 2.
%xnew = [1, 0.8, 1.1];
%[P1, P2, Ylabel] = sph_bayes(xnew, data);
% Get the means.
%mu1 = mean(data.x(data.y == 1, :));
%mu2 = mean(data.x(data.y == -1, :));
%[Ylabel2] = new_classifier(xnew, mu1, mu2 );


% Get number of observations in data set.
numPoints = size(data.y,1);
% Randomize the index sequence of the data.
seq = randperm(numPoints)';
% split sequence into 5-fold crossvalidation sets.
splitSet = reshape(seq, [], 1, 5);


% Set counters for the number of errors for the crossvalidation tests.
numWrongSph = 0;
numWrongNew = 0;

% 5-fold crossvalidation. Each loop-iteration takes a new split of the data
% set as the test set and use the other 4 data sets as training for the two
% classifier functions.
for i = 1:5
   % Extract current iterations test data and labels.
   testData = data.x(splitSet(:,1,i),:);
   testLabels = data.y(splitSet(:,1,i));
   
   % Get indices for training data and labels.
   trainingIndices = setdiff(seq, splitSet(:,1,i));
   trainingData = data.x(trainingIndices,:);
   trainingLabels = data.y(trainingIndices);
   
   % Make input parameter of training data and labels for sph_bayes. 
   trainingParam.x = trainingData;
   trainingParam.y = trainingLabels;
   
   % Compute mu1 and mu2 of training data and labels for new_classifier.
   trainingMu1 = mean(trainingData(trainingLabels == 1, :));
   trainingMu2 = mean(trainingData(trainingLabels == -1, :));
   
   % test each observation from current test set and match against actual
   % label to meassure performance.
   for j = 1:size(testData,1)
       
       % Run classifiers for current test observation.
       [P1, P2, Ylabel] = sph_bayes(testData(j,:),trainingParam);
       [Ylabel2] = new_classifier(testData(j,:), trainingMu1, trainingMu2);
       
       % If sph_bayes classified wrong, increase fail counter.
       if Ylabel ~=  testLabels(j)
           numWrongSph = numWrongSph + 1;
       end
       
       % If new_classifier classified wrong, increase fail counter.
       if Ylabel2 ~= testLabels(j)
           numWrongNew = numWrongNew + 1;
       end
   end
end