function [Ytest] = new_classifier(Xtest, mu1, mu2)

% Expression shown in lab instructions for problem 2.1 c)
b = (mu1 + mu2) / 2;
Ytest = sign( ( (mu1' - mu2')'*(Xtest' - b') ) / norm(mu1 - mu2));

end