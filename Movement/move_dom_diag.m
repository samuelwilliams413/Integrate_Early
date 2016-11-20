function [] = move_dom_diag(x1,y1,z1,x2)
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
     if x1>x2 && y1>y2
        for i=0:0.5:x1 - x2
            motor_mover_cart(x1 - i,y1 - i, z1)
        end

