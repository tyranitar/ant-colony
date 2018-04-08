addpath('helpers');
close all;

% System parameters.
max_iter = inf; % Number of simulation iterations.
delay = 0; % Delay between draws; only set if the simulation is too fast.
grid_size = 200; % Size of simulation grid.
home_x = 10; % x coordinate of ant colony.
home_y = 10; % y coordinate of ant colony.
num_ants = 100; % Total number of ants.
spawn_period = 1; % Time between ant spawns.
dev_range = pi / 4; % Orientation deviation range.
counter_th = 250; % Threshold for retreating.
graph_period = 200; % Data sampling period.
walk_home = @directed_walk; % Algorithm for returning to colony.

% Boolean system parameters.
use_pheromone = true; % Use pheromone to find food.
show_image = true; % Display simulation in real-time.
show_graph = false; % Plot graph.
has_predator = false; % Is the predator on the prowl?
can_retreat = false; % Can the ants retreat to the colony?

% Assertions.
assert(max_iter > 0);
assert(delay >= 0);
assert(grid_size > 0 && grid_size < inf);
assert(home_x > 0 && home_x <= grid_size);
assert(home_y > 0 && home_y <= grid_size);
assert(num_ants > 0 && num_ants < inf);
assert(spawn_period > 0);
assert(dev_range < inf);
assert(counter_th >= 0);
assert(graph_period > 0);
assert(max_iter / graph_period >= 1);
assert(max_iter < inf || ~show_graph);

% Required variables.
x = ones(num_ants, 1) * home_x; % x coordinate of ant i.
y = ones(num_ants, 1) * home_y; % y coordinate of ant i.
theta = rand(num_ants, 1) * 2 * pi; % Orientation of ant i.
z = zeros(grid_size); % Location matrix.
food = zeros(grid_size); % Food matrix.
has_food = false(num_ants, 1); % Does ant i have food?
p_search = zeros(grid_size); % Search pheromone matrix.
p_return = zeros(grid_size); % Return pheromone matrix.
counter = zeros(num_ants, 1); % No encounter counter.
retreating = false(num_ants, 1); % Is ant i retreating?
inactive = false(num_ants, 1); % Is ant i inactive?
num_spawned = 0; % Number of spawned ants.
num_active = num_ants; % Number of active ants.
num_alive = num_ants; % Number of alive ants.

% Initialize food.
food_x = grid_size - home_x - 5:grid_size - home_x;
food_y = grid_size - home_y - 5:grid_size - home_y;
food(food_x, food_y) = 1;

% Initialize predator.
pred_x = round(rand() * (grid_size - 1) + 1);
pred_y = round(rand() * (grid_size - 1) + 1);
pred_theta = rand() * 2 * pi;

% Initialize main loop.
iter = 0;
if show_image
    im_data = zeros(grid_size); % Image data matrix.
    figure;
    im = image(im_data);
    axis equal;
    axis off;
end % if
if show_graph
    food_sum = 0;
    gr_data = zeros(floor(max_iter / graph_period), 1);
    gr_i = 1;
end % if

% Main loop.
while num_active > 0 && iter < max_iter
    if num_spawned < num_ants && mod(iter, spawn_period) == 0 % Spawn new ant.
        num_spawned += 1;
        z(x(num_spawned), y(num_spawned)) += 1;
    end % if
    for i = 1:num_spawned % Move spawned ants.
        if inactive(i)
            continue;
        end % if
        z(x(i), y(i)) -= 1; % Move ant out of current location.
        if has_predator && abs(x(i) - pred_x) < 2 && abs(y(i) - pred_y) < 2
            inactive(i) = true;
            num_active -= 1;
            num_alive -= 1;
            fprintf('ant %d devoured\n', i);
            fflush(stdout);
            continue;
        end % if
        if iter > grid_size && can_retreat && ~retreating(i) % Ignore the iterations where ants are still spreading out.
            if p_search(x(i), y(i)) > 0 || p_return(x(i), y(i)) > 0
                counter(i) = 0;
            else
                counter(i) += 1;
                if counter(i) > counter_th
                    retreating(i) = true;
                    fprintf('ant %d retreating\n', i);
                    fflush(stdout);
                end % if
            end % if
        end % if
        if has_food(i) % Return to colony with food.
            if ~retreating(i)
                p_return(x(i), y(i)) = 10; % Excrete return pheromone trail.
            end % if
            [x(i), y(i), theta(i)] = walk_home([x(i), y(i)], [home_x, home_y], theta(i), 1, grid_size, dev_range);
            if x(i) == home_x && y(i) == home_y % Successfully brought food back to colony.
                if show_graph
                    food_sum += 1;
                end % if
                has_food(i) = false;
            end % if
        elseif can_retreat && retreating(i)
            if x(i) == home_x && y(i) == home_y
                inactive(i) = true;
                num_active -= 1;
                continue;
            end % if
            [x(i), y(i), theta(i)] = walk_home([x(i), y(i)], [home_x, home_y], theta(i), 1, grid_size, dev_range);
        else % Search for food.
            p_search(x(i), y(i)) = 10; % Excrete search pheromone trail.
            [p_found, x_p, y_p] = find_pheromone(p_return, x(i), y(i));
            if use_pheromone && p_found % Return pheromone trail found.
                theta(i) = get_theta([x(i), y(i)], [x_p, y_p]); % Orient ant in trail direction.
                x(i) = x_p;
                y(i) = y_p;
            else % No return pheromone trail found; random walk.
                [x(i), y(i), theta(i)] = random_walk(x(i), y(i), theta(i), 1, grid_size, dev_range);
            end % if
            if food(x(i), y(i)) % Found food.
                has_food(i) = true;
            end % if
        end % if
        z(x(i), y(i)) += 1; % Move ant into new location.
    end % for
    if has_predator
        [pred_x, pred_y, pred_theta] = random_walk(pred_x, pred_y, pred_theta, 2, grid_size - 1, dev_range);
    end % if
    if show_image
        im_data = zeros(grid_size);
        im_data(home_x, home_y) = -60;
        im_data(food > 0) = 60;
        im_data(p_search > 0) = 10 + p_search(p_search > 0);
        im_data(p_return > 0) = 60 - p_return(p_return > 0);
        im_data(z > 0) = 30;
        if has_predator
            im_data(pred_x - 1:pred_x + 1, pred_y - 1:pred_y + 1) = 40;
        end % if
        pause(delay);
        set(im, 'CData', im_data); % Update image.
    end % if
    if show_graph && mod(iter, graph_period) == 0
        gr_data(gr_i) = food_sum;
        food_sum = 0;
        gr_i += 1;
        disp(iter);
        fflush(stdout);
    end % if
    p_search(p_search > 0) -= 0.5; % Search pheromone evaporation.
    p_return(p_return > 0) -= 0.1; % Return heromone evaporation.
    iter += 1;
end % while

% Remaining ants.
if has_predator
    fprintf('ants remaining: %d\n', num_alive);
end % if

% Graph.
if show_graph
    figure;
    plot(gr_data);
    axis equal;
end % if