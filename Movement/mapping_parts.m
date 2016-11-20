% Array = [-15, 10; -15, 20; -10 20; -10, 25; 0 20; 10 20]
% prez_x = 1000
% prez_y = 1000
function [prez_x, prez_y] = mapping_parts(prez_x, prez_y, z1, Array)
%%%%%%%%%%%%%%
%Comment out for when running main loop
% loadlibrary('dynamixel','dynamixel.h');
% res = calllib('dynamixel','dxl_initialize', 17, 1);
% 
% z1 = -10;
% speed = 500;
% slip_comp=1;
% calllib('dynamixel','dxl_write_word', 1, 32, speed);
% calllib('dynamixel','dxl_write_word', 2, 32, speed);
% calllib('dynamixel','dxl_write_word', 3, 32, speed);
% init_motor_pos_up();
% dynamixel_running()

for i = 1:length(Array)-1
    x1 = Array(i,1);
    y1 = Array(i,2);
    
    x2 = Array(i+1,1);
    y2 = Array(i+1,2);
    
    jimmy_testing(prez_x, prez_y, x1, y1, z1, x2, y2);
    prez_x = x2;
    prez_y = y2;
    
end

%%%%%%%%%%%%%
%Comment out for when running main loop


% calllib('dynamixel','dxl_terminate');
% unloadlibrary('dynamixel');

end
    
    
    