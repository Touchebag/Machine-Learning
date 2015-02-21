% -------------------------------------------------------------------
%
% This file is part of an exercise in the Machine Learning course of 
% Chalmers University of Technology
%
% Author: Fredrik Johansson (2013)
%
%
% ldaGibbs(data,nTopics,alpha,eta,nIt,nReadIt,
%          nBurnIn, nWords) 
% trains the LDA model based on wordcounts in data using nTopics 
% topics.
%
% data      A cell-array where each element is a sparse representation 
%           of the word count for a single document. Each cell has two
%           fields, id (representing word ids) and cnt (counts)
% nTopics   The number of topics to be used
% alpha     The parameter alpha
% eta       The parameter eta
% nIt       The number of Gibbs iterations to perform
% nReadIt   The number of iterations between parameter readouts
% nBurnIn   The number of iterations making up the burn-in
% nWords    The number of words in the vocabulary
% 
% -------------------------------------------------------------------

function [beta, theta] = ldaGibbs(data, nTopics, alpha, eta, ...
    nIt, nReadIt, nBurnIn, instanceWords)

% --- Variable declaration
nDocuments = length(data);
beta = zeros(nTopics,instanceWords);
theta = zeros(nDocuments,nTopics);

% ------- BELOW, YOU SHOULD IMPLEMENT THE GIBBS SAMPLER -------------
% ------- AND OUTPUT beta AND theta.                     -------------


% --- Initialization
% number of word instances.
wordArray  = [];
instanceWords = 0;
for i = 1:nDocuments
   for j = 1:length(data{i}.id)
       instanceWords = instanceWords + data{i}.cnt(j);
       for k = 1:data{i}.cnt(j);            
          wordArray = [wordArray; [i, data{i}.id(j)]];
       end
   end
end

% Initialize z
z = randi([1,nTopics], length(instanceWords, 1),1);

% --- Inference, sampling Z

for a = 1:instanceWords 
   maxProb = 0;
   for j = 1:nTopics
      njWi   = 0 % # times word wi got assigned to topic j
      for x = 1:instanceWords
         if a ~= x & wordArray(a,2) == wordArray(x,2) & z[x] == j
             njWi = njWi + 1;
         end
      end
      
      njAll  = 0 % words assigned to topic j
      njDi   = 0 % words in document di with topic j
      nDiAll = 0 % words in document di
      
   end
end

% --- Estimate parameters, beta, theta
end
