load('d1b.mat');
% Implementation for 1.2 to be extended to 2.1

H = eye(3);
f = zeros(size(H,2),1); % f is the vector for costs, we do not use this. Hence 0.
t = [1;1;1;-1;-1;-1]; % target values. Should be +-1.
Xi = [2 2; 4 4; 4 0; 0 0; 2 0; 0 2]; % points coordinates
A = -[diag(t)*Xi t] % LH-side of constraint and target values
b = -ones(6,1);
lw = quadprog(H,f,A,b);
%figure(1);
%svmtrain(Xi, t, 'showplot', true); % Why does this plot turn out the way it does?
%figure(2);
%line = @(x1,x2) lw(1)*x1 + lw(2)*x2 + lw(3); % The corresponding line for primal.
%ezplot(line, [0 4 0 4]) % plot the line from quadprog

% 2.1
H = eye(3);
f = zeros(size(H,2),1);
b = -abs(Y);
A = -[diag(Y)*X Y];
lw = quadprog(H, f, A, b)
line = @(x1,x2) lw(1)*x1 + lw(2)*x2 + lw(3);
figure(1);
e = ezplot(line, [-3 4 -2 4])
set(e,'Color', 'black');
hold on
% slow for-loop but gets the job done.
xBelow = [];
yBelow = [];
xSVBelow = [];
minBelow = 1000;
xAbove = [];
yAbove = [];
xSVAbove = [];
margin = 1/sqrt(lw(1)^2 + lw(2)^2);
minAbove = 1000;
margin
for i=1:size(Y,1)
    lineVal = line(X(i,1), X(i,2));
    xDist = abs(lw(1)*X(i,1) + lw(2)*X(i,2) + lw(3))/sqrt(lw(1)^2+lw(2)^2);
    xDist;
    if lineVal < 0
        xBelow = [xBelow; X(i,:)];
        yBelow = [yBelow; Y(i)];
        if xDist < minBelow%margin
           minBelow = xDist;
           xSVBelow = X(i,:);
        end
    else
        xAbove = [xAbove; X(i,:)];
        yAbove = [yAbove; Y(i)];
        if xDist < minAbove%margin
            minAbove = xDist;
            xSVAbove = X(i,:);
        end
    end
end
hold on
scatter(xBelow(:,1), xBelow(:,2), [], 'red');
hold on
scatter(xAbove(:,1), xAbove(:,2), [], 'blue');
hold on
scatter(xSVAbove(1,1), xSVAbove(1,2), 'blue', 'filled');
hold on
scatter(xSVBelow(1,1), xSVBelow(1,2), 'red', 'filled');

% TODO: How many support vectors do we have? Arbitrary? or all that have
%       minimum distance to the line?
%scatter(X(:,1),X(:,2))
hold off
figure(2);
svmtrain(X,Y,'showplot', true);

%% 2.1
load('d2.mat');
H = eye(3);
f = zeros(size(H,2),1);
b = -abs(Y);
A = -[diag(Y)*X Y];
lw = quadprog(H, f, A, b)
line = @(x1,x2) lw(1)*x1 + lw(2)*x2 + lw(3);
figure(1);
e = ezplot(line, [-2.5 2.5 -2.5 2.5])
set(e,'Color', 'black');
hold on
% slow for-loop but gets the job done.
xBelowC = [];
yBelowC = [];
xBelowW = [];
yBelowW = [];
xAboveC = [];
yAboveC = [];
xAboveW = [];
yAboveW = [];

margin = 1/sqrt(lw(1)^2 + lw(2)^2);
minAbove = 1000;

for i=1:size(Y,1)
    lineVal = line(X(i,1), X(i,2));
    xDist = abs(lw(1)*X(i,1) + lw(2)*X(i,2) + lw(3))/sqrt(lw(1)^2+lw(2)^2);
    xDist;
    if lineVal < 0
        if Y(i) == 1
            xBelowC = [xBelowC; X(i,:)];
            yBelowC = [yBelowC; Y(i)];
        else 
            xBelowW = [xBelowW; X(i,:)];
            yBelowW = [yBelowW; X(i,:)];
        end
        
        if xDist < minBelow%margin
           minBelow = xDist;
           xSVBelow = X(i,:);
        end
    else
        if Y(i) == -1
            xAboveC = [xAboveC; X(i,:)];
            yAboveC = [yAboveC; Y(i)];
        else
            xAboveW = [xAboveW; X(i,:)];
            yAboveW = [yAboveW; Y(i)];
        end
        if xDist < minAbove%margin
            minAbove = xDist;
            xSVAbove = X(i,:);
        end
    end
end
hold on
scatter(xBelowC(:,1), xBelowC(:,2), [], 'red', 'filled');
hold on
scatter(xBelowW(:,1), xBelowW(:,2), [], 'blue');
hold on
scatter(xAboveC(:,1), xAboveC(:,2), [], 'blue', 'filled');
hold on
scatter(xAboveW(:,1), xAboveW(:,2), [], 'red');


