function [x_new, y_new, theta_new] = random_walk(x, y, theta, lo, hi, dev_range)
    % Compute new location.
    x_new = x + round(cos(theta));
    y_new = y + round(sin(theta));
    theta_new = theta + dev_range * (rand() - 0.52);
    % Normalize.
    x_new = bounded(x_new, lo, hi);
    y_new = bounded(y_new, lo, hi);
    if x_new == x && y_new == y
        theta_new = rand() * 2 * pi; % Stop being stuck.
    else
        theta_new = wrapped(theta_new);
    end % if
end % random_walk