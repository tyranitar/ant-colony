function [p_found, x_p, y_p] = find_pheromone(pheromone, x, y)
    min_pheromone = inf;
    p_found = true;
    x_p = x;
    y_p = y;
    cnt = 0;
    for i = -1:1
        x_new = x + i;
        if x_new < 1 || x_new > size(pheromone, 1)
            continue;
        end % if
        for j = -1:1
            y_new = y + j;
            if y_new < 1 || y_new > size(pheromone, 2)
                continue;
            end % if
            if pheromone(x_new, y_new) > 0 && pheromone(x_new, y_new) < min_pheromone
                min_pheromone = pheromone(x_new, y_new);
                x_p = x_new;
                y_p = y_new;
                cnt += 1;
            end % if
        end % for
    end % for
    if cnt == 1 || x_p == x && y_p == y
        p_found = false;
    end % if
end