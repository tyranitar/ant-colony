close all;

cave_x = 10;
cave_y = 10;
spawned = 0;
num_ants = 10;
grid_size = 100;
max_iter = 1000;
delay = 0.025;

x = ones(num_ants, 1) * cave_x; % x coordinate of ant i.
y = ones(num_ants, 1) * cave_y; % y coordinate of ant i.
z = zeros(grid_size); % Location state matrix.
theta = rand(num_ants, 1) * 2 * pi; % Orientation of ant i.
has_food = zeros(num_ants, 1); % Does ant i have food?
p_search = zeros(grid_size); % Search pheromone matrix.
p_return = zeros(grid_size); % Return pheromone matrix.

function x_new = bounded(x_old, lo, hi)
    if x_old < lo
        x_new = lo;
    elseif x_old > hi
        x_new = hi;
    else
        x_new = x_old;
    end % if
end

function theta_new = wrapped(theta_old)
    if theta_old < 0
        theta_new = 2 * pi - theta_old;
    elseif theta_old > 2 * pi
        theta_new = theta_old - 2 * pi;
    else
        theta_new = theta_old;
    end % if
end

figure;
im = image(z);
for iter = 1:max_iter
    if spawned < num_ants && mod(iter, 10) == 0
        spawned += 1;
        z(x(spawned), y(spawned)) += 1;
    end % if
    for i = 1:spawned
        % Move ant out of current location.
        z(x(i), y(i)) -= 1;
        % Compute new location.
        x(i) += round(cos(theta(i)));
        y(i) += round(sin(theta(i)));
        theta(i) += rand() * pi / 2 - pi / 4;
        % Normalize.
        x(i) = bounded(x(i), 1, grid_size);
        y(i) = bounded(y(i), 1, grid_size);
        theta(i) = wrapped(theta(i));
        % Move ant into new location.
        z(x(i), y(i)) += 1;
    end % for
    pause(delay);
    set(im, 'CData', z * 100); % Update image.
end % for