% Robin Touche
% Homework 1 - Assignment 2.1

load('dataset1.mat');

% Calculate mu and sigma
[mu, sigma] = sge(x);

% Calculate how many points lie outside the circles
s1 = 0;
s2 = 0;
s3 = 0;

for i = 1:size(x, 1)
  % distance = dist([mu; x(i, :)]);
  distance = 1;

  if distance > sigma
    s1 = s1 + 1;
  end
  if distance > 2 * sigma
    s2 = s2 + 1;
  end
  if distance > 3 * sigma
    s3 = s3 + 1;
  end
end

% Plot stuff
hold on;

circle(mu(2) , mu(1) , 1 * sigma , 'r');
circle(mu(2) , mu(1) , 2 * sigma , 'g');
circle(mu(2) , mu(1) , 3 * sigma , 'b');

legend(sprintf('%d', s1), sprintf('%d', s2), sprintf('%d', s3));

scatter(x(:,2), x(:,1));

hold off;
