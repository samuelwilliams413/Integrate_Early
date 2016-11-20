function [rc] = get_rc(xy, resolution);
%% [rc] = get_rc(xy, resolution);
    off = 2;

    rc(1) = ceil(xy(1+off)/resolution(1));
    rc(2) = ceil(xy(2+off)/resolution(2));
end