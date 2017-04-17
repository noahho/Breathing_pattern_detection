load('dataset.mat')

detected_count = zeros(length(detected_sequences), 1);
true_count = zeros(length(sequence_indices{subject, 1}), 1);
for K = 1:length(detected_sequences)
    for J = 1:length(sequence_indices{subject, 1})
        if (size(sequence_indices{subject, 1}{J}, 1) == 0)
            break
        end
        intersection = intersect(sequence_indices{subject, 1}{J}, detected_sequences{K});
        if ~isempty(intersection)
            detected_count(K) = 1;
            true_count(J) = 1;
        end
    end
end

fprintf('Clustered segments and built sequences for HMM \n')
length(detected_count(detected_count==0))/length(detected_count)
length(true_count(true_count==0))/length(true_count)

plot(full_acc(detected_sequences{15}))