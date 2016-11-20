function[] = jimmy_testing(prez_x, prez_y, x1, y1, z1, x2, y2)

%%%%%%%%%%%%%%
% Comment out for when running main loop

% loadlibrary('dynamixel','dynamixel.h');
% res = calllib('dynamixel','dxl_initialize', 17, 1);
% 
% speed = 500;
% slip_comp=1;
% calllib('dynamixel','dxl_write_word', 1, 32, speed);
% calllib('dynamixel','dxl_write_word', 2, 32, speed);
% calllib('dynamixel','dxl_write_word', 3, 32, speed);

%%%%%%%%%%%%%%%%

%for i=0:20:1300
%  motor_mover(1,i)
%end

%motor_mover_cart(0,20,-5)
if prez_x == 1000 && prez_y == 1000
    move_to_dom(x1,y1,z1);
    dynamixel_running()

    move_to_point(x1,y1,z1,x2,y2);
    dynamixel_running()

elseif prez_x ~= x1 && prez_y ~= y1
    init_motor_pos();
    dynamixel_running()
    
    move_to_dom(x1,y1,z1);
    dynamixel_running()

    move_to_point(x1,y1,z1,x2,y2);
    dynamixel_running()
else
    move_to_dom(x1,y1,z1);
    dynamixel_running()

    move_to_point(x1,y1,z1,x2,y2);
    dynamixel_running()
end 

%move_to_base(x1,y1,z1); %z1=-11
%pause(5)
%motor_mover_cart(0,11,-12);
%theta_comp = atand(theta)
%slip_comp*rotate(90); %-theta_comp
%move_from_base(x2,y2,z1);
%pause(0.5);
%init_motor_pos();

%%%%%%%%%%%%%
%Comment out for when running main loop


% calllib('dynamixel','dxl_terminate');
% unloadlibrary('dynamixel');
end