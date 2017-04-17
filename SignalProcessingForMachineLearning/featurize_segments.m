function [d] = featurize_segments(d_, p, polynome_degree)
    d = zeros(length(p) - 1, polynome_degree + 1);
    for J = [1: length(p) - 1]
        % segmentation between the change points
        % exclude the parts before first and after last change point
        s_start = p(J);
        s_end = p(J + 1);
        
        segment = d_(s_start:s_end);
        
        % encode the segments
        % model = polydata(ar(segment,3));
        model = polyfit([1:length(segment)], segment', polynome_degree);
        
        d(J, 1:polynome_degree) = model(1:polynome_degree);
        
        avg_length = 20;
        avg_change = 0.4;
        
        seq_length = 1/avg_length * (s_end - s_start);
        change = 1/avg_change * (segment(end) - segment(1));
        
        d(J, polynome_degree + 1) = 2/(1+exp(-seq_length)) - 1;
        d(J, polynome_degree + 2) = 4/(1+exp(-change)) - 2;
        
        d(J, :) = d(J,:);
    end
end