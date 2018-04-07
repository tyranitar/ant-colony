close all;

cave_x = 10;
cave_y = 10;
spawned = 0;
num_ants = 10;
grid_size = 100;
max_iter = 1000;
delay = 0.01;

x = ones(num_ants, 1) * cave_x; % x coordinate of ant i.
y = ones(num_ants, 1) * cave_y; % y coordinate of ant i.
pos = zeros(grid_size); % Location matrix.
food = zeros(grid_size);
food(80:90, 80:90) = 1;
theta = rand(num_ants, 1) * 2 * pi; % Orientation of ant i.
has_food = zeros(num_ants, 1); % Does ant i have food?
pheromone = zeros(grid_size); % Pheromone matrix.
z = zeros(grid_size); % State matrix.

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

function ret = distance(x_1, y_1, x_2, y_2)
    ret = sqrt((x_2 - x_1) ^ 2 + (y_2 - y_1) ^ 2);
end

figure;
im = image(z);
for iter = 1:max_iter
    if spawned < num_ants && mod(iter, 10) == 0 % Spawn new ant.
        spawned += 1;
        pos(x(spawned), y(spawned)) += 1;
    end % if
    for i = 1:spawned % Move spawned ants.
        % Move ant out of current location.
        pos(x(i), y(i)) -= 1;
        if has_food(i)
            x_i = x(i);
            y_i = y(i);
            while distance(x_i, y_i, cave_x, cave_y) >= distance(x(i), y(i), cave_x, cave_y)
                % Compute new location.
                x_i = x(i) + round(cos(theta(i)));
                y_i = y(i) + round(sin(theta(i)));
                theta(i) += rand() * pi / 2 - pi / 4;
                % Normalize.
                x_i = bounded(x_i, 1, grid_size);
                y_i = bounded(y_i, 1, grid_size);
                theta(i) = wrapped(theta(i));
            end % while
            x(i) = x_i;
            y(i) = y_i;
            pos(x(i), y(i)) += 1;
            if x(i) == cave_x && y(i) == cave_y
                has_food(i) = 0;
            end % if
        else
            % Compute new location.
            x(i) += round(cos(theta(i)));
            y(i) += round(sin(theta(i)));
            theta(i) += rand() * pi / 2 - pi / 4;
            % Normalize.
            x(i) = bounded(x(i), 1, grid_size);
            y(i) = bounded(y(i), 1, grid_size);
            theta(i) = wrapped(theta(i));
            % Move ant into new location.
            pos(x(i), y(i)) += 1;
            if food(x(i), y(i))
                has_food(i) = 1;
            end
        end
    end % for
    pause(delay);
    z = zeros(grid_size);
    z(food > 0) = 60;
    z(pos > 0) = 20;
    set(im, 'CData', z); % Update image.
end % for