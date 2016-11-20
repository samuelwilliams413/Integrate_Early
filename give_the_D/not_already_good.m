function [far_away] = not_already_good (world, theta)
ANGLE_TOL = 30; %degrees
DIST_TOL = 0.75; %cm
far_away = true;
% 
% if ((theta < ANGLE_TOL) || (360 - theta) < ANGLE_TOL)
%     theta = 360 - theta;
%     %check angle
%     ANGLEISGOOD = [theta (360-theta)];
    
    % check xy
    x_diff = abs(world(1) - world(3));
    y_diff = abs(world(2) - world(4));
    
    xy = [x_diff y_diff];
    
    if((x_diff < DIST_TOL)  || (y_diff < DIST_TOL))
        far_away = false;
        return;
    end
    
%     
% end
% ANGLEISBAD = [theta (360-theta)];
end