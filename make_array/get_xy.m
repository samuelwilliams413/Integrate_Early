function [xy] = get_xy(rc, resolution);
%% [xy] = get_rc(rc, resolution);
    xy(1) = rc(1) * resolution;
    xy(2) = rc(2) * resolution;
end