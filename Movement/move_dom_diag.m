function [] = move_dom_diag(x1,y1,z1,x2,y2)
speed = 50;
calllib('dynamixel','dxl_write_word', 1, 32, speed);
calllib('dynamixel','dxl_write_word', 2, 32, speed);
calllib('dynamixel','dxl_write_word', 3, 32, speed);
    motor_mover_cart(x1,y1,z1);
    if x2>x1 && y2>y1
        for i=0:0.5:x2 - x1
            motor_mover_cart(x1 + i,y1 + i,z1)
        end
    end
    if x1>x2 && y2>y1
        for i=0:0.5:x1 - x2
            motor_mover_cart(x1 - i,y1 + i, z1)
        end
    end
    if x2>x1 && y1>y2
        for i=0:0.5:x2 - x1
            motor_mover_cart(x1 + i,y1 - i,z1)
        end
    end
     if x1>x2 && y1>y2
        for i=0:0.5:x1 - x2
            motor_mover_cart(x1 - i,y1 - i, z1)
        end
     end
end

