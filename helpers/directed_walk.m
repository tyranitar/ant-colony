function [x_new, y_new, theta_new] = directed_walk(v1, v2, theta, lo, hi, dev_range)
    dev_factor = 2;
    % Compute new location.
    theta_new = get_theta(v1, v2) + dev_factor * dev_range * (rand() - 0.5);
    x_new = v1(1) + round(cos(theta_new));
    y_new = v1(2) + round(sin(theta_new));
    % Normalize.
    theta_new = wrapped(theta_new);
    x_new = bounded(x_new, lo, hi);
    y_new = bounded(y_new, lo, hi);
end % directed_walk