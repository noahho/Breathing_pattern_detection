function [TRANS, EMIS, feat_prob, feat_cumprob] = trainPattern(acc, pre_C, Config)
FEATURES_COUNT = 2;

% Zero step: Preprocessing
% Smooth the data
% First step: Segmentation
% Segment all arrays of signals into pieces and save them back to the
% arrays of signals
% Details:
% - Remove the part before first and after last segment
% Second step: Encoding of segments
% Third step: feature extraction
segments = cell(length(acc), 1);
for K = [1: length(acc)]
    acc{K} = preprocess(acc{K}, Config);
    p = calculateChangepoints(acc{K}(:, 4), 0, Config);
    segments{K} = featurize_segments(acc{K}(:, 4), p, Config('POLYNOME_DEGREE'));
end

% Fourth step: Clustering of segments
clustering_segments = vertcat(segments{1:length(acc)});

rng(1); % For reproducibility
warning('off', 'stats:kmeans:FailedToConverge')
[idx,~] = kmeans(clustering_segments,Config('N_CLUSTERS'),'MaxIter',0,'Start',pre_C);
J = 1;
seqs = cell(length(acc), 1);
features = zeros(length(acc), FEATURES_COUNT);
for K = [1: length(acc)]
    l = size(segments{K}, 1);
    seqs{K} = [idx(J:J+l-1)', Config('N_CLUSTERS') + 1];
    t = length(acc{K});
    features(K, :) = [t, l];
    J = J + l;
end

randomNumbers = rand(Config('N_STATES'),Config('N_STATES'));
sumOfNumbers = sum(randomNumbers, 2);
trans = randomNumbers ./ sumOfNumbers;
emis = 1/(Config('N_STATES') * (Config('N_CLUSTERS') + 1)) * ones(Config('N_STATES'), (Config('N_CLUSTERS') + 1));

[TRANS,EMIS] = hmmtrain(seqs,trans,emis, 'Verbose', false,'Tolerance',Config('HMM_TOLERANCE'));

features = sum(features, 1)/size(features, 1);
feat_prob = @(x) mvnpdf(x,features,features/2);
feat_cumprob = @(x) (1-mvncdf(x(1),features(1),features(1)/2))*(1-mvncdf(x(2),features(2),features(2)/2));
fprintf('Training done \n')
end