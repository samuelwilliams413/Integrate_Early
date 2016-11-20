function [] = init_motor_pos_up()
motor_mover(2, 211)
pause(1)
motor_mover(3, 821)
motor_mover(1, 511)
rotate(0)

end 