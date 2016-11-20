function [ startpoints_world] = start_pix_to_world( mid_x, mid_y)
%Given start centre point in pixels converts to world coordinates
%   assuming the origin is the arm pivot point
x_pixels = 1287;
y_pixels = 724;
x_world = 71.5;
y_world = 40.5;

x_cm_per_pix = x_world/x_pixels;
y_cm_per_pix = y_world/y_pixels;
origin_offset = 7.5;

start_mid_x_mm = ((mid_x*x_cm_per_pix)-(x_world*0.5)-2.69)*1.1;
start_mid_y_mm = ((y_pixels-mid_y)*y_cm_per_pix+origin_offset-4.2)*1.1;

startpoints_world = [start_mid_x_mm,start_mid_y_mm];

end

