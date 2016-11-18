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
x_pixels = 1286.4;
y_pixels = 723.6;
x_world = 695;
y_world = 395;
origin_offset = 60;

x_mm_per_pix = x_world/x_pixels;
y_mm_per_pix = y_world/y_pixels;

x_spacing = 55;
y_spacing = 30;

world = [];
for i = 1:length(data(:,1))
    j=(data(i,2)*x_mm_per_pix)-(x_world*0.5);
    k=(y_pixels-data(i,3))*y_mm_per_pix+origin_offset;
    world(i,1)=j;
    world(i,2)=k;
end
for i = 1:length(data(:,1))
    n = data(i,1)
    if n == 1 || n == 2 || n == 4 || n == 7 || n == 11 || n == 16 ||n == 22
        world(i,3)=0;
    elseif n == 3 || n == 5 || n == 8 || n == 12 || n ==17 || n = 23
        world(i,3)=0+x_spacing;
    elseif n == 6 || n == 9 || n == 13 || n == 18 || n == 24
        world(i,3)=0+x_spacing*2;
    elseif n == 10 || n == 14 || n == 19 || n == 25
        world(i,3)=0+x_spacing*3;
    elseif n == 15 || n == 20 || n == 26
        world(i,3)=0+x_spacing*4;
    elseif n == 21 || n == 27
        world(i,3)=0+x_spacing*5;
    elseif n == 28
        world(i,3)=0+x_spacing*6;
    end
end
for i = 1:length(data(:,1))
    n = data(i,1)
    if n == 1
        world(i,4)=420;
    elseif n == 2 || n == 3
        world(i,4)=420-y_spacing;
    elseif n == 4 || n == 5 || n == 6
        world(i,4)=420-y_spacing*2;
    elseif n == 7 || n == 8 || n == 9 || n == 10
        world(i,4)=420-y_spacing*3;
    elseif n == 11 || n == 12 || n ==13 || n == 14 || n ==15
        world(i,4)=420-y_spacing*4;
    elseif n == 16 || n == 17 || n == 18 || n == 19 || n == 20 || n == 21
        world(i,4)=420-y_spacing*5;
    elseif n == 22 || n == 23 || n == 24 || n == 25 || n == 26 || n == 27 || n == 28
        world(i,4)=420-y_spacing*6;
    end
end
    
end

