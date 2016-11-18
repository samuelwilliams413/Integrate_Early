function [path] = get_path(start, finish, face_count)
 width = 10;
 height = 10;
 
face_data = face_count.face_data;
resolution = [100,100];
for i = 1:length(face_data)
    rc = get_rc(face_data(i,:), resolution);
    obstacles(i,:) = rc;
end

close all
start = [1 1];
finish = [5 5];
%obstacles = [[2,1];[2,2];[2,3];[2,4];[2,5];[2,6];[2,8];[4,4];[4,5];[4,6];[4,7];[4,8];[4,9];[4,10];[5,4]];

field0 = 'start';
value0 = start;
field1 = 'finish';
value1 = finish;
field2 = 'obstacles';
value2 = obstacles;
field3 = 'height';
value3 = 10;
field4 = 'width';
value4 = 10;

GAME = struct(field0, value0, field1, value1, field2, value2, field3, value3, field4, value4); 

[path] = A_Star(GAME);
path(:,1) = path(:,1)*resolution(1);
path(:,2) = path(:,2)*resolution(2);
path = flipud(path)
end