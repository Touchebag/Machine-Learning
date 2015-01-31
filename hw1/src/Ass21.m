% Robin Touche
% Homework 1 - Assignment 2.1

load('dataset1.mat');

% Calculate mu and sigma
[mu, sigma] = sge(x);

% Plot stuff
hold on;

scatter(x(:,2), x(:,1));

circle(mu(2), mu(1), sigma);
circle(mu(2), mu(1), 2 * sigma);
circle(mu(2), mu(1), 3 * sigma);

hold off;
