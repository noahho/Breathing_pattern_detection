[likely_sequence, likely_states] = hmmgenerate(20,TRANS{1},EMIS{1});
% Filter out the end sequences, those cant become polynomes
likely_sequence = likely_sequence(likely_sequence ~= Config('N_CLUSTERS')+1);
likely_polynoms = C(likely_sequence, :);

figure()
hold on

e = 0;
for K = [1:length(likely_polynoms)]
    r = linspace((K-1) * 10, K * 10, 10);
    plot(r,polyval([likely_polynoms(K, 1:end-2), e],[1:10]))
    % e = polyval([likely_polynoms(K, 1:end-1), e],10);
    e = e + likely_polynoms(K, end);
end
