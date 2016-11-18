function [grid] = fill_grid(start, finish, face_count);
%% [grid] = fill_grid(start, finish)
Obstacle=-1;
Target = 0;
Robot=1;
Space=2;

face_data = face_count.face_data;
% e.g.
% [grid] = fill_grid([2,1], [2,2], face_count)
% face_data = [100,100; 100,200; 100,300; 100,400; 200,200; 300,400; 500,400];
resolution = [100,100];



grid = make_grid();
for i = 1:length(face_data)
    
    rc = get_rc(face_data(i,:), resolution);
    grid = set_grid_value(grid, rc, Obstacle);
end

grid = set_grid_value(grid, start, Robot);
grid = set_grid_value(grid, finish, Target);


%      close all
%      bar3(grid)
end