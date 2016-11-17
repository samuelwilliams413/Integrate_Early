function [ world ] = start_and_endpoints_world(data)
% Takes inputs from Sams data Assuming the following:
    % first col is index
    % second col is lowface
    % third col is highface
    % fourth col midx
    % fifth col midy
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
    j=(data(i,4)*x_mm_per_pix)-(x_world*0.5);
    k=(y_pixels-data(i,5))*y_mm_per_pix+origin_offset;
    world(i,1)=j;
    world(i,2)=k;
end
for i = 1:length(data(:,1))
    if data(i,2) == 0
        world(i,3)=0;
    elseif data(i,2) == 1
        world(i,3)=0+x_spacing;
    elseif data(i,2) == 2
        world(i,3)=0+x_spacing*2;
    elseif data(i,2) == 3
        world(i,3)=0+x_spacing*3;
    elseif data(i,2) == 4
        world(i,3)=0+x_spacing*4;
    elseif data(i,2) == 5
        world(i,3)=0+x_spacing*5;
    elseif data(i,2) == 6
        world(i,3)=0+x_spacing*6;
    end
end
for i = 1:length(data(:,1))
    if data(i,3) == 0
        world(i,4)=420;
    elseif data(i,3) == 1
        world(i,4)=420-y_spacing;
    elseif data(i,3) == 2
        world(i,4)=420-y_spacing*2;
    elseif data(i,3) == 3
        world(i,4)=420-y_spacing*3;
    elseif data(i,3) == 4
        world(i,4)=420-y_spacing*4;
    elseif data(i,3) == 5
        world(i,4)=420-y_spacing*5;
    elseif data(i,3) == 6
        world(i,4)=420-y_spacing*6;
    end
end
    
end

