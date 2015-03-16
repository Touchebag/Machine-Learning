% 2.1
load('d1b.mat');
% Compute weights for linear kernel.
H = eye(3);
f = zeros(size(H,2),1);
b = -abs(Y);
A = -[diag(Y)*X Y];
lw = quadprog(H, f, A, b);
line = @(x1,x2) lw(1)*x1 + lw(2)*x2 + lw(3);
margin = 1/sqrt(lw(1)^2 + lw(2)^2);

% Plot line for computed linear kernel.
figure(1);
e = ezplot(line, [-3 4 -2 4]);
set(e,'Color', 'black');
hold on

%  Variables for the loop, mainly matrices for splitting the data points.
xBelow = [];
yBelow = [];
xSVBelow = [];
xAbove = [];
yAbove = [];
xSVAbove = [];
minBelow = 1000;
minAbove = 1000;

% Check the data point to determine how good the linear kernel fits.
for i=1:size(Y,1)
    lineVal = line(X(i,1), X(i,2));
    xDist = abs(lw(1)*X(i,1) + lw(2)*X(i,2) + lw(3))/sqrt(lw(1)^2+lw(2)^2);
    xDist;
    if lineVal < 0
        xBelow = [xBelow; X(i,:)];
        yBelow = [yBelow; Y(i)];
        if xDist < minBelow
           minBelow = xDist;
           xSVBelow = X(i,:);
        end
    else
        xAbove = [xAbove; X(i,:)];
        yAbove = [yAbove; Y(i)];
        if xDist < minAbove
            minAbove = xDist;
            xSVAbove = X(i,:);
        end
    end
end

% Plot computed linear kernel with data points.
hold on
scatter(xBelow(:,1), xBelow(:,2), [], 'red');
hold on
scatter(xAbove(:,1), xAbove(:,2), [], 'blue');
hold on
scatter(xSVAbove(1,1), xSVAbove(1,2), 'blue', 'filled');
hold on
scatter(xSVBelow(1,1), xSVBelow(1,2), 'red', 'filled');
hold off