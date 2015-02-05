data = load('dataset2.mat');

% call to classify xnew in class 1 or 2.
xnew = [1, 0.8, 1.1];
[P1, P2, Ylabel] = sph_bayes(xnew, data)

% Get the means.
mu1 = mean(data.x(data.y == 1, :));
mu2 = mean(data.x(data.y == -1, :));
[Ylabel2] = new_classifier(xnew, mu1, mu2 );

%TODO: Make 5-fold cross-validation for both classifiers.