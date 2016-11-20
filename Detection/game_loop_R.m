function [matches, dominos, finalfinallines, trackingin] = game_loop_R(cameraParams)
close all
clear cam
filename = 'IMAGE.jpg';
% 
% cam = webcam('Microsoft� LifeCam Studio(TM)');
% cam.resolution = '1920x1080';
% cam.Brightness=80;
% preview(cam);
% pause(5);

while 1  
%     img = get_img(cam, cameraParams);
%     imshow(img);
%     imwrite(img, filename);
    
    % REMOVE THIS LINE
    img = imread(filename);

    [matches, dominos, finalfinallines, trackingin] = detection(img);
    [face_count] = make_bag_o_D(trackingin, matches, filename);
    [the_D, face_count] = get_next_domino(face_count);
    [the_D, face_count] = get_next_domino(face_count);
    [the_D, face_count] = get_next_domino(face_count);
    
    break
end

end