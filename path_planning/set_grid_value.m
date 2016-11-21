function [grid] = set_grid_value(grid, rc, value);
%% [grid] = set_grid_value(grid, rc, value);
    grid(rc(2), rc(1)) = value;
end