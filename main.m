addpath('helpers');
close all;

home_x = 10;                        % x coordinate of ant colony.
home_y = 10;                        % y coordinate of ant colony.
num_ants = 100;                     % Total number of ants.
num_spawned = 0;                    % Number of spawned ants.
grid_size = 200;                    % Size of simulation grid.
max_iter = 10000;                   % Number of simulation iterations.
dev_range = pi / 4;                 % Orientation deviation range.
delay = 0;                          % Delay between draws; only set if the simulation is too fast.
walk_home = @directed_walk;

x = ones(num_ants, 1) * home_x;     % x coordinate of ant i.
y = ones(num_ants, 1) * home_y;     % y coordinate of ant i.
z = zeros(grid_size);               % Location matrix.
food = zeros(grid_size);            % Food matrix.
theta = rand(num_ants, 1) * 2 * pi; % Orientation of ant i.
has_food = zeros(num_ants, 1);      % Does ant i have food?
p_return = zeros(grid_size);        % Return pheromone matrix.
im_data = zeros(grid_size);         % Image data matrix.
food(grid_size - home_x - 10:grid_size - home_x, grid_size - home_y - 10:grid_size - home_y) = 1;

figure;
im = image(im_data);
axis equal;
axis off;
for iter = 1:max_iter
    if num_spawned < num_ants && mod(iter, 10) == 0 % Spawn new ant.
        num_spawned += 1;
        z(x(num_spawned), y(num_spawned)) += 1;
    end % if
    for i = 1:num_spawned % Move spawned ants.
        z(x(i), y(i)) -= 1; % Move ant out of current location.
        if has_food(i)
            p_return(x(i), y(i)) = 10; % Leave pheromone trail.
            [x(i), y(i), theta(i)] = walk_home([x(i), y(i)], [home_x, home_y], theta(i), grid_size, dev_range);
            if x(i) == home_x && y(i) == home_y
                has_food(i) = 0;
            end % if
        else
            [p_found, x_p, y_p] = find_pheromone(p_return, x(i), y(i));
            if p_found
                theta(i) = get_theta([x(i), y(i)], [x_p, y_p]);
                x(i) = x_p;
                y(i) = y_p;
            else
                [x(i), y(i), theta(i)] = random_walk(x(i), y(i), theta(i), grid_size, dev_range);
            end % if
            if food(x(i), y(i))
                has_food(i) = 1;
            end % if
        end % if
        z(x(i), y(i)) += 1; % Move ant into new location.
    end % for
    im_data = zeros(grid_size);
    im_data(food > 0) = 60;
    im_data(p_return > 0) = 40 + p_return(p_return > 0);
    im_data(z > 0) = 20;
    pause(delay);
    set(im, 'CData', im_data); % Update image.
    p_return(p_return > 0) -= 0.1; % Pheromone evaporation.
end % for