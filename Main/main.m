function [] = main()
total_sorted = 0;

%Jimmy initialiser
loadlibrary('dynamixel','dynamixel.h');
res = calllib('dynamixel','dxl_initialize', 17, 1);

speed = 40;
slip_comp=1;
calllib('dynamixel','dxl_write_word', 1, 32, speed);
calllib('dynamixel','dxl_write_word', 2, 32, speed);
calllib('dynamixel','dxl_write_word', 3, 32, speed);
calllib('dynamixel','dxl_write_word', 4, 32, speed);

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
cam = webcam('Microsoft® LifeCam Studio(TM)');
cam.resolution = '1920x1080';
cam.Brightness=80;
% preview(cam);
filename = 'IMAGE.jpg';
img = get_img(cam);
img = get_img(cam);
img = get_img(cam);
index = 1;

while (1)
    here2 = 1;
    path = [0 0];
    
    % detect
    img = get_img(cam);
    img = get_img(cam);
    img = get_img(cam);
    imshow(img);
    imwrite(img,filename);
    close all
    figure();
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
        while verified(1,1) == 0
            [the_D, face_count] = get_next_domino(face_count);
            if face_count.index == -1
                continue
            end
            [world] = start_and_endpoints_world(the_D);
            
            while ~not_already_good(world, the_D(4))
                [the_D, face_count] = get_next_domino(face_count);
                if face_count.index == -1
                    continue
                end
                [world] = start_and_endpoints_world(the_D);
            end
            if face_count.index == -1
                continue
            end
            
            % Check if Jimmy can reach the domino
            [verified] = deadzone_custom(world);
            
            % Incase it doesn't break the loop properly
            if verified(1,1) == 1
                break
            end
            
        end
        
        if here2 == 0
            continue
        end
        figure();
        % move_to_origin
        % rotate
        % move_to_end
        x1 = world(1);
        y1 = world(2);
        x2 = world(3);
        y2 = world(4);
        theta = the_D(4);
        OI_BRADLEY = [x1 y1;x2 y2];
        pause(2)
        % RYAN LOOK HERE
        BASE = [40 10];
        A_start = [x1+40 y1];
        B_finish = [x2+40 y2];
        [path] =  pathfinder (A_start, BASE, face_count)*5 ;
        if length(path(:,1)) == 1
            if path == ([-1 -1]*5)
                init_motor_pos_up();
                pause(5);
                verified(1,1) = 0;
                h=msgbox('Sorry, No path exists to the Target!','warn');
                uiwait(h,5);
                continue
            end
        end
    end
    path = [A_start; path; BASE];
    for point = 1:length(path(:,1));
        path(point,1) = path(point,1) - 40;
    end
    [prez_x, prez_y] = mapping_parts(prez_x, prez_y, z1, path);
    dynamixel_running()
    pause(1)
    
    theta = mod((360 - theta),180);
    ANGLE_FOR_BRAD = theta;
    
    theta1 = theta;
    theta2 = atand(x1/y1);
    theta3 = atand(x2/y2);
    
    phi = theta1 + theta2 - theta3;
    phi = mod(phi,180)
    
    rotate(phi)
    pause(1);
    [path] =  pathfinder (BASE, B_finish, face_count)*5 ;
    if length(path(:,1)) == 1
        if path == ([-1 -1]*5)
            init_motor_pos_up();
            pause(5);
            continue
        end
    end
    path = [BASE; path; B_finish];
    for point = 1:length(path(:,1));
        path(point,1) = path(point,1) - 40;
    end
    [prez_x, prez_y] = mapping_parts(prez_x, prez_y, z1, path);
    dynamixel_running()
    pause(1)
    
    
    %     jimmy_testing(prez_x, prez_y, x1, y1, z1, b_x1, b_y1);
    %     prez_x = b_x1;
    %     prez_y = b_y1;
    %     dynamixel_running()
    %     %     pause(4)
    %
    %
    %     %motor_mover_cart(0,10,-12)
    %     %dynamixel_running()
    %
    %     %rotate(theta);
    %     dynamixel_running()
    %     %     pause(4)
    %     jimmy_testing(prez_x, prez_y, b_x1,b_y1,z1,x2,y2);
    
    
    init_motor_pos_up();
    prez_x = 1000;
    prez_y = 1000;
    dynamixel_running()
    pause(10)
    
end
end