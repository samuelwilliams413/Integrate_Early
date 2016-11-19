function [ world ] = start_and_endpoints_world(data)
% Takes inputs from Sams data Assuming the following:
    % first col is index
    % second col is midx
    % third col is midy
    % fourth col theta
% converts the start and endpoints in pixels to mm values from the defined...
...orign at the arm base
% sets up end points based on pyramid layout with the top (0,0) domino...
...directly in front of the arm at close to its max reach
% data = [index middle_x middle_y theta]

x_pixels = 1287;
y_pixels = 724;
x_world = 71.5;
y_world = 40.5;
origin_offset = 7.5;

x_cm_per_pix = x_world/x_pixels;
y_cm_per_pix = y_world/y_pixels;

dom_1_x = 0;
dom_1_y = 36;
x_spacing = 5.5;
y_spacing = 3.0;

world = [];
for i = 1:length(data(:,1))
    j=(data(i,2)*x_cm_per_pix)-(x_world*0.5)-3.5;
    k=(y_pixels-data(i,3))*y_cm_per_pix+origin_offset-2.3;
    world(i,1)=j;
    world(i,2)=k;
end
for i = 1:length(data(:,1))
    n = data(i,1);
    if n == 1 || n == 3 || n == 6 || n == 10 || n == 15 || n == 21 ||n == 28
        world(i,3)=dom_1_x;
    elseif n == 2 || n == 5 || n == 9 || n == 14 || n == 20 || n == 27
        world(i,3)=dom_1_x+x_spacing;
    elseif n == 4 || n == 8 || n == 13 || n == 19 || n == 26
        world(i,3)=dom_1_x+x_spacing*2;
    elseif n == 7 || n == 12 || n == 18 || n == 25
        world(i,3)=dom_1_x+x_spacing*3;
    elseif n == 11 || n == 17 || n == 24
        world(i,3)=dom_1_x+x_spacing*4;
    elseif n == 16 || n == 23
        world(i,3)=dom_1_x+x_spacing*5;
    elseif n == 22
        world(i,3)=dom_1_x+x_spacing*6;
    end
end
for i = 1:length(data(:,1))
    n = data(i,1);
    if n == 1
        world(i,4) = dom_1_y;
    elseif n == 2 || n == 3
        world(i,4)= dom_1_y-y_spacing;
    elseif n == 4 || n == 5 || n == 6
        world(i,4)= dom_1_y-y_spacing*2;
    elseif n == 7 || n == 8 || n == 9 || n == 10
        world(i,4)=dom_1_y-y_spacing*3;
    elseif n == 11 || n == 12 || n ==13 || n == 14 || n ==15
        world(i,4)= dom_1_y-y_spacing*4;
    elseif n == 16 || n == 17 || n == 18 || n == 19 || n == 20 || n == 21
        world(i,4)=dom_1_y-y_spacing*5;
    elseif n == 22 || n == 23 || n == 24 || n == 25 || n == 26 || n == 27 || n == 28
        world(i,4)=dom_1_y-y_spacing*6;
    end
end
    
end

