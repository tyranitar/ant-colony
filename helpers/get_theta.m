function theta = get_theta(v1, v2)
    theta = cart2pol(v2(1) - v1(1), v2(2) - v1(2))(1);
end % get_theta