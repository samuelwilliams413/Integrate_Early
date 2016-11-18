function [grid] = fill_grid(start, finish, face_count);
%% [grid] = fill_grid(start, finish)

% e.g. 
% [grid] = fill_grid([2,1], [5,10], face_count)
% face_count = [100,100; 100,200; 100,300; 100,400; 200,200; 300,400; 500,400];
    resolution = [100,100];


    grid = make_grid();
    for i = 1:length(face_count)
        rc = get_rc(face_count(i,:), resolution);
        grid = set_grid_value(grid, rc, 3);
    end
    
     grid = set_grid_value(grid, start, 1);
     grid = set_grid_value(grid, finish, 2);

     
%      close all
%      bar3(grid)
    
end