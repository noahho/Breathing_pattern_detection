function displayExample(d, s, cm)
    figure()
    p = calculateChangepoints(d, cm, 1);
    for K = [1:length(p) - 1]
        txt1 = num2str(s(K));
        text(p(K),d(1),txt1)
    end
end