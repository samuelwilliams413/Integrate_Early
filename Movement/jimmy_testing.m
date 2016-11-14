function[] = jimmy_testing(x1,y1,z1,x2,y2)

loadlibrary('dynamixel','dynamixel.h');
res = calllib('dynamixel','dxl_initialize', 17, 1)

speed = 500;
calllib('dynamixel','dxl_write_word', 1, 32, speed);
calllib('dynamixel','dxl_write_word', 2, 32, speed);
calllib('dynamixel','dxl_write_word', 3, 32, speed);



%for i=0:20:1300
  %  motor_mover(1,i)
%end

 %motor_mover_cart(0,20,-5)
 
 init_motor_pos();
 motor_mover(4,0)
 pause(2)
 move_to_base(x1,y1,z1); %z1=-11
 pause(.5)
 motor_mover_cart(0,11,-13);
 rotate(90);
 move_from_base(x2,y2,z1);
 pause(0.5);
 init_motor_pos();
 
 
calllib('dynamixel','dxl_terminate');  
%unloadlibrary('dynamixel');

