% Naive bayes classifier
function [P1, P2, Ytest]=sph_bayes(Xtest, data)

% Get positions in test data with label 1
posData = data.y == 1;

% Get x-vectors with label 1
xVals1 = data.x(posData, :);
mu1 = mean(xVals1);
sigma1 = sqrt(var(xVals1));

% Get x-vectors with label -1
xVals2 = data.x(not(posData), :);
mu2 = mean(xVals2);
sigma2 = sqrt(var(xVals2));

% Likelihood for class 1 & 2
like1 = prod(normpdf(Xtest, mu1, sigma1));
like2 = prod(normpdf(Xtest, mu2, sigma2));

% Calculate probability for class 1 and 2. Classify xnew with label.
P1 = like1 / (like1 + like2);
P2 = like2 / (like2 + like1);
Ytest = (-1)^(P1 < P2);
end
