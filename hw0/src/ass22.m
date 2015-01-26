% Robin Touche
% Homework 0 - Assignment 2.2

X = load('./dataset0.txt');

Xcov  = cov (X);
Xcorr = corr(X);

Tmp = bsxfun(@minus, X, min(X));
Y = bsxfun(@rdivide, Tmp, max(Tmp));

Ycov  = cov (Y);
Ycorr = corr(Y);

[x1, x2] = find(Ycorr == min(Ycorr(:)));
tmp = Y(:, x1);

scatter(tmp(:,2), tmp(:,1));
