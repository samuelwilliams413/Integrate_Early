function[] rotation_at_base(theta1)
    dominoLength = 15;
    theta2 = theta1 - arctand(x1/y1);
    motor_mover_cart(0, 10, 0);
    face_x = 10 + cosd(theta2);
    face_y = 0 + sind(theta2);
    motor_mover_cart(face_x, face_y, -11);
    theta3 = theta2 - arctand(x2/y2);
    rotate(theta3);
    motor_mover_cart(face_x, face_y, 0);
    