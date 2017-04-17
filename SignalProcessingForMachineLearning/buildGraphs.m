examine_arr = POLYNOME_DEGREE_ARR;
examine_arr2 = N_CLUSTERS_ARR;
examine_pos = 1;
examine_pos_2 = 2;

searchedParameters( isnan(searchedParameters))=0;

X = zeros(length(examine_arr), length(examine_arr2), 2);
K = 1;
H = 1;
for examine = examine_arr
    H = 1;
    for examine2 = examine_arr2
    sel = searchedParameters(:, [examine_pos, examine_pos_2]) == [examine, examine2];
    sel = sum(sel, 2) == 2;
    X(K, H, :) = mean(searchedParameters(sel, 5:6));
    H = H +1;
    end
    K = K + 1;
end
figure
hold on
surf(examine_arr, examine_arr2, X(:, :, 1)')
xlabel('Degree of polynome')
ylabel('Number of clusters')