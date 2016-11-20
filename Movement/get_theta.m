function [theta] = get_theta(xy1, xy2, phi)
d1 = atand(xy1(2)/xy1(1));
d1 = atand(xy2(2)/xy2(1));
delta = d1 - d2;
theta = phi - delta;
end