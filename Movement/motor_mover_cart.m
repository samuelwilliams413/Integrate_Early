function [] = motor_mover_cart(x, y, z)
L1 = 19;
L2 = 25.4;
h1 = 10;
ratio = 512/150;
%z = z - h1;

% Motor 1 calcs
if x == 0
    alpha1 = 90;
    theta1 = 511;
elseif x > 0
    alpha1 = atand(x/y);
    theta1 = 511 - alpha1*ratio;
    
else x < 0
    alpha1 = atand(x/y);
    theta1 = 511 - alpha1*ratio;
end

% Motor 3 calcs
a = sqrt(x^2+y^2+z^2);

alpha4 = acosd((a^2-L1^2-L2^2)/(-2*L1*L2))
theta4 = alpha4*ratio;
alpha3 = 180 - alpha4
theta3 = 811 - alpha3*ratio

% Motor 2 calcs
alpha2_2 = acosd((L2^2-a^2-L1^2)/(-2*a*L1));
alpha5 = 0;

if z ~= 0
    alpha5 = asind(z/a);
end 

alpha6 = alpha2_2;
alpha6 = alpha2_2 + alpha5;
theta2 = 511 - alpha6*ratio

motor_mover(1, theta1);
motor_mover(2, theta2);
motor_mover(3, theta3);

end