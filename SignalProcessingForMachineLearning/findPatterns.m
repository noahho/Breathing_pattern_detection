function detected_sequences = findPatterns(idx, p, feat_prob, feat_cumprob, TRANS, EMIS, Config)
likely_indices = cell(0, 1);
detected_sequences = cell(0, 1);
for K = [1 : length(idx)]
    likely_indices = {K, likely_indices{:}};
    deleted = 0;
    for J = [1 : length(likely_indices)]
        J = J - deleted;
        
        numOfChangepoints = K - likely_indices{J} + 1;
        lengthOfSequence = p(K+1) - p(likely_indices{J});
        
        if numOfChangepoints < 6 || lengthOfSequence < 30
            continue;
        end
        feats = [lengthOfSequence, numOfChangepoints];
        [~, pr] = hmmdecode(idx(likely_indices{J}:K)',TRANS,EMIS);
            
        if pr < Config('ACCEPT_LIKELYHOOD') || log(feat_cumprob(feats)) < Config('ACCEPT_LIKELYHOOD_FEAT')
            likely_indices(J) = [];
            deleted = deleted + 1;
            continue;
        end
        
        [~, pr] = hmmdecode([idx(likely_indices{J}:K)', Config('N_CLUSTERS') + 1],TRANS,EMIS);
        if pr >= Config('ACCEPT_LIKELYHOOD') && log(feat_prob(feats)) >= Config('ACCEPT_LIKELYHOOD_FEAT')
            detected_sequences = {[p(likely_indices{J}),p(K+1)], detected_sequences{:}};
        end
    end
end
end