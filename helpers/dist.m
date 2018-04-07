function d = dist(v_1, v_2)
    d = sqrt(sum((v_2 - v_1) .^ 2));
end % dist