setVariables()

searchedParameters = zeros(4000, 6);
IND = 1;
train_subject = 4;
test_subject = 6;

[TRANS, EMIS, feat_prob, feat_cumprob, C] = trainModel(train_subject, Config);
[detected_count, true_count, detected_per, true_per] = evaluateModelOnWholeSequence(feat_prob, feat_cumprob, TRANS, EMIS, C, test_subject, Config);
        
searchedParameters(IND, :) = [POLYNOME_DEGREE, N_CLUSTERS, N_STATES, CHANGE_POINT_METHOD, detected_per{1}, true_per{1}];
fprintf('%i %% of the detected sequences were false alarms \n', (1-searchedParameters(IND, 5))*100);
fprintf('%6.2f %% of the sequences in the test set were not detected \n', (1-searchedParameters(IND, 6))*100);
% 
% for POLYNOME_DEGREE = POLYNOME_DEGREE_ARR
%     for CHANGE_POINT_METHOD = CHANGE_POINT_METHOD_ARR
%         for N_CLUSTERS = N_CLUSTERS_ARR
%         for N_STATES = N_STATES_ARR
%         Config('POLYNOME_DEGREE') = POLYNOME_DEGREE;
%         Config('CHANGE_POINT_METHOD') = CHANGE_POINT_METHOD;
%         Config('N_CLUSTERS') = N_CLUSTERS;
%         Config('N_STATES') = N_STATES;
%         
%         [TRANS, EMIS, feat_prob, feat_cumprob, C] = trainModel(train_subject, Config);
%         [detected_count, true_count, detected_per, true_per] = evaluateModelOnWholeSequence(feat_prob, feat_cumprob, TRANS, EMIS, C, test_subject, Config);
%         
%         searchedParameters(IND, :) = [POLYNOME_DEGREE, N_CLUSTERS, N_STATES, CHANGE_POINT_METHOD, detected_per{1}, true_per{1}];
%         IND = IND + 1;
%         end
%         end
%     end
% end 
% searchedParameters( sum(A(:, 5:6) == [1,1],2) == 2, :)
% 
% 
% for HMM_TOLERANCE = HMM_TOLERANCE_ARR
%     trainModel()
%     searchedParameters(IND, :) = [POLYNOME_DEGREE, N_CLUSTERS, N_STATES, CHANGE_POINT_METHOD, detected_per{PATTERN_NO}, true_per{PATTERN_NO}];
%     IND = IND + 1;
% end