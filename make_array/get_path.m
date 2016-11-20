function [path] = get_path(start, finish, obstacles)
% [path] = get_path (start, finish, face_count)
% path = array of the points (in order) to be visited [x,y]
% start = intitial position [x,y]
% finish = final desired position [x,y]
% face_count = Sam's magic structure

start_fine = start;
finish_fine = finish;

%% DEMO
%  start = [1 1];
%  finish = [5 5];
% obstacles = [[2,1];[2,2];[2,3];[2,4];[2,5];[2,6];[2,8];[4,4];[4,5];[4,6];[4,7];[4,8];[4,9];[4,10];[5,4]];

start_fine = start;
finish_fine = finish;


%% Get values
 width = 16;
 height = 8;
% 
%  
%  start(1) = start(1) + offset;
%  finish(1) = finish(1) + offset;
 
 
% for i = 1:length(c_data)
%     rc = get_rc(c_data(i,:), resolution);
%         rc =rc/5
%     rc(1) = ceil(rc(1) + offset);
%     rc(2) = ceil(rc(2));
%     obstacles(i,:) = rc;
% end


% obstacles = [[2,1];[2,2];[2,3];[2,4];[2,5];[2,6];[2,8];[4,4];[4,5];[4,6];[4,7];[4,8];[4,9];[4,10];[5,4]];



%% Create struct
field0 = 'start';
value0 = start;
field1 = 'finish';
value1 = finish;
field2 = 'obstacles';
value2 = obstacles;
field3 = 'height';
value3 = height;
field4 = 'width';
value4 = width;

GAME = struct(field0, value0, field1, value1, field2, value2, field3, value3, field4, value4); 

%% Get path and post process
[path] = A_Star(GAME);
path = flipud(path);

path = [path];

end