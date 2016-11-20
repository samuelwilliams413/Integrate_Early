function [rc] = get_rc(xy, resolution);
%% [rc] = get_rc(xy, resolution);
off = 2;
x = xy(1+off);
y = xy(2+off);
%     rc(1) = ceil(xy(1+off)/resolution(1));
%     rc(2) = ceil(xy(2+off)/resolution(2));
rc = start_pix_to_world( x , y);
end