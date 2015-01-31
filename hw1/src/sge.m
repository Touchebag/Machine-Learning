% Robin Touche
% Homework 1 - Assignment 2.1

function [mu, sigma] = sge(x)
%
% SGE Mean and variance estimator for spherical Gaussian distribution
%
% x     : Data matrix of size n x p where each row represents a
%         p-dimensional data point e.g.
%            x = [2 1;
%                 3 7;
%                 4 5 ] is a dataset having 3 samples each
%                 having two co-ordinates.
%
% mu    : Estimated mean of the dataset [mu_1 mu_2 ... mu_p]
% sigma : Estimated standard deviation of the dataset (number)
%
  numPoints = size(x, 1);

  mu = (1 / numPoints) * sum(x, 1);

  sdFunc = @(y) (y - mu) * (y - mu)';
  sdTemp = zeros(numPoints, 1);

  for i = 1:numPoints
    sdTemp(i) = sdFunc(x(i, :));
  end

  sigma = (1 / numPoints) * sum(sdTemp);

end
