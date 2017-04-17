full_acc_orig = getRawAcceleration('SubjectID',5, 'State', 9);
full_acc_orig = vertcat(full_acc_orig{:});

full_acc_1 = generateTestData(full_acc_orig);
full_acc_1 = full_acc_1(:, 1:5);

full_acc_2 = generateTestData(full_acc_orig);
full_acc_2 = full_acc_2(:, 1:5);

full_acc_3 = generateTestData(full_acc_orig);
full_acc_3 = full_acc_3(:, 1:5);

full_acc_4 = generateTestData(full_acc_orig);
full_acc_4 = full_acc_4(:, 1:5);
csvwrite('dataset_generated.csv',[full_acc_orig(:, 1:5); full_acc_1; full_acc_2; full_acc_3; full_acc_4])
type dataset_generated.csv