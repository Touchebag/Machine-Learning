% Robin Touche
% Homework 0 - Assignment 2.1

mu = [1; 1];
sigma = [0.1 -0.05; -0.05 0.2];

f = @(x,r) ((x - mu)' * inv(sigma) * (x - mu)) / 2 - r;
