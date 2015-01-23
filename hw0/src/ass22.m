% Robin Touche
% Homework 0 - Assignment 2.1

file  = fopen("./dataset0.txt");
input = fscanf(file, "%d", [12 1074]);

Xcov  = cov (input');
Xcorr = corr(input');

Ycov  = cov (input' .*0.2)
Ycorr = corr(input' .*0.2)

