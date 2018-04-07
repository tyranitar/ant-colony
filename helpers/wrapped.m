function theta_new = wrapped(theta)
    if theta < 0
        theta_new = 2 * pi - theta;
    elseif theta > 2 * pi
        theta_new = theta - 2 * pi;
    else
        theta_new = theta;
    end % if
end % wrapped