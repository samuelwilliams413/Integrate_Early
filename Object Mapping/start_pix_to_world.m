function [ startpoints_world] = start_pix_to_world( mid_x, mid_y)
%Given start centre point in pixels converts to world coordinates
%   assuming the origin is the arm pivot point
x_pixels = 1286.4;
y_pixels = 723.6;
x_world = 695;
y_world = 395;

x_mm_per_pix = x_world/x_pixels;
y_mm_per_pix = y_world/y_pixels;

origin_offset = 60;

start_mid_x_mm = (mid_x*x_mm_per_pix)-(x_world*0.5);
start_mid_y_mm = (y_pixels-mid_y)*y_mm_per_pix+origin_offset;

startpoints_world = [start_mid_x_mm,start_mid_y_mm]

end

