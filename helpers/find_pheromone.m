function [p_found, x_p, y_p] = find_pheromone(p_search, p_return, x, y, lo, hi)
    min_pheromone = inf;
    p_found = true;
    x_p = x;
    y_p = y;
    cnt = 0;
    for i = -1:1
        x_new = x + i;
        if x_new < lo || x_new > hi
            continue;
        end % if
        for j = -1:1
            y_new = y + j;
            if y_new < lo || y_new > hi
                continue;
            end % if
            if p_return(x_new, y_new) > 0
                cnt += 1;
                if p_return(x_new, y_new) < min_pheromone
                    min_pheromone = p_return(x_new, y_new);
                    x_p = x_new;
                    y_p = y_new;
                end % if
            end % if
        end % for
    end % for
    if cnt < 2 || x_p == x && y_p == y || ... % Is the ant tailing a pheromone trail or stuck?
        p_return(x, y) > 0 && p_search(x_p, y_p) > 0 && p_search(x_p, y_p) < p_search(x, y)
        p_found = false;
    end % if
end % find_pheromone