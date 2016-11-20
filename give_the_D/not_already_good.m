function [far_away] = not_already_good (world, theta)
ANGLE_TOL = 30; %degrees
DIST_TOL = 1.5; %cm
far_away = true;
theta_test = theta + 360 + 360 - 270;
theta_test = mod(theta_test,360);
if ((abs(90-theta_test) < ANGLE_TOL))

    %check angle
    ANGLEISGOOD = [theta_test]
    
    % check xy
    x_diff = abs(world(1) - world(3));
    y_diff = abs(world(2) - world(4));
    
    xy = [x_diff y_diff];
    
    if((x_diff < DIST_TOL)  || (y_diff < DIST_TOL))
        far_away = false;
        xy_is_good = [x_diff y_diff];
        return;
    end
    
    XY_IS_BAD = xy
    
    
end
ANGLEISBAD = [theta]
end