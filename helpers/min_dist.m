function [x_new, y_new, theta_new] = min_dist(v1, v2, theta, lo, hi, dev_range)
    current_dist = dist(v1, v2);
    x_new = v1(1);
    y_new = v1(2);
    theta_new = theta;
    while dist([x_new, y_new], v2) >= current_dist
        [x_new, y_new, theta_new] = random_walk(v1(1), v1(2), theta_new, lo, hi, dev_range);
    end % while
end % min_dist