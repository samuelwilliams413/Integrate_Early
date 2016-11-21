function [verified] = deadzone_custom(world)
        
    % Not reachable
    verified = 0;
    % Jimmy reach
    jimmyreach = 45;

    % Determine length of extension required for point
    req_length = ((world(1,1))^2 + (world(1,2))^2)^0.5;
    
    % Check length against length that Jimmy can reach
    if (req_length < jimmyreach) || (req_length == jimmyreach)
        verified = 1;
    end
    
end
    