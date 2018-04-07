function [x_new, y_new, theta_new] = directed_walk(v1, v2, theta, grid_size, dev_range)
    dev_factor = 1;
    % Compute new location.
    theta_new = get_theta(v1, v2) + dev_factor * dev_range * (rand() - 0.5);
    x_new = v1(1) + round(cos(theta_new));
    y_new = v1(2) + round(sin(theta_new));
    % Normalize.
    theta_new = wrapped(theta_new);
    x_new = bounded(x_new, 1, grid_size);
    y_new = bounded(y_new, 1, grid_size);
end % directed_walk