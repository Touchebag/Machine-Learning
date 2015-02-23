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

N = zeros(nDocuments, nWords, nTopics); % skip excluding in this step?
M = zeros(nDocuments, nWords, nTopics); % skip excluding in this step?
Z = randi([1,nTopics], nDocuments, nWords); % Topic of each word w = (d,i) Correct? We give words that are not in the document a topic right now.

% Calculate number of times word w has occured with topic k.
for d = 1:nDocuments
    for w = 1:nWords
       for t = 1:nTopics
           
           N(d,w,t) = sum( ( t == Z(:,w) ) ); % not excluding any word. TODO: need to extract count from data also!
           M(d,w,t) = sum ( k == Z(d,:) ) % not excluding any word. TODO: need to extract count from data also!
       
       end
    end
end

for d = 1:nDocuments
    for w = 1:nWords
        probTopic = zeros(nTopics, 1);
        for t = 1:nTopics
            Mw = M(d,w,t);
            Nw = N(d,w,t);
            
            if Z(d,w) == k
                Mw = Mw - 1;
                Nw = Nw - 1;
            end
            
            sumNw = sum( N(:,:,t) ) - sum(t == N(:,w, t))
            sumMw = sum(
            probTopic(t) =  
        end
    end
end
% --- Inference, sampling Z



% instanceWords = 0;
% for i = 1:nDocuments
%    for j = 1:length(data{i}.id)
%        instanceWords = instanceWords + 1;
%    end
% end
%instanceWords
% Initialize z
z = randi([1,nTopics], instanceWords, 1);
readOutCount = nBurnIn;


for iteration = 1:nIt
  zIndex = 0;
%     for d = 1:nDocuments
%       for w = 1:length(data{d}.id)
%          zIndex = zIndex + 1
%          probTopic = zeros(nTopics, 1);
% 
%          for j = 1:nTopics
%             njWi   = 0; % # times word wi got assigned to topic j
%             njAll  = 0; % # words assigned to topic j
%             njDi   = 0; % # words in document di with topic j
%             nDAll  = 0; % # words in document di
% 
%             for di = 1:nDocuments % needed?
%               for wi = 1:length(data{di}.id) % needed?
%                 if data{d}.id(w) ~= data{di}.id(wi)
%                    if (data{d}.id(w) == data{di}.id(wi)) && (z(zIndex) == j)
%                        njWi = njWi + data{di}.cnt(wi);
%                    end
% 
%                    if z(zIndex) == j
%                        njAll = njAll + data{di}.cnt(wi);
%                    end
% 
%                    if (d == di) && (z(zIndex) == j)
%                        njDi = njDi + data{di}.cnt(wi);
%                    end
% 
%                    if d == di
%                        nDAll = nDAll + data{di}.id(wi);
%                    end
%                 end
%               end
%             end
% 
%             % Expression for probability of topic j for zi
%             probTopic(j,1) = (njWi + eta) / (njAll + nWords*eta) * (njDi + alpha) / (nDAll + nTopics*alpha);
%          end
%        z(zIndex) = randsample(nTopics, 1, true, probTopic);
%       end
%     end

%     % --- Estimate parameters, beta, theta
%     if readOutCount < 1 || iteration == nIt
%         for k = 1:nWords
%            for l = 1:nTopics
%                nTotTopic = 0;
%                nWordsTopic = 0;
% 
%                for m = 1:instanceWords
%                   if z(m) ==  l
%                       nTotTopic = nTotTopic + 1;
%                       if wordArray(m, 2) == k
%                           nWordsTopic = nWordsTopic + 1;
%                       end
%                   end
%                end
%                beta(k,l) = (nWordsTopic + eta) / (nTotTopic+nWords*eta);
%            end
%         end
% 
%         for k = 1:nTopics
%             for l = 1:nDocuments
%                 nTopicD   = 0;
%                 nTotTopic = 0;
%                 for m = 1:instanceWords
%                     if wordArray(m,1) == l
%                         nTotTopic = nTotTopic + 1;
%                         if z(m) == k
%                             nTopicD = nTopicD + 1;
%                         end
%                     end
%                 end
%                 nTotTopic = nTotTopic + nTopics*alpha;
%                 theta(l,k) = (nTopicD + alpha) / nTotTopic;
%             end
%         end
       iteration % REMOVE BEFORE HAND-IN
%         beta
%         theta
%         readOutCount = nReadIt;
%     else
%         readOutCount = readOutCount - 1;
%     end
end
end
