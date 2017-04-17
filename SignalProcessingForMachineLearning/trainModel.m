function [TRANS, EMIS, feat_prob, feat_cumprob, C] = trainModel(subject, Config)
full_acc = getRawAcceleration('SubjectID',subject, 'State', 9);
full_acc = vertcat(full_acc{:});
full_acc = preprocess(full_acc, Config);

p = calculateChangepoints(full_acc(:, 4), 0, Config);
clustering_segments = featurize_segments(full_acc(:, 4), p, Config('POLYNOME_DEGREE'));

[idx,C] = kmeans(clustering_segments, Config('N_CLUSTERS'));

num_patterns = length(Config('PATTERN_NO'));
TRANS = cell(num_patterns, 1);
EMIS = cell(num_patterns, 1);
feat_prob = cell(num_patterns, 1);
feat_cumprob = cell(num_patterns, 1);

K = 1;
for PATTERN = [Config('PATTERN_NO')]
    acc = getRawAcceleration('SubjectID',subject, 'State', PATTERN);
    if isempty(acc)
        continue;
    end
    
    fprintf('Train Pattern %i with %i sequences\n', PATTERN-1, length(acc))
    [TRANS{K}, EMIS{K}, feat_prob{K}, feat_cumprob{K}] = trainPattern(acc, C, Config);
    K = K + 1;
end
end
%example = 19;
%plot(full_acc(detected_sequences{4}{example}(1):detected_sequences{4}{example}(2)))