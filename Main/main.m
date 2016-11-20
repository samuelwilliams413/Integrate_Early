function [] = main()
total_sorted = 0;

%Jimmy initialiser
loadlibrary('dynamixel','dynamixel.h');
res = calllib('dynamixel','dxl_initialize', 17, 1);

speed = 500;
slip_comp=1;
calllib('dynamixel','dxl_write_word', 1, 32, speed);
calllib('dynamixel','dxl_write_word', 2, 32, speed);
calllib('dynamixel','dxl_write_word', 3, 32, speed);

z1 = -11;
prez_x = 1000;
prez_y = 1000;
b_x1 = 0;
b_y1 = 10;
init_motor_pos_up();
pause(3);

% Camera initialiser
close all
clear cam
a=1
cam = webcam('Microsoft® LifeCam Studio(TM)');
cam.resolution = '1920x1080';
cam.Brightness=80;
% preview(cam);
filename = 'IMAGE.jpg';

index = 1;

while (1)
    close all
    % detect
    img = get_img(cam);
    imshow(img);
    imwrite(img,filename);
    [matches, dominos, finalfinallines, trackingin] = detection(img);
    % get_list
    
    if(length(matches) == 0)
        here1 = 0;
        continue
    end
    
    face_count = make_bag_o_D(trackingin, matches, filename);
    
    % get_next_d
    face_count.index = index;
    
    % Check that the arm can reach the domino, else re-detect
    % Initially set it that he cannot reach, and check until he can
    verified = [0];
    while verified(1,1) == 0
        % Get the domino values in pixels
        [the_D, face_count] = get_next_domino(face_count);
        if face_count.index == -1
            index = 1;
            face_count.index = 1;
            here2=0
            continue
        end
        index = face_count.index;
        % Convert the domino to cm's
        the_D
        [world] = start_and_endpoints_world(the_D)

        % Check if Jimmy can reach the domino
        [verified] = deadzone(world);
       
        % Incase it doesn't break the loop properly
        if verified(1,1) == 1
            break
        end
        
    end
    
    % move_to_origin
    % rotate
    % move_to_end
    x1 = world(1);
    y1 = world(2);
    x2 = world(3);
    y2 = world(4);
    theta = the_D(4);
    
    jimmy_testing(prez_x, prez_y, x1, y1, z1, b_x1, b_y1);
    prez_x = b_x1;
    prez_y = b_y1;
    dynamixel_running()
%     pause(4)
    
    
    %motor_mover_cart(0,10,-12)
    %dynamixel_running()
    
    %rotate(theta);
    dynamixel_running()
%     pause(4)
    
    jimmy_testing(prez_x, prez_y, b_x1,b_y1,z1,x2,y2);
    init_motor_pos_up();
    prez_x = 1000;
    prez_y = 1000;
    dynamixel_running()
    pause(10)
    
    
end
end