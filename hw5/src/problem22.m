% 2.2
load('d2.mat');

% Compute the linear kernel weights for the data.
H = eye(3);
f = zeros(size(H,2),1);
b = -abs(Y);
A = -[diag(Y)*X Y];
lw = quadprog(H, f, A, b);
line = @(x1,x2) lw(1)*x1 + lw(2)*x2 + lw(3);

% Plot the linear kernel
figure(1);
e = ezplot(line, [-2.5 2.5 -2.5 2.5]);
set(e,'Color', 'black');
hold on

% Matrices for stroing data to plot.
xBelowC = [];
yBelowC = [];
xBelowW = [];
yBelowW = [];
xAboveC = [];
yAboveC = [];
xAboveW = [];
yAboveW = [];

margin = 1/sqrt(lw(1)^2 + lw(2)^2);
minAbove = 1000;
minBelow = 1000;

% Find support vectors and split points into correct set for plotting.
for i=1:size(Y,1)
    lineVal = line(X(i,1), X(i,2));
    xDist = abs(lw(1)*X(i,1) + lw(2)*X(i,2) + lw(3))/sqrt(lw(1)^2+lw(2)^2);
    xDist;
    if lineVal < 0
        if Y(i) == 1
            xBelowC = [xBelowC; X(i,:)];
            yBelowC = [yBelowC; Y(i)];
        else 
            xBelowW = [xBelowW; X(i,:)];
            yBelowW = [yBelowW; X(i,:)];
        end
        
        if xDist < minBelow
           minBelow = xDist;
           xSVBelow = X(i,:);
        end
    else
        if Y(i) == -1
            xAboveC = [xAboveC; X(i,:)];
            yAboveC = [yAboveC; Y(i)];
        else
            xAboveW = [xAboveW; X(i,:)];
            yAboveW = [yAboveW; Y(i)];
        end
        if xDist < minAbove
            minAbove = xDist;
            xSVAbove = X(i,:);
        end
    end
end

% Plot Correct and incorrect above and below the kernel line.
hold on
scatter(xBelowC(:,1), xBelowC(:,2), [], 'red', 'filled');
hold on
scatter(xBelowW(:,1), xBelowW(:,2), [], 'blue');
hold on
scatter(xAboveC(:,1), xAboveC(:,2), [], 'blue', 'filled');
hold on
scatter(xAboveW(:,1), xAboveW(:,2), [], 'red');
hold off

% Counters for cross-validation
lineQPT = 0;
lineSMOT = 0;
quadQPT = 0;
quadSMOT = 0;
rbfSMOT = 0;
rbfQPT = 0;
wLineQP = 0;
wLineSMO = 0;

% Cross-validation 5 random sets.
for i=1:5
    indices = randperm(size(Y,1));
    testIndices = indices(1:round(size(Y,1)/5));
    trainIndices = indices(round(size(Y,1)/5):end);
    
    xTrain = X(trainIndices, :);
    yTrain = Y(trainIndices, :);
    xTest = X(testIndices, :);
    yTest = Y(testIndices, :);


    tic
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'linear', 'method', 'QP');
    group = svmclassify(svmStruct, xTest);
    wLineQP = wLineQP + sum(not(group == yTest));
    lineQPT = toc + lineQPT;
    
    tic;
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'linear', 'method', 'SMO');
    group = svmclassify(svmStruct, xTest);
    wLineSMO = wLineSMO + sum(not(group == yTest));
    lineSMOT = toc + lineSMOT;


    tic;
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'quadratic', 'method', 'QP');
    group = svmclassify(svmStruct, xTest);
    sum(not(group == yTest));
    quadQPT =toc + quadQPT;
    
    
    tic;
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'quadratic', 'method', 'SMO');
    group = svmclassify(svmStruct, xTest);
    sum(not(group == yTest));
    quadSMOT = toc + quadSMOT;
    
    
    tic;
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'rbf', 'method', 'QP');
    group = svmclassify(svmStruct, xTest);
    sum(not(group == yTest));
    rbfQPT = toc + rbfQPT;
    
    
    tic;
    svmStruct = svmtrain(xTrain, yTrain, 'kernel_function', 'rbf', 'method', 'SMO');
    group = svmclassify(svmStruct, xTest);
    sum(not(group == yTest));
    rbfSMOT = toc + rbfSMOT;
    
end
% Incorrect class. % for linear kernel with opt. method QP
wLineQPproc = wLineQP / (size(yTest,1)*5) 
% Incorrect class. % for linear kernel with opt. method SMO
wLineSMOproc = wLineQP / (size(yTest,1)*5)
%Similar print can be done for all SVMs above.
