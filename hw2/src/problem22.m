data1 = load('digits.mat');

% scale vectors between 0 and 1
scaledData = data1.data/255;
scaledData16 = reshape(scaledData,16,16,1100,10);

colVariance = var(scaledData16);
rowVariance = var(permute(scaledData16, [2,1,3,4]));


combinedVariance = cat(2,rowVariance,colVariance);
% split combinedVariance into training and testing data sets.
 randomSplitSeq = randperm(size(combinedVariance, 3));
 splitSet = reshape(randomSplitSeq, [], 1, 5);
 
 numCorrect5 = [];
 numCorrect8 = []; 
 for i = 1:5
    testData = combinedVariance(1, :,splitSet(:,1,i),:);
    trainingIndices = setdiff((1:size(combinedVariance,3)), splitSet(:,1,i));
    trainingData = combinedVariance(1, :, trainingIndices,:);
    mu5 = mean(trainingData(1, :, :, 5),3);
    mu8 = mean(trainingData(1, :, :, 8),3);
    
    % Test-loop, could be rebuild to use matrixoperations. Those changes
    % would take place in new_classifier (matrix-input support)
    testCorrect5 = 0;
    testCorrect8 = 0;
    for j = 1:size(testData,3)
        test5 = new_classifier(testData(1,:,i,5), mu5, mu8);
        test8 = new_classifier(testData(1,:,i,8), mu5, mu8);
        
        % Double-check that the return is 1 for prediction 5 and -1 for 8 
        % is actually correct.
        if test5 == 1
            testCorrect5 = testCorrect5 + 1;
        end
        if test8 == (-1)
            testCorrect8 = testCorrect8 + 1;
        end
    numCorrect5 = [numCorrect5 testCorrect5];
    numCorrect8 = [numCorrect8 testCorrect8];
    end
 end