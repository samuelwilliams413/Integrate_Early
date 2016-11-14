function [] = move_dom_x(x1,y1,z1,x2)
    motor_mover_cart(x1,y1,z1);
    if x2>x1
        for i=x1:0.5:x2
            motor_mover_cart(i,y1,z1)
        end
    end
    if x1>x2
        for i=x1:-0.5:x2
            motor_mover_cart(i,y1,z1)
        end
    end
