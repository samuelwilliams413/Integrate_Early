% Initialise variables describing the current state of the motors
moving1 = 1;
moving2 = 0;
moving3 = 0;
moving4 = 0;

% Run while the motors are moving
while (moving1 || moving2 || moving3 || moving4)
    moving1 = int32(calllib('dynamixel','dxl_read_byte',1,46));
    moving2 = int32(calllib('dynamixel','dxl_read_byte',2,46));
    moving3 = int32(calllib('dynamixel','dxl_read_byte',3,46));
    moving4 = int32(calllib('dynamixel','dxl_read_byte',4,46));
end
