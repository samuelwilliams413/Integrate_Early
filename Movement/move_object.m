function [] = move_object(x, y, z)
for i = 22:-0.5:y
    motor_mover_cart(x, i, z)
end 
end