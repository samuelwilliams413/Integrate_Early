function [far_away] = not_already_good (world, theta)
ANGLE_TOL = 180; %degrees
DIST_TOL = 4; %cm
far_away = true;
if ((abs(theta) < ANGLE_TOL))
    
    %check angle
    ANGLE_IS_GOOD = [theta];
    
    % check xy
    x_diff = abs(world(1) - world(3));
    y_diff = abs(world(2) - world(4));
    
    xy = [x_diff y_diff];
    
    if((x_diff < DIST_TOL)  && (y_diff < DIST_TOL))
        far_away = false;
        xy_is_good = [x_diff y_diff]
        return;
    else
        
        XY_IS_BAD = xy
        return;
    end
    
    
% end
ANGLEISBAD = [theta]
end