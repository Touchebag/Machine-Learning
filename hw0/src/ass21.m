% Robin Touche
% Homework 0 - Assignment 2.1

mu = [1; 1];
sigma = [0.1 -0.05; -0.05 0.2];

X = mvnrnd(mu, sigma);

f = @(x,r) ((x - mu)' * inv(sigma) * (x - mu)) / 2 - r;

hold on;
plot1 =  ezplot(@(x1, x2) f([x1:x2], 1));
set(plot1, 'color', 'r')
hold off;
