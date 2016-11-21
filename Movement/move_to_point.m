function move_to_point(x1,y1,z1,x2,y2)
% move_dom_x(x1,y1,z1,x2)
% move_dom_y(x2,y1,z1,y2)
speed = 100;
calllib('dynamixel','dxl_write_word', 1, 32, speed);
calllib('dynamixel','dxl_write_word', 2, 32, speed);
calllib('dynamixel','dxl_write_word', 3, 32, speed);

if y1 > 10
    move_dom_x(x1,y1,z1,x2)
    move_dom_y(x2,y1,z1,y2)
else
    move_dom_y(x1,y1,z1,y2)
    move_dom_x(x1,y2,z1,x2)
end

end