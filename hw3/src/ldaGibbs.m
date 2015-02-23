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
    nIt, nReadIt, nBurnIn, nWords)

% --- Variable declaration
nDocuments = length(data);
beta = zeros(nTopics,nWords);
theta = zeros(nDocuments,nTopics);

% ------- BELOW, YOU SHOULD IMPLEMENT THE GIBBS SAMPLER -------------
% ------- AND OUTPUT beta AND theta.                     -------------


% --- Initialization

N = zeros(nWords, nTopics); % skip excluding in this step?
M = zeros(nDocuments, nTopics); % skip excluding in this step?
Z = ones(nDocuments, nWords)*(-1); % Initialize topic to -1 for words that is not part of the document.
for d = 1:nDocuments
    for w = 1: length(data{d}.id)
        Z(d,w) = randi([1,nTopics]); % initialize words that exist to a random topic
    end
end

% N: Calculate number of times word w has occured with topic k.
% M: Number of times topic k has occured with a word from document d
for d = 1:nDocuments
    for w = 1:length(data{d}.id)
       for t = 1:nTopics
           if Z(d,w) == t
               N(w,t) = N(w,t) + data{d}.cnt(w);
               M(d,t) = M(d,t) + data{d}.cnt(w); % They look too similar, should there be another setup?
           end
       end
    end
end


% --- Inference, sampling Z

for d = 1:nDocuments
    for w = 1:length(data{d}.id)
        probTopic = zeros(nTopics,1);
        for t = 1:nTopics
            ntw  = N(w,t) - data{d}.cnt(w); 
            ntwa = sum(N(:,t)) - N(w,t); % Is this correct?
            mdt  = M(d,t) - data{d}.cnt(w);
            mdta = sum(M(d,:)) - M(d,t); %  Is this correct?
            probTopic(t) = (eta + ntw)/(nWords*eta + ntwa) * (alpha + mdt) / (nTopics*alpha + mdta);
        end
        % sample zi and update M & N.
    end
    d
end         
end
