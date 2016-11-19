function [] = main()
total_sorted = 0;

% Camera initialiser
close all
clear cam
cam = webcam('Microsoft® LifeCam Studio(TM)');
cam.resolution = '1920x1080';
cam.Brightness=80;
preview(cam);
filename = 'IMAGE.jpg';
z1 = -11;

while (1)
    % detect
    img = get_img(cam);
    imshow(img);
    imwrite(img,filename);
    [matches, dominos, finalfinallines, trackingin] = detection(img);
    % get_list
    face_count = make_bag_o_D(trackingin, matches, filename);
    % get_next_d
    [the_D, face_count] = get_next_domino(face_count);
    % convert
    [world] = start_and_endpoints_world(the_D);
    % move_to_origin
    % rotate
    % move_to_end
    x1 = world(1);
    y1 = world(2);
    x2 = world(3);
    y2 = world(4);
    theta = the_D(4);
    jimmy_testing(x1,y1,z1,x2,y2,theta);
    
end
end