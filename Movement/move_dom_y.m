function [] = move_dom_y(x1,y1,z1,y2)
    motor_mover_cart(x1,y1,z1);
    if y2>y1
        for j=y1:0.5:y2
            motor_mover_cart(x1,j,z1)
        end
    end
    if y2<y1
        for j = y1:-0.5:y2
            motor_mover_cart(x1,j,z1)
        end
end
