% Robin Touche
% Homework 0 - Assignment 2.1

mu = [1; 1];
sigma = [0.1 -0.05; -0.05 0.2];

% rng default;
% X = mvnrnd(mu, sigma, 100);

% x = load('data');

f = @(x,r) (((x - mu)' * inv(sigma) * (x - mu)) / 2) - r;

hold on;
plot1 = ezplot(@(x,y) f([x;y], 1))
set(plot1, 'color', 'r')
plot2 = ezplot(@(x,y) f([x;y], 2))
set(plot1, 'color', 'r')
plot3 = ezplot(@(x,y) f([x;y], 3))
set(plot1, 'color', 'r')
hold off;
