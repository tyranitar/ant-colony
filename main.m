close all;

cave_x = 1;
cave_y = 1;
num_ants = 10;
grid_size = 100;
max_iter = 1000;

x = ones(num_ants, 1); % x coordinate of ant i.
y = ones(num_ants, 1); % y coordinate of ant i.
z = zeros(grid_size); % Location state matrix.
has_food = zeros(num_ants, 1); % Does ant i have food?
p_search = zeros(grid_size); % Search pheromone matrix.
p_return = zeros(grid_size); % Return pheromone matrix.

figure;
im = image(z);
for iter = 1:max_iter
    for i = 1:num_ants
        x_i = x(i);
        y_i = y(i);
        while x_i == x(i) && y_i == y(i)
            if x_i == 1
                x_i += [0, 1](randi(2));
            elseif x_i == grid_size
                x_i += [-1, 0](randi(2));
            else
                x_i += [-1, 0, 1](randi(3));
            end % if
            if y_i == 1
                y_i += [0, 1](randi(2));
            elseif y_i == grid_size
                y_i += [-1, 0](randi(2));
            else
                y_i += [-1, 0, 1](randi(3));
            end % if
        end % while
        % Move ant.
        z(x(i), y(i)) -= 100;
        z(x_i, y_i) += 100;
        % Update ant position.
        x(i) = x_i;
        y(i) = y_i;
    end % for
    pause(0.01);
    set(im, 'CData', z); % Update image.
end % for