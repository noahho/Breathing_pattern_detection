function [detected_count, true_count, detected_per, true_per] = evaluateModelOnWholeSequence(feat_prob, feat_cumprob, TRANS, EMIS, C, subject, Config)
    full_acc = getRawAcceleration('SubjectID',subject, 'State', 9);
    fprintf('Evaluate on %i sequences\n', length(full_acc))
    full_acc = vertcat(full_acc{:});
    full_acc = preprocess(full_acc, Config);

    p = calculateChangepoints(full_acc(:, 4), 0, Config);
    clustering_segments = featurize_segments(full_acc(:, 4), p, Config('POLYNOME_DEGREE'));

    [idx, ~] = kmeans(clustering_segments, Config('N_CLUSTERS'), 'MaxIter', 0, 'Start',C);
    
    num_patterns = length(Config('PATTERN_NO'));
    detected_sequences = cell(num_patterns, 1);
    detected_count = cell(num_patterns, 1);
    true_count = cell(num_patterns, 1);
    detected_per = cell(num_patterns, 1);
    true_per = cell(num_patterns, 1);

    K = 1;
    for PATTERN = [Config('PATTERN_NO')]
    acc = getRawAcceleration('SubjectID',subject, 'State', PATTERN);
    
    detected_sequences{K} = findPatterns(idx, p, feat_prob{K}, feat_cumprob{K}, TRANS{K}, EMIS{K}, Config);
    
    detected_count{K} = zeros(length(detected_sequences{K}), 1);
    true_count{K} = zeros(length(acc), 1);
    for H = [1:length(detected_sequences{K})]
        detected_Seq_ind = detected_sequences{K}{H};
        detected_Seq_classes = full_acc(detected_Seq_ind(1):detected_Seq_ind(2), 5);
        detected_Seq_numbers = full_acc(detected_Seq_ind(1):detected_Seq_ind(2), 6);
        valid_points = detected_Seq_classes == (PATTERN - 1);
        seq_no = detected_Seq_numbers(valid_points);
        
        
        per = sum(valid_points)/(detected_Seq_ind(2)-detected_Seq_ind(1));
        if per > 0.2
            detected_count{K}(H) = 1;
            if (length(seq_no) > 1)
                true_count{K}(seq_no(1)) = 1;
            end
        end
%         if per < 0.1
%             figure()
%             plot(full_acc(detected_Seq_ind(1):detected_Seq_ind(2), 4));
%         end
    end
    detected_per{K} = length(detected_count{K}(detected_count{K}==1))/length(detected_count{K});
    true_per{K} = length(true_count{K}(true_count{K}==1))/length(true_count{K});
    K = K + 1;
    end
end