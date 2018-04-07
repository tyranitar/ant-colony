function x_new = bounded(x, lo, hi)
    if x < lo
        x_new = lo;
    elseif x > hi
        x_new = hi;
    else
        x_new = x;
    end % if
end % bounded