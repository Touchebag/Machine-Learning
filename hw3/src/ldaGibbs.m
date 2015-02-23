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

rdCntDwn = nBurnIn;
for iteration = 1:nIt
    for d = 1:nDocuments
        for w = 1:length(data{d}.id)
            probTopic = zeros(nTopics,1);
            for t = 1:nTopics
                ntwa = sum(N(:,t)) - N(w,t); % Is this correct?
                mdta = sum(M(d,:)) - M(d,t); %  Is this correct?
                ntw  = N(w,t);
                mdt  = M(d,t);
                if Z(d,w) == t
                    ntw  = ntw - data{d}.cnt(w); 
                    mdt  = mdt - data{d}.cnt(w);
                end
                probTopic(t) = (eta + ntw)/(nWords*eta + ntwa) * (alpha + mdt) / (nTopics*alpha + mdta);
            end
            
            % SOMETHING WRONG WITH THESE UPDATES, WE GET NEGATIVE VALUES ON
            % SOME INDEXES IN N & M.
            newT = randsample(nTopics, 1, true, probTopic);
            newT
            N(data{d}.id(w),t) = N(data{d}.id(w),t) - data{d}.cnt(w); %something wrong   % UPDATES SHOULD NOT BE WITH W, but rather with data{d}.id(w)!!!!!
            N(data{d}.id(w),newT) = N(data{d}.id(w),newT) + data{d}.cnt(w);
            M(d,t) = M(d,t) - data{d}.cnt(w); %  wrong
            M(d,newT) = M(d,newT) + data{d}.cnt(w);
            Z(d,w) = newT;
        end
    end
    % check if we should read beta and theta.
    if rdCntDwn < 1
        % read out beta and theta
        for t = 1:nTopics
           for w = 1:length(data{d}.id)
              beta(t,w) = (N(data{d}.id(w),t) + eta) / (sum(N(:,t)) + eta*nWords); % should nWords be number of words in document d instead?
           end
           for d = 1:nDocuments
               theta(d,t) = (M(d, t) + alpha) / (sum(M(d,:)) + nTopics*alpha);
           end
        end
        rdCntDwn = nReadIt;
    else
        rdCntDwn = rdCntDwn - 1;
    end
 iteration   
end
end