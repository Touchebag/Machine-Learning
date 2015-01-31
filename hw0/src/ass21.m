% Robin Touche
% Homework 0 - Assignment 2.1
%clf;

mu = [1; 1];
sigma = [0.1 -0.05; -0.05 0.2];

rng default;
data = mvnrnd(mu, sigma, 1000);

f = @(x,r) (((x - mu)' * inv(sigma) * (x - mu)) / 2) - r;

% Same function but splitting the vector and fixing r to 3
% Got weird dimensional mismatch in arrayfun otherwise
% and a for loop would look even uglier
g = @(x1,x2) ((([x1;x2] - mu)' * inv(sigma) * ([x1;x2] - mu)) / 2) - 3;
values = arrayfun(g, data(:,1), data(:,2));

blackPoints = data(values > 0, :);
bluePoints  = data(values <= 0, :);

hold on;
axis([-0.5 2.5 -0.5 3]);
plot1 = ezplot(@(x1,x2) f([x1;x2], 1));
set(plot1, 'color', 'r')
plot2 = ezplot(@(x1,x2) f([x1;x2], 2));
set(plot2, 'color', 'g')
plot3 = ezplot(@(x1,x2) f([x1;x2], 3));
set(plot3, 'color', 'b')

scatter(blackPoints(:,1), blackPoints(:,2), 'black');
scatter(bluePoints (:,1), bluePoints (:,2), 'blue');

title(['Number of points outside f(x,3) = 0: ' num2str(size(blackPoints, 1))]);

hold off;
