function [] = init_motor_pos()
motor_mover(2, 211)
pause(1)
motor_mover(3, 350)
motor_mover(1, 511)
rotate(0)
end 