function [far_away] = not_already_good (world, theta)
ANGLE_TOL = 15; %degrees
DIST_TOL = 1.5; %cm
far_away = true;

%check angle
if (theta < ANGLE_TOL || (360-theta) <ANGLE_TOL)
    far_away = false;
    return;
end

% check xy
x_diff = abs(world(1) - world(3));
y_diff = abs(world(2) - world(4));

if((x_diff < DIST_TOL)  || (y_diff < DIST_TOL))
    far_away = false;
    return;
end
end