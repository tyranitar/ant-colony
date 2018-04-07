function [x_new, y_new, theta_new] = random_walk(x, y, theta, grid_size, dev_range)
    % Compute new location.
    x_new = x + round(cos(theta));
    y_new = y + round(sin(theta));
    theta_new = theta + dev_range * (rand() - 0.55);
    % Normalize.
    x_new = bounded(x_new, 1, grid_size);
    y_new = bounded(y_new, 1, grid_size);
    theta_new = wrapped(theta_new);
end % random_walk