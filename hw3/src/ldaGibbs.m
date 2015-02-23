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


% --- Initialization
N = zeros(nWords, nTopics);
M = zeros(nDocuments, nTopics);
Z = ones(nDocuments, nWords)*(-1); % Initialize topic to -1 for words that is not part of the document.
for d = 1:nDocuments
    for w = 1: length(data{d}.id)
        Z(d,data{d}.id(w)) = randi([1,nTopics]); % initialize words that exist to a random topic
    end
end

% N: Calculate number of times word w has occured with topic k.
% M: Number of times topic k has occured with a word from document d
for d = 1:nDocuments
    for w = 1:length(data{d}.id)
       for t = 1:nTopics
           if Z(d,data{d}.id(w)) == t
               N(data{d}.id(w),t) = N(data{d}.id(w),t) + data{d}.cnt(w);
               M(d,t) = M(d,t) + data{d}.cnt(w); 
           end
       end
    end
end


% --- Inference, sampling Z
rdCntDwn = nBurnIn;
for iteration = 1:nIt
    for d = 1:nDocuments
        for w = 1:length(data{d}.id)
            probTopic = zeros(nTopics,1);
            for t = 1:nTopics
                ntwa = sum(N(:,t)) - N(data{d}.id(w),t);
                mdta = sum(M(d,:)) - M(d,t);
                ntw  = N(data{d}.id(w),t);
                mdt  = M(d,t);
                if Z(d,data{d}.id(w)) == t
                    ntw  = ntw - data{d}.cnt(w); 
                    mdt  = mdt - data{d}.cnt(w);
                end
                probTopic(t) = (eta + ntw)/(nWords*eta + ntwa) * (alpha + mdt) / (nTopics*alpha + mdta);
            end
            newT = randsample(nTopics, 1, true, probTopic);
            N(data{d}.id(w),Z(d,data{d}.id(w))) = N(data{d}.id(w),Z(d,data{d}.id(w))) - data{d}.cnt(w);
            N(data{d}.id(w),newT) = N(data{d}.id(w),newT) + data{d}.cnt(w);
            M(d,Z(d,data{d}.id(w))) = M(d,Z(d,data{d}.id(w))) - data{d}.cnt(w);
            M(d,newT) = M(d,newT) + data{d}.cnt(w);
            Z(d,data{d}.id(w)) = newT;
        end
    end
    % check if we should read beta and theta.
    if rdCntDwn < 1
        for t = 1:nTopics
            for w = 1:nWords
                betaNTemp = 0;
                for di = 1:nDocuments
                   for wi = 1:length(data{di}.id)
                       if data{di}.id(wi) == w && Z(di, data{di}.id(wi)) == t
                            betaNTemp = betaNTemp + data{di}.cnt(wi);
                       end
                   end
                end
                beta(t,w) = (betaNTemp + eta) / (sum(N(:,t)) + eta*nWords);
            end
            for d = 1:nDocuments
               theta(d,t) = (M(d, t) + alpha) / (sum(M(d,:)) + nTopics*alpha);
            end
        end
        rdCntDwn = nReadIt;
        beta
        theta
    else
        rdCntDwn = rdCntDwn - 1;
    end
 iteration   
end
end