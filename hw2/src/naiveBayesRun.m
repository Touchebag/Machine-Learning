data = load('dataset2.mat');

% call to classify xnew in class 1 or 2.
xnew = [1, 0.8, 1.1];
[P1, P2, Ylabel] = sph_bayes(xnew, data);

% Get the means.
mu1 = mean(data.x(data.y == 1, :));
mu2 = mean(data.x(data.y == -1, :));
[Ylabel2] = new_classifier(xnew, mu1, mu2 );

%TODO: Make 5-fold cross-validation for both classifiers.
numPoints = size(data.y,1);

seq = randperm(numPoints)';

splitSet = reshape(seq, [], 1, 5);

%setdiff(A,B) returns the data in A that is not in B.

%Loop over each set in splitSet as the test set
numWrong = 0;
for i = 1:5
   testData = data.x(splitSet(:,1,i),:);
   testLabels = data.y(splitSet(:,1,i));
   
   trainingIndices = setdiff(seq, splitSet(:,1,i));
   trainingData = data.x(trainingIndices,:);
   trainingLabels = data.y(trainingIndices);
   %implement for new_classifier
   trainingParam.x = trainingData;
   trainingParam.y = trainingLabels;
   for j = 1:size(testData,1)
       [P1, P2, Ylabel] = sph_bayes(testData(j,:),trainingParam);
       % do this for new_classifier as well.
       if Ylabel ~=  testLabels(j)
           numWrong = numWrong + 1;
       end
   end
   
   %check how many was wrong
   %sum all wrong predictions.
   % divide by 5*400
end