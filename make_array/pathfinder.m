function [path] =  pathfinder (A, B, face_count)

offset = 40;

x1 = A(1);
y1 = A(2);
x2 = B(1);
y2 = B(2);

start = [x1 y1];
finish = [x2 y2];

dd = face_count.face_data;

for i = 1:length(dd(:,2))
    x = dd(i,3);
    y = dd(i,4);
    [xy] = start_pix_to_world(x, y);
    xy(1) = xy(1)  + offset;
    obstacles(i,1) = xy(1);
    obstacles(i,2) = xy(2);
end

start = floor(start/5);
finish =  floor(finish/5);
obstacles =  floor(obstacles/5);
% obstacles = [obstacles; [4 2]];

deadzone = get_deadzone();
obstacles = [obstacles; deadzone];
for i = 1:length(obstacles(:,1))
    if (obstacles(i,1) == 0 || obstacles(i,2) == 0)
        obstacles(i,:) = [];
    end
end
path = get_path(start, finish, obstacles);
end